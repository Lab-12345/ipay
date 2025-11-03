// routes/recharge.js
import express from 'express';
import cyrusService from '../services/cyrusService.js';
import asyncHandler from 'express-async-handler';

const router = express.Router();

/**
 * @desc    Detect operator & circle by mobile number (MNP)
 * @route   GET /api/recharge/detect
 * @access  Private
 */
router.get(
  '/detect',
  asyncHandler(async (req, res) => {
    const { mobile } = req.query;

    if (!mobile || mobile.length !== 10) {
      res.status(400);
      throw new Error('Valid 10-digit mobile number is required');
    }

    try {
      const cyrusResponse = await cyrusService.getOperatorByNumber(mobile);

      // Cyrus returns plain text or JSON – adjust parsing
      let operator = '';
      let circle = '';

      if (typeof cyrusResponse === 'string') {
        // Example: "JIO|DELHI"
        const parts = cyrusResponse.split('|');
        operator = parts[0]?.trim() || '';
        circle = parts[1]?.trim() || '';
      } else if (cyrusResponse?.Operator && cyrusResponse?.Circle) {
        operator = cyrusResponse.Operator;
        circle = cyrusResponse.Circle;
      }

      if (!operator || !circle) {
        res.status(404);
        throw new Error('Operator not found for this number');
      }

      res.json({
        success: true,
        data: { Operator: operator, Circle: circle },
      });
    } catch (error) {
      console.error('MNP Detection Error:', error);
      res.status(500).json({ success: false, message: error.message });
    }
  })
);

export default router;
