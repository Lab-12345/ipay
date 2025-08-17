import { STATUS_CODES } from '../config/constants.js';
import WalletTransaction from '../models/walletTx.js';
import User from '../models/user.js';

class WalletController {
  // Get wallet balance
  async getBalance(req, res) {
    try {
      const userId = req.user.userId;
      
      // Get user's transaction history to calculate balance
      const transactions = await WalletTransaction.find({ userId }).sort({ createdAt: -1 });
      
      let balance = 0;
      transactions.forEach(transaction => {
        if (transaction.type === 'credit') {
          balance += transaction.amount;
        } else if (transaction.type === 'debit') {
          balance -= transaction.amount;
        }
      });

      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          amount: Math.max(0, balance), // Ensure balance is never negative
          currency: 'INR'
        }
      });
    } catch (error) {
      console.error('Get Balance Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get wallet balance',
        error: error.message
      });
    }
  }

  // Add money to wallet
  async addMoney(req, res) {
    try {
      const userId = req.user.userId;
      const { amount, paymentMethod, paymentId } = req.body;

      if (!amount || amount <= 0) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({
          success: false,
          message: 'Invalid amount'
        });
      }

      if (!paymentMethod) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({
          success: false,
          message: 'Payment method is required'
        });
      }

      // Create transaction record
      const transaction = new WalletTransaction({
        userId,
        type: 'credit',
        amount,
        description: `Add money via ${paymentMethod}`,
        status: 'success', // In real app, this would be 'pending' until payment confirmation
        transactionId: paymentId || `ADD_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        metadata: {
          paymentMethod,
          paymentId
        }
      });

      await transaction.save();

      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          transactionId: transaction.transactionId,
          amount: transaction.amount,
          status: transaction.status,
          message: 'Money added successfully'
        }
      });
    } catch (error) {
      console.error('Add Money Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to add money',
        error: error.message
      });
    }
  }

  // Get transaction history
  async getTransactions(req, res) {
    try {
      const userId = req.user.userId;
      const { page = 1, limit = 20, type, status } = req.query;

      const query = { userId };
      if (type) query.type = type;
      if (status) query.status = status;

      const transactions = await WalletTransaction.find(query)
        .sort({ createdAt: -1 })
        .limit(limit * 1)
        .skip((page - 1) * limit);

      const total = await WalletTransaction.countDocuments(query);

      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          transactions,
          pagination: {
            page: parseInt(page),
            limit: parseInt(limit),
            total,
            pages: Math.ceil(total / limit)
          }
        }
      });
    } catch (error) {
      console.error('Get Transactions Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get transactions',
        error: error.message
      });
    }
  }

  // Get transaction by ID
  async getTransactionById(req, res) {
    try {
      const userId = req.user.userId;
      const { transactionId } = req.params;

      const transaction = await WalletTransaction.findOne({
        userId,
        transactionId
      });

      if (!transaction) {
        return res.status(STATUS_CODES.NOT_FOUND).json({
          success: false,
          message: 'Transaction not found'
        });
      }

      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: transaction
      });
    } catch (error) {
      console.error('Get Transaction Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get transaction',
        error: error.message
      });
    }
  }

  // Transfer money (for future use)
  async transferMoney(req, res) {
    try {
      const userId = req.user.userId;
      const { recipientPhone, amount, description } = req.body;

      if (!recipientPhone || !amount || amount <= 0) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({
          success: false,
          message: 'Recipient phone and valid amount are required'
        });
      }

      // Check if recipient exists
      const recipient = await User.findOne({ phone: recipientPhone });
      if (!recipient) {
        return res.status(STATUS_CODES.NOT_FOUND).json({
          success: false,
          message: 'Recipient not found'
        });
      }

      // Check sender's balance
      const senderTransactions = await WalletTransaction.find({ userId });
      let senderBalance = 0;
      senderTransactions.forEach(tx => {
        if (tx.type === 'credit') senderBalance += tx.amount;
        else if (tx.type === 'debit') senderBalance -= tx.amount;
      });

      if (senderBalance < amount) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({
          success: false,
          message: 'Insufficient balance'
        });
      }

      const transferId = `TRF_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

      // Create debit transaction for sender
      const debitTransaction = new WalletTransaction({
        userId,
        type: 'debit',
        amount,
        description: description || `Transfer to ${recipientPhone}`,
        status: 'success',
        transactionId: transferId,
        metadata: {
          transferType: 'sent',
          recipientPhone
        }
      });

      // Create credit transaction for recipient
      const creditTransaction = new WalletTransaction({
        userId: recipient._id,
        type: 'credit',
        amount,
        description: description || `Transfer from ${req.user.phone}`,
        status: 'success',
        transactionId: transferId,
        metadata: {
          transferType: 'received',
          senderPhone: req.user.phone
        }
      });

      await Promise.all([
        debitTransaction.save(),
        creditTransaction.save()
      ]);

      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          transactionId: transferId,
          amount,
          recipient: recipientPhone,
          message: 'Transfer completed successfully'
        }
      });
    } catch (error) {
      console.error('Transfer Money Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to transfer money',
        error: error.message
      });
    }
  }

  // Get wallet summary
  async getWalletSummary(req, res) {
    try {
      const userId = req.user.userId;

      // Get all transactions
      const transactions = await WalletTransaction.find({ userId }).sort({ createdAt: -1 });

      let balance = 0;
      let totalCredits = 0;
      let totalDebits = 0;
      let recentTransactions = [];

      transactions.forEach((transaction, index) => {
        if (transaction.type === 'credit') {
          balance += transaction.amount;
          totalCredits += transaction.amount;
        } else if (transaction.type === 'debit') {
          balance -= transaction.amount;
          totalDebits += transaction.amount;
        }

        // Get last 5 transactions
        if (index < 5) {
          recentTransactions.push(transaction);
        }
      });

      // Get monthly spending
      const currentMonth = new Date();
      currentMonth.setDate(1);
      currentMonth.setHours(0, 0, 0, 0);

      const monthlyTransactions = await WalletTransaction.find({
        userId,
        createdAt: { $gte: currentMonth },
        type: 'debit'
      });

      const monthlySpending = monthlyTransactions.reduce((sum, tx) => sum + tx.amount, 0);

      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          balance: Math.max(0, balance),
          totalCredits,
          totalDebits,
          monthlySpending,
          transactionCount: transactions.length,
          recentTransactions,
          currency: 'INR'
        }
      });
    } catch (error) {
      console.error('Get Wallet Summary Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get wallet summary',
        error: error.message
      });
    }
  }

  // Process recharge payment (called by recharge controller)
  async processRechargePayment(userId, amount, description, metadata = {}) {
    try {
      const transaction = new WalletTransaction({
        userId,
        type: 'debit',
        amount,
        description,
        status: 'success',
        transactionId: `RCH_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        metadata
      });

      await transaction.save();
      return transaction;
    } catch (error) {
      console.error('Process Recharge Payment Error:', error);
      throw error;
    }
  }
}

export default new WalletController();