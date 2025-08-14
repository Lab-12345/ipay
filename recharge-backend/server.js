import express from 'express';
import dotenv from 'dotenv';
import connectDB from './config/db.js';
import authRoutes from './routes/authRoutes.js';



dotenv.config();
connectDB();

const app = express(); // ✅ create app first
app.use(express.json());

// ✅ Test route
app.get('/', (req, res) => {
  res.send('API is working 🚀');
});

// ✅ Mount auth routes
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
