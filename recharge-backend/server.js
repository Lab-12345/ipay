// server.js
import dotenv from 'dotenv';
dotenv.config(); // must be first line

import express from 'express';
import connectDB from './config/db.js';
import authRoutes from './routes/authRoutes.js';

const app = express();
app.use(express.json());

// Connect to MongoDB
connectDB();

// Routes
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});
