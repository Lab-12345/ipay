import jwt from 'jsonwebtoken';
import { Vonage } from '@vonage/server-sdk';
import asyncHandler from 'express-async-handler';
import User from '../models/user.js';

// --- Vonage Client Initialization ---
let vonage = null;

const initializeVonage = () => {
  if (!vonage) {
    if (!process.env.VONAGE_API_KEY || !process.env.VONAGE_API_SECRET) {
      throw new Error('FATAL_ERROR: Vonage credentials are not defined in .env file.');
    }
    try {
      vonage = new Vonage({
        apiKey: process.env.VONAGE_API_KEY,
        apiSecret: process.env.VONAGE_API_SECRET,
      });
      console.log('Vonage client initialized successfully with API Key:', process.env.VONAGE_API_KEY.substring(0, 4) + '...');
    } catch (error) {
      console.error('Vonage initialization failed:', error.message);
      throw new Error(`Vonage initialization error: ${error.message}`);
    }
  }
  return vonage;
};

// --- Utility Functions ---
const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: '30d',
  });
};

// --- Controller Functions ---

/**
 * @desc    Resend OTP to a phone number (alias of send-otp)
 * @route   POST /api/auth/resend-otp
 * @access  Public
 */
export const resendOtp = asyncHandler(async (req, res) => {
  const { phone } = req.body;

  if (!phone || !/^\+[1-9]\d{1,14}$/.test(phone)) {
    res.status(400);
    throw new Error('Valid E.164 format phone number is required.');
  }

  const vonageClient = initializeVonage();
  const from = 'Vonage APIs'; // Replace with a Vonage virtual number if available
  const text = `Your OTP is ${Math.floor(100000 + Math.random() * 900000)}`; // Generate a 6-digit OTP
  try {
    console.log('Attempting to resend OTP to:', phone);
    const response = await vonageClient.sms.send({ to: phone, from, text });
    console.log('OTP resent successfully, response:', response.messages[0]['message-id']);
    res.status(200).json({ success: true, message: 'OTP resent successfully', data: { sid: response.messages[0]['message-id'] } });
  } catch (error) {
    console.error('Vonage error in resendOtp:', {
      message: error.message,
      code: error.code,
      details: error,
      stack: error.stack
    });
    res.status(500).json({
      success: false,
      error: 'Failed to resend OTP',
      details: error.message,
      moreInfo: 'https://developer.vonage.com/messaging/sms/api-reference#error'
    });
  }
});

/**
 * @desc    Send OTP to a phone number
 * @route   POST /api/auth/send-otp
 * @access  Public
 */
export const sendOtp = asyncHandler(async (req, res) => {
  const { phone } = req.body;

  if (!phone || !/^\+[1-9]\d{1,14}$/.test(phone)) {
    res.status(400);
    throw new Error('Valid E.164 format phone number is required.');
  }

  const vonageClient = initializeVonage();
  const from = 'Vonage APIs'; // Replace with a Vonage virtual number if available
  const text = `Your OTP is ${Math.floor(100000 + Math.random() * 900000)}`; // Generate a 6-digit OTP
  try {
    console.log('Attempting to send OTP to:', phone);
    const response = await vonageClient.sms.send({ to: phone, from, text });
    console.log('OTP sent successfully, response:', response.messages[0]['message-id']);
    res.status(200).json({ success: true, message: 'OTP sent successfully', data: { sid: response.messages[0]['message-id'] } });
  } catch (error) {
    console.error('Vonage error in sendOtp:', {
      message: error.message,
      code: error.code,
      details: error,
      stack: error.stack
    });
    res.status(500).json({
      success: false,
      error: 'Failed to send OTP',
      details: error.message,
      moreInfo: 'https://developer.vonage.com/messaging/sms/api-reference#error'
    });
  }
});

/**
 * @desc    Verify OTP and log in or register user
 * @route   POST /api/auth/verify-otp
 * @access  Public
 */
export const verifyOtp = asyncHandler(async (req, res) => {
  const { phone, otp } = req.body;

  if (!phone || !/^\+[1-9]\d{1,14}$/.test(phone)) {
    res.status(400);
    throw new Error('Valid E.164 format phone number is required.');
  }
  if (!otp || !/^\d{6}$/.test(otp)) {
    res.status(400);
    throw new Error('A 6-digit OTP is required.');
  }

  const user = await User.findOne({ phone });

  if (user && user.otp === otp && user.otpExpires > Date.now()) {
    await User.findOneAndUpdate(
      { phone },
      { $set: { verified: true }, $unset: { otp: 1, otpExpires: 1 } },
      { new: true }
    );
    res.status(200).json({
      success: true,
      message: 'Phone number verified successfully.',
      data: {
        token: generateToken(user._id),
        userId: user._id,
        isNewUser: !user.verified, // Assuming isNew based on prior verification
      },
    });
  } else {
    res.status(400);
    throw new Error('Invalid or expired OTP.');
  }
});
