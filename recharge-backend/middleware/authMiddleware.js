// middleware/authMiddleware.js
import jwt from 'jsonwebtoken';
import asyncHandler from 'express-async-handler';
import User from '../models/user.js';

// Named export
export const protect = asyncHandler(async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Get token from header
      token = req.headers.authorization.split(' ')[1];

      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // decoded payload is { userId: ... }
      const userId = decoded?.userId;
      if (!userId) {
        res.status(401);
        throw new Error('Not authorized, invalid token payload');
      }

      // Find user and attach a minimal object expected by controllers
      const user = await User.findById(userId).select('phone');
      if (!user) {
        res.status(401);
        throw new Error('Not authorized, user not found');
      }

      // Attach consistent shape: { userId, phone }
      req.user = { userId, phone: user.phone };

      return next();
    } catch (error) {
      console.error(error);
      res.status(401);
      throw new Error('Not authorized, token failed');
    }
  }

  if (!token) {
    res.status(401);
    throw new Error('Not authorized, no token');
  }
});
