import express from 'express';
import { 
  getBalance, 
  getOperators, 
  getCircles, 
  getPlans, 
  performRecharge, 
  getRechargeStatus 
} from '../controllers/rechargeController.js';
import CyrusService from '../services/cyrusService.js'; // Adjust path as needed

const router = express.Router();

// Get account balance
router.get('/balance', getBalance);

// Get operators list
router.get('/operators', getOperators);

// Get circles list
router.get('/circles', getCircles);

// Get recharge plans
router.get('/plans', getPlans);

// 🔹 Detect Operator and Circle for Mobile Number
router.post('/detect', async (req, res) => {
  try {
    const { mobileNumber } = req.body;

    if (!mobileNumber || mobileNumber.length !== 10) {
      return res.status(400).json({
        success: false,
        message: 'Invalid mobile number. Must be 10 digits.',
      });
    }

    // Use Cyrus MNP detection
    const operatorData = await CyrusService.getOperatorByNumber(mobileNumber);

    // Assuming operatorData returns something like { operatorCode, circleCode, ... }
    // Adjust based on actual response structure from Cyrus
    if (operatorData && operatorData.success) { // Assuming it has success flag
      const operatorCode = operatorData.operatorCode || operatorData.OperatorCode;
      const circleCode = operatorData.circleCode || operatorData.CircleCode || 'DEFAULT_CIRCLE'; // Fallback if not provided

      if (operatorCode) {
        return res.json({
          success: true,
          data: {
            operatorCode,
            circleCode,
            operatorName: operatorData.operatorName || '', // If available
            circleName: operatorData.circleName || '', // If available
          },
        });
      }
    }

    // If detection fails, fallback to manual or error
    return res.json({
      success: false,
      message: 'Could not detect operator. Please select manually.',
    });

  } catch (error) {
    console.error('Detect Number Error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error during detection.',
    });
  }
});

// Perform recharge
router.post('/perform', performRecharge); // Updated to match ApiService endpoint

// Check recharge status
router.get('/status/:clientId', getRechargeStatus);

export default router;
