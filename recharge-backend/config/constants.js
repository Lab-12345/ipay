import dotenv from 'dotenv';
// Ensure env is loaded even when this module is imported before server.js
dotenv.config();

export const API_CONFIG = {
  // Cyrus Recharge API Configuration
  CYRUS: {
    BASE_URL: process.env.CYRUS_BASE_URL || 'https://cyrusrecharge.in/API/',
    MEMBER_ID: process.env.CYRUS_MEMBER_ID || 'AP338160',
    PIN: process.env.CYRUS_PIN || 'FFC8788E3C', // Default PIN; override with .env
    OPERATOR_PASSWORD: process.env.CYRUS_OPERATOR_PASSWORD || 'qaweqw234sdfsdsd', // For MNP Fetch
    DTH_PASSWORD: process.env.CYRUS_DTH_PASSWORD || 'GSHDGuywe3473', // For DTH/Plans
    OFFER_PASSWORD: process.env.CYRUS_OFFER_PASSWORD || 'sdf54f45dfh845dhut38', // For Roffers
    BILL_PASSWORD: process.env.CYRUS_BILL_PASSWORD || 'ssuy34mfjhgi88348jhd', // For BBPS
    CALLBACK_URL: process.env.CYRUS_CALLBACK_URL,
  },
  
  // Razorpay Configuration
  RAZORPAY: {
    KEY_ID: process.env.RAZORPAY_KEY_ID,
    KEY_ID_PUBLIC: process.env.RAZORPAY_KEY_ID_PUBLIC,
    KEY_SECRET: process.env.RAZORPAY_KEY_SECRET,
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
  RECHARGE: '/services_cyapi/recharge_cyapi.aspx',
  BALANCE: '/api/GetBalance.aspx', // Corrected; assume separate balance endpoint
  AEPS_BALANCE: '/api/GetAEPSBalance.aspx', // Corrected; assume separate AEPS balance endpoint
  STATUS: '/api/rechargestatus.aspx',
  PLANS: '/API/CyrusPlanFatchAPI.aspx',
  OPERATOR_CIRCLE: '/api/GetOperatorCircle.aspx', // Corrected; assume separate operator/circle list
  MNP: '/CyrusOperatorFatchAPI.aspx', // Added for MNP Fetch
  DISPUTE: '/api/api_raise_dispute.aspx',
  ROFFERS: '/api/CyrusROfferAPI.aspx',
  DTH_INFO: '/api/CyrusROfferAPI.aspx',
  BILL_FETCH: '/api/BillFetch_Cyrus_BA.aspx', // For BBPS bill fetch and biller info (POST)
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
