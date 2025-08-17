import Razorpay from 'razorpay';
import { createHmac } from 'crypto';
import { API_CONFIG, STATUS_CODES } from '../config/constants.js';
import WalletTransaction from '../models/walletTx.js';

class RazorpayController {
  constructor() {
    const keyId = API_CONFIG.RAZORPAY.KEY_ID;
    const keySecret = API_CONFIG.RAZORPAY.KEY_SECRET;

    if (!keyId || !keySecret) {
      console.warn('[Razorpay] Missing RAZORPAY_KEY_ID/RAZORPAY_KEY_SECRET in environment. Create your .env.');
      // Do NOT instantiate to avoid throwing at import time
      this.instance = null;
      return;
    }

    this.instance = new Razorpay({
      key_id: keyId,
      key_secret: keySecret,
    });
  }

  // Return public key for client initialization
  getPublicKey = async (req, res) => {
    try {
      const publicKey = API_CONFIG.RAZORPAY.KEY_ID_PUBLIC || API_CONFIG.RAZORPAY.KEY_ID;
      if (!publicKey) {
        return res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
          success: false,
          message: 'Razorpay public key not configured',
        });
      }
      res.status(STATUS_CODES.SUCCESS).json({ success: true, data: { key: publicKey } });
    } catch (error) {
      console.error('Razorpay getPublicKey error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({ success: false, message: 'Failed to fetch key' });
    }
  };

  // Create Razorpay order for specified amount (in INR)
  createOrder = async (req, res) => {
    try {
      const userId = req.user?.userId;
      const { amount } = req.body;

      if (!userId) {
        return res.status(STATUS_CODES.UNAUTHORIZED).json({ success: false, message: 'Unauthorized' });
      }
      if (!amount || Number(amount) <= 0) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({ success: false, message: 'Invalid amount' });
      }

      // Lazy-init in case keys were loaded after process start
      if (!this.instance?.orders) {
        const keyId = API_CONFIG.RAZORPAY.KEY_ID;
        const keySecret = API_CONFIG.RAZORPAY.KEY_SECRET;
        if (keyId && keySecret) {
          this.instance = new Razorpay({ key_id: keyId, key_secret: keySecret });
        }
      }
      if (!this.instance?.orders) {
        return res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({ success: false, message: 'Razorpay not initialized' });
      }

      const options = {
        amount: Math.round(Number(amount) * 100), // to paise
        currency: 'INR',
        receipt: `order_rcpt_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`,
        notes: { userId },
      };

      const order = await this.instance.orders.create(options);

      return res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          orderId: order.id,
          amount: order.amount,
          currency: order.currency,
        },
      });
    } catch (error) {
      console.error('Razorpay createOrder error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({ success: false, message: 'Failed to create order', error: error.message });
    }
  };

  // Verify Razorpay signature and credit wallet
  verifyPayment = async (req, res) => {
    try {
      const userId = req.user?.userId;
      const { razorpay_order_id, razorpay_payment_id, razorpay_signature, amount } = req.body;

      if (!userId) {
        return res.status(STATUS_CODES.UNAUTHORIZED).json({ success: false, message: 'Unauthorized' });
      }

      if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature || !amount) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({ success: false, message: 'Missing payment details' });
      }

      const keySecret = API_CONFIG.RAZORPAY.KEY_SECRET;
      if (!keySecret) {
        return res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({ success: false, message: 'Razorpay secret not configured' });
      }

      const expectedSignature = createHmac('sha256', keySecret)
        .update(`${razorpay_order_id}|${razorpay_payment_id}`)
        .digest('hex');

      if (expectedSignature !== razorpay_signature) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({ success: false, message: 'Invalid payment signature' });
      }

      // Record credit transaction
      const tx = new WalletTransaction({
        userId,
        type: 'credit',
        amount: Number(amount),
        description: 'Add money via Razorpay',
        status: 'success',
        transactionId: razorpay_payment_id,
        metadata: {
          gateway: 'razorpay',
          orderId: razorpay_order_id,
          signature: razorpay_signature,
        },
      });

      await tx.save();

      return res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          transactionId: tx.transactionId,
          amount: tx.amount,
          status: tx.status,
        },
      });
    } catch (error) {
      console.error('Razorpay verifyPayment error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({ success: false, message: 'Payment verification failed', error: error.message });
    }
  };
}

export default new RazorpayController();