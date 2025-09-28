// API Configuration Constants
import dotenv from 'dotenv';
// Ensure env is loaded even when this module is imported before server.js
dotenv.config();

export const API_CONFIG = {
  // Cyrus Recharge API Configuration
  CYRUS: {
    BASE_URL: process.env.CYRUS_BASE_URL || 'https://cyrusrecharge.in',
    MEMBER_ID: process.env.CYRUS_MEMBER_ID || 'AP338160',
    PIN: process.env.CYRUS_PIN || 'FFC8788E3C',
    CALLBACK_URL: process.env.CYRUS_CALLBACK_URL || 'https://ipay-7trh.onrender.com',
  },
  
  // Razorpay Configuration
  RAZORPAY: {
    KEY_ID: process.env.RAZORPAY_KEY_ID,
    KEY_ID_PUBLIC: process.env.RAZORPAY_KEY_ID_PUBLIC,
    KEY_SECRET: process.env.RAZORPAY_KEY_SECRET,
  },
  
  // Twilio Configuration
  TWILIO: {
    ACCOUNT_SID: process.env.TWILIO_ACCOUNT_SID,
    AUTH_TOKEN: process.env.TWILIO_AUTH_TOKEN,
    SERVICE_SID: process.env.TWILIO_SERVICE_SID,
  },
  
  // Database Configuration
  DATABASE: {
    MONGODB_URI: process.env.MONGODB_URI,
  },
  
  // JWT Configuration
  JWT: {
    SECRET: process.env.JWT_SECRET,
  },
  
  // Server Configuration
  SERVER: {
    PORT: process.env.PORT || 3000,
    NODE_ENV: process.env.NODE_ENV || 'development',
  }
};

// API Endpoints for Cyrus Recharge
export const CYRUS_ENDPOINTS = {
  RECHARGE: 'services_cyapi/recharge_cyapi.aspx',
  BALANCE: 'GetOperator.aspx', // Same endpoint as operators/circles
  STATUS: 'rechargestatus.aspx',
  PLANS: 'Plans.aspx',
  OPERATOR_CIRCLE: 'GetOperator.aspx', // Same endpoint for operators, circles, and balance
  DISPUTE: 'api/api_raise_dispute.aspx', // For raising disputes
};

// Response Status Codes
export const STATUS_CODES = {
  SUCCESS: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  INTERNAL_SERVER_ERROR: 500,
};

// Recharge Status
export const RECHARGE_STATUS = {
  PENDING: 'PENDING',
  SUCCESS: 'SUCCESS',
  FAILED: 'FAILED',
  REFUNDED: 'REFUNDED',
};