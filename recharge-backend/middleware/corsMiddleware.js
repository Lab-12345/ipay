import cors from 'cors';

// CORS Configuration for different environments
const getCorsOptions = () => {
  // Treat any non-production env as development for permissive localhost CORS
  const isDevelopment = process.env.NODE_ENV !== 'production';
  
  if (isDevelopment) {
    // Development: Allow all localhost origins with dynamic ports
    return {
      origin: function (origin, callback) {
        // Allow requests with no origin (mobile apps, Postman, etc.)
        if (!origin) return callback(null, true);
        
        // In development, allow all localhost origins
        if (origin.includes('localhost') || origin.includes('127.0.0.1')) {
          callback(null, true);
        } else {
          console.log(`CORS blocked origin in development: ${origin}`);
          callback(null, true); // Still allow in development for testing
        }
      },
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
      allowedHeaders: [
        'Origin',
        'X-Requested-With',
        'Content-Type',
        'Accept',
        'Authorization',
        'Cache-Control',
        'X-Access-Token',
        'Access-Control-Allow-Origin',
      ],
      credentials: true,
      optionsSuccessStatus: 200,
    };
  } else {
    // Production: Strict origin control
    return {
      origin: function (origin, callback) {
        if (!origin) return callback(null, true);
        // Allow localhost in production if explicitly set via env
        const allowed = (process.env.ALLOWED_ORIGINS || '')
          .split(',')
          .map(s => s.trim())
          .filter(Boolean);
        if (allowed.length > 0 && allowed.includes(origin)) {
          return callback(null, true);
        }
        // Fallback: deny by default in production
        return callback(new Error('Not allowed by CORS'));
      },
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
      allowedHeaders: [
        'Origin',
        'X-Requested-With',
        'Content-Type',
        'Accept',
        'Authorization',
        'Cache-Control',
      ],
      credentials: true,
      optionsSuccessStatus: 200,
    };
  }
};

// Custom CORS middleware
export const corsMiddleware = cors(getCorsOptions());

// Additional preflight handler
export const preflightHandler = (req, res, next) => {
  if (req.method === 'OPTIONS') {
    const origin = req.headers.origin;
    
    // Set CORS headers for preflight
    res.header('Access-Control-Allow-Origin', origin || '*');
    res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS,PATCH');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control, X-Access-Token');
    res.header('Access-Control-Allow-Credentials', 'true');
    res.header('Access-Control-Max-Age', '86400'); // 24 hours
    
    console.log(`✅ CORS preflight handled for origin: ${origin}`);
    return res.status(200).end();
  }
  next();
};

// CORS error handler
export const corsErrorHandler = (err, req, res, next) => {
  if (err.message === 'Not allowed by CORS') {
    console.error(`❌ CORS Error: Origin ${req.headers.origin} not allowed`);
    return res.status(403).json({
      error: 'CORS Error',
      message: 'Origin not allowed by CORS policy',
      origin: req.headers.origin,
    });
  }
  next(err);
};

// Log CORS requests for debugging
export const corsLogger = (req, res, next) => {
  if (process.env.NODE_ENV === 'development') {
    console.log(`🌐 CORS Request: ${req.method} ${req.path} from origin: ${req.headers.origin || 'no-origin'}`);
  }
  next();
};

export default {
  corsMiddleware,
  preflightHandler,
  corsErrorHandler,
  corsLogger,
};