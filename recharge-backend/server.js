// Environment variables must be loaded first
import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import connectDB from './config/db.js';
import { corsMiddleware, corsErrorHandler } from './middleware/corsMiddleware.js';

// Route imports
import authRoutes from './routes/authRoutes.js';
import paymentRoutes from './routes/paymentRoutes.js';
import rechargeRoutes from './routes/rechargeRoutes.js';
import walletRoutes from './routes/walletRoutes.js';

// --- App Initialization ---
const app = express();

// --- Core Middleware ---

// Set security-related HTTP response headers
app.use(helmet());

// Apply CORS middleware
app.use(corsMiddleware);

// Body parsing
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// --- Rate Limiting ---

// General rate limiter for all requests
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 200, // Limit each IP to 200 requests per windowMs
  standardHeaders: true,
  legacyHeaders: false,
  message: 'Too many requests from this IP, please try again after 15 minutes.',
});

// Stricter rate limiter for authentication routes
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 15, // Limit each IP to 15 auth-related requests per windowMs
  standardHeaders: true,
  legacyHeaders: false,
  message: 'Too many authentication attempts, please try again after 15 minutes.',
});

app.use(generalLimiter);
app.use('/api/auth', authLimiter); // Apply stricter limit to all auth routes

// --- Database Connection ---
connectDB();

// --- API Routes ---
app.use('/api/auth', authRoutes);
app.use('/api/payment', paymentRoutes);
app.use('/api/recharge', rechargeRoutes);
app.use('/api/wallet', walletRoutes);

// --- Health Check ---
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

// --- Error Handling Middleware (must be last) ---

// 404 Not Found handler
app.use((req, res, next) => {
  res.status(404).json({ message: 'The requested resource was not found.' });
});

// Handle CORS errors specifically
app.use(corsErrorHandler);

// Global error handler for all other errors
app.use((err, req, res, next) => {
  console.error('Unhandled Error:', err);
  // For production, we don't want to send the stack trace to the client
  if (process.env.NODE_ENV === 'production') {
    return res.status(500).json({ message: 'An unexpected server error occurred.' });
  }
  // For development, send more detailed error
  res.status(500).json({
    message: err.message,
    stack: err.stack,
  });
});

// --- Server Startup ---
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
});
