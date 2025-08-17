import express from 'express';
import razorpayController from '../controllers/razorpayController.js';
import authMiddleware from '../middleware/authMiddleware.js';

const router = express.Router();

// Get Razorpay public key (no auth required for public key)
router.get('/razorpay/key', razorpayController.getPublicKey);

// Create Razorpay order (requires authentication)
router.post('/razorpay/order', authMiddleware, razorpayController.createOrder);

// Verify Razorpay payment (requires authentication)
router.post('/razorpay/verify', authMiddleware, razorpayController.verifyPayment);

export default router;
