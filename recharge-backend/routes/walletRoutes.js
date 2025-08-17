import express from 'express';
import walletController from '../controllers/walletController.js';
import authMiddleware from '../middleware/authMiddleware.js';
import razorpayController from '../controllers/razorpayController.js';

const router = express.Router();

// Public route: public key can be exposed safely
router.get('/razorpay/key', razorpayController.getPublicKey);

// Apply authentication middleware to all remaining wallet routes
router.use(authMiddleware);

// Get wallet balance
router.get('/balance', walletController.getBalance);

// Add money to wallet (non-gateway immediate credit; kept for compatibility)
router.post('/add-money', walletController.addMoney);

// Razorpay integration routes (require auth)
router.post('/razorpay/order', razorpayController.createOrder);
router.post('/razorpay/verify', razorpayController.verifyPayment);

// Get transaction history
router.get('/transactions', walletController.getTransactions);

// Get transaction by ID
router.get('/transactions/:transactionId', walletController.getTransactionById);

// Transfer money
router.post('/transfer', walletController.transferMoney);

// Get wallet summary
router.get('/summary', walletController.getWalletSummary);

export default router;
