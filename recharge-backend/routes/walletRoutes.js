import express from 'express';
import walletController from '../controllers/walletController.js';
import { protect } from '../middleware/authMiddleware.js';

const router = express.Router();

// Apply authentication middleware to all wallet routes
router.use(protect);

// Get wallet balance
router.get('/balance', walletController.getBalance);

// Add money to wallet (non-gateway immediate credit; kept for compatibility)
router.post('/add-money', walletController.addMoney);

// Get transaction history
router.get('/transactions', walletController.getTransactions);

// Get transaction by ID
router.get('/transactions/:transactionId', walletController.getTransactionById);

// Transfer money
router.post('/transfer', walletController.transferMoney);

// Get wallet summary
router.get('/summary', walletController.getWalletSummary);

export default router;