import express from 'express';
import rechargeController from '../controllers/rechargeController.js';

const router = express.Router();

// Get account balance
router.get('/balance', rechargeController.getBalance);

// Get operators list
router.get('/operators', rechargeController.getOperators);

// Get circles list
router.get('/circles', rechargeController.getCircles);

// Get recharge plans
router.get('/plans', rechargeController.getPlans);

// Perform recharge
router.post('/recharge', rechargeController.performRecharge);

// Check recharge status
router.get('/status/:clientId', rechargeController.getRechargeStatus);

export default router;