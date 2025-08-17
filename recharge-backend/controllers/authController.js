import jwt from 'jsonwebtoken';
import twilio from 'twilio';
import User from '../models/User.js';

/**
 * Send OTP
 */
export const sendOtp = async (req, res) => {
  try {
    const { phone } = req.body;

    if (!phone) {
      return res.status(400).json({ error: 'Phone number is required' });
    }
    if (!phone.startsWith('+')) {
      return res.status(400).json({ error: 'Phone number must be in E.164 format (e.g., +1234567890)' });
    }

    // Ensure env vars exist
    if (!process.env.TWILIO_ACCOUNT_SID || !process.env.TWILIO_AUTH_TOKEN || !process.env.TWILIO_SERVICE_SID) {
      return res.status(500).json({ error: 'Twilio credentials missing' });
    }

    // Create Twilio client when needed
    const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

    const verification = await client.verify.v2
      .services(process.env.TWILIO_SERVICE_SID)
      .verifications
      .create({ to: phone, channel: 'sms' });

    res.status(200).json({ message: 'OTP sent successfully', sid: verification.sid });

  } catch (err) {
    console.error('❌ Twilio Error:', err);
    res.status(500).json({ error: err.message || 'Failed to send OTP' });
  }
};

/**
 * Verify OTP
 */
export const verifyOtp = async (req, res) => {
  try {
    const { phone, otp } = req.body;

    if (!phone || !otp) {
      return res.status(400).json({ error: 'Phone and OTP are required' });
    }
    if (!phone.startsWith('+')) {
      return res.status(400).json({ error: 'Phone number must be in E.164 format (e.g., +1234567890)' });
    }

    if (!process.env.TWILIO_ACCOUNT_SID || !process.env.TWILIO_AUTH_TOKEN || !process.env.TWILIO_SERVICE_SID) {
      return res.status(500).json({ error: 'Twilio credentials missing' });
    }

    const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

    const verification = await client.verify.v2
      .services(process.env.TWILIO_SERVICE_SID)
      .verificationChecks
      .create({ to: phone, code: otp });

    if (verification.status === 'approved') {
      let user = await User.findOne({ phone });
      if (!user) {
        user = await User.create({ phone, verified: true });
      } else {
        user.verified = true;
        await user.save();
      }

      const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });
      return res.json({ message: 'Phone verified', token, userId: user._id });
    } else {
      return res.status(400).json({ error: 'Invalid OTP' });
    }

  } catch (err) {
    console.error('❌ OTP verification error:', err);
    res.status(500).json({ error: err.message || 'OTP verification failed' });
  }
};
