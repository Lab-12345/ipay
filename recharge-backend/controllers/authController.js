import jwt from 'jsonwebtoken';
import twilio from 'twilio';
import asyncHandler from 'express-async-handler';
import User from '../models/user.js';

// --- Twilio Client Initialization ---
let twilioClient = null;
let twilioServiceSid = null;

const initializeTwilio = () => {
  if (!twilioClient) {
    if (!process.env.TWILIO_ACCOUNT_SID || !process.env.TWILIO_AUTH_TOKEN || !process.env.TWILIO_SERVICE_SID) {
      throw new Error('FATAL_ERROR: Twilio credentials are not defined in .env file.');
    }
    try {
      twilioClient = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
      twilioServiceSid = process.env.TWILIO_SERVICE_SID;
      console.log('Twilio client initialized successfully with Service SID:', twilioServiceSid.substring(0, 4) + '...');
    } catch (error) {
      console.error('Twilio initialization failed:', error.message);
      throw new Error(`Twilio initialization error: ${error.message}`);
    }
  }
  return { twilioClient, twilioServiceSid };
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

  const { twilioClient, twilioServiceSid } = initializeTwilio();
  try {
    console.log('Attempting to resend OTP to:', phone);
    const verification = await twilioClient.verify.v2
      .services(twilioServiceSid)
      .verifications.create({ to: phone, channel: 'sms' });
    console.log('OTP resent successfully, SID:', verification.sid);
    res.status(200).json({ success: true, message: 'OTP resent successfully', data: { sid: verification.sid } });
  } catch (error) {
    console.error('Twilio error in resendOtp:', {
      message: error.message,
      code: error.code,
      moreInfo: error.moreInfo,
      stack: error.stack
    });
    res.status(500).json({
      success: false,
      error: 'Failed to resend OTP',
      details: error.message,
      moreInfo: error.moreInfo || 'https://www.twilio.com/docs/errors/20003'
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

  // Basic validation
  if (!phone || !/^\+[1-9]\d{1,14}$/.test(phone)) {
    res.status(400);
    throw new Error('Valid E.164 format phone number is required.');
  }

  const { twilioClient, twilioServiceSid } = initializeTwilio();
  try {
    console.log('Attempting to send OTP to:', phone);
    const verification = await twilioClient.verify.v2
      .services(twilioServiceSid)
      .verifications.create({ to: phone, channel: 'sms' });
    console.log('OTP sent successfully, SID:', verification.sid);
    res.status(200).json({ success: true, message: 'OTP sent successfully', data: { sid: verification.sid } });
  } catch (error) {
    console.error('Twilio error in sendOtp:', {
      message: error.message,
      code: error.code,
      moreInfo: error.moreInfo,
      stack: error.stack
    });
    res.status(500).json({
      success: false,
      error: 'Failed to send OTP',
      details: error.message,
      moreInfo: error.moreInfo || 'https://www.twilio.com/docs/errors/20003'
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

  // Basic validation
  if (!phone || !/^\+[1-9]\d{1,14}$/.test(phone)) {
    res.status(400);
    throw new Error('Valid E.164 format phone number is required.');
  }
  if (!otp || !/^\d{6}$/.test(otp)) {
    res.status(400);
    throw new Error('A 6-digit OTP is required.');
  }

  const { twilioClient, twilioServiceSid } = initializeTwilio();
  try {
    console.log('Attempting to verify OTP for:', phone);
    const verificationCheck = await twilioClient.verify.v2
      .services(twilioServiceSid)
      .verificationChecks.create({ to: phone, code: otp });

    if (verificationCheck.status !== 'approved') {
      res.status(400);
      throw new Error('Invalid or expired OTP.');
    }

    // Find user or create a new one if they don't exist (upsert)
    const user = await User.findOneAndUpdate(
      { phone },
      { $set: { verified: true } },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );

    if (user) {
      console.log('User verified successfully, UserID:', user._id);
      res.status(200).json({
        success: true,
        message: 'Phone number verified successfully.',
        data: {
          token: generateToken(user._id),
          userId: user._id,
          isNewUser: user.isNew,
        },
      });
    } else {
      res.status(500);
      throw new Error('Could not verify user.');
    }
  } catch (error) {
    console.error('Twilio error in verifyOtp:', {
      message: error.message,
      code: error.code,
      moreInfo: error.moreInfo,
      stack: error.stack
    });
    res.status(500).json({
      success: false,
      error: 'Failed to verify OTP',
      details: error.message,
      moreInfo: error.moreInfo || 'https://www.twilio.com/docs/errors/20003'
    });
  }
});
