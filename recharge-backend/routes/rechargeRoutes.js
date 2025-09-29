import express from 'express';
import { 
  getBalance, 
  getOperators, 
  getCircles, 
  getPlans, 
  performRecharge, 
  getRechargeStatus 
} from '../controllers/rechargeController.js';

const router = express.Router();

// Get account balance
router.get('/balance', getBalance);

// Get operators list
router.get('/operators', getOperators);

// Get circles list
router.get('/circles', getCircles);

// Get recharge plans
router.get('/plans', getPlans);

// Perform recharge
router.post('/recharge', performRecharge);

// Check recharge status
router.get('/status/:clientId', getRechargeStatus);

export default router;