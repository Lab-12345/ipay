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
    twilioClient = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
    twilioServiceSid = process.env.TWILIO_SERVICE_SID;
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
  const verification = await twilioClient.verify.v2
    .services(twilioServiceSid)
    .verifications.create({ to: phone, channel: 'sms' });

  res.status(200).json({ success: true, message: 'OTP resent successfully', data: { sid: verification.sid } });
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
  const verification = await twilioClient.verify.v2
    .services(twilioServiceSid)
    .verifications.create({ to: phone, channel: 'sms' });

  res.status(200).json({ success: true, message: 'OTP sent successfully', data: { sid: verification.sid } });
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
});
