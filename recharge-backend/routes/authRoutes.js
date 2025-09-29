import express from 'express';
import { sendOtp, verifyOtp, resendOtp } from '../controllers/authController.js';

const router = express.Router();

router.post('/send-otp', sendOtp);
router.post('/resend-otp', resendOtp);
router.post('/verify-otp', verifyOtp);

export default router;