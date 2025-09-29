import cors from 'cors';

// Define allowed origins for production
const allowedOrigins = (process.env.ALLOWED_ORIGINS || '').split(',').map(s => s.trim()).filter(Boolean);

const corsOptions = {
  origin: function (origin, callback) {
    // In development, allow requests from any origin
    if (process.env.NODE_ENV !== 'production') {
      return callback(null, true);
    }
    
    // In production, only allow origins from the defined list
    // Also allow requests with no origin (e.g., mobile apps, server-to-server)
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: [
    'Origin',
    'X-Requested-With',
    'Content-Type',
    'Accept',
    'Authorization',
  ],
  credentials: true,
};

export const corsMiddleware = cors(corsOptions);

export const corsErrorHandler = (err, req, res, next) => {
  if (err.message === 'Not allowed by CORS') {
    console.error(`❌ CORS Error: Origin ${req.headers.origin} not allowed.`);
    return res.status(403).json({ message: 'This origin is not allowed by CORS.' });
  }
  next(err);
};
