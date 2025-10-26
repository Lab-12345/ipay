import asyncHandler from 'express-async-handler';
import cyrusService from '../services/cyrusService.js';
import { API_CONFIG } from '../config/constants.js';
import walletController from './walletController.js';

// Get user wallet balance
export const walletBalance = asyncHandler(async (req, res) => {
  const { userId } = req.params; // Assuming userId from URL or JWT
  if (!userId) {
    res.status(400);
    throw new Error('User ID is required');
  }
  const balance = await walletController.getBalance(req, res, userId); // Pass userId
  res.status(200).json({ success: true, data: { balance: balance.toFixed(2) } });
});

// Get Cyrus wallet balance (for reseller, not user-specific)
export const getBalance = asyncHandler(async (req, res) => {
  try {
    const balance = await cyrusService.getBalance();
    res.status(200).json({ success: true, data: { balance: balance.toFixed(2) || 0 } });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Failed to fetch Cyrus balance', details: error.message });
  }
});

/**
 * @desc    Get list of mobile operators from Cyrus
 * @route   GET /api/recharge/operators
 * @access  Private
 */
export const getOperators = asyncHandler(async (req, res) => {
  try {
    const operators = await cyrusService.getOperators();
    res.status(200).json({ success: true, data: operators });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Failed to fetch operators', details: error.message });
  }
});

/**
 * @desc    Get telecom circles list from Cyrus
 * @route   GET /api/recharge/circles
 * @access  Private
 */
export const getCircles = asyncHandler(async (req, res) => {
  try {
    const circles = await cyrusService.getCircles();
    res.status(200).json({ success: true, data: circles });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Failed to fetch circles', details: error.message });
  }
});

/**
 * @desc    Get recharge plans for a specific operator and circle
 * @route   GET /api/recharge/plans
 * @access  Private
 */
export const getPlans = asyncHandler(async (req, res) => {
  const { operatorId, circleId } = req.query;

  if (!operatorId || !circleId) {
    res.status(400);
    throw new Error('Operator ID and Circle ID are required query parameters.');
  }

  try {
    const plans = await cyrusService.getPlans(operatorId, circleId);
    if (!plans || plans.length === 0) {
      res.status(404).json({ success: false, error: 'No plans found for the given operator and circle' });
    } else {
      res.status(200).json({ success: true, data: plans });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: 'Failed to fetch plans', details: error.message });
  }
});

/**
 * @desc    Perform a mobile or DTH recharge
 * @route   POST /api/recharge/perform
 * @access  Private
 */
export const performRecharge = asyncHandler(async (req, res) => {
  const { mobileNumber, operatorId, circleId, amount, callbackUrl, userId, planId, serviceType = 'mobile' } = req.body; // Added serviceType for DTH

  // Input validation
  if (!mobileNumber || !operatorId || !circleId || !userId) {
    res.status(400);
    throw new Error('Mobile number, operator ID, circle ID, and userId are required.');
  }

  // Validate service type
  if (!['mobile', 'dth'].includes(serviceType.toLowerCase())) {
    res.status(400);
    throw new Error('Invalid service type. Use "mobile" or "dth".');
  }

  // Fetch plan amount if planId is provided, otherwise use amount
  let rechargeAmount;
  if (planId) {
    const plans = await cyrusService.getPlans(operatorId, circleId);
    const selectedPlan = plans.find(plan => plan.id === planId); // Adjust 'id' based on Cyrus response
    if (!selectedPlan) {
      res.status(400);
      throw new Error('Invalid plan ID.');
    }
    rechargeAmount = parseFloat(selectedPlan.amount); // Assume plan has an 'amount' field
  } else if (amount) {
    rechargeAmount = parseFloat(amount);
  } else {
    res.status(400);
    throw new Error('Either planId or amount is required.');
  }

  if (isNaN(rechargeAmount) || rechargeAmount <= 0) {
    res.status(400);
    throw new Error('Recharge amount must be a positive number.');
  }

  // User wallet validation
  const userBalance = await walletController.getBalance(req, res, userId);
  if (userBalance < rechargeAmount) {
    res.status(400);
    throw new Error(`Insufficient balance. Available: ₹${userBalance.toFixed(2)}, Required: ₹${rechargeAmount.toFixed(2)}`);
  }

  // Proceed with recharge
  const finalCallbackUrl = callbackUrl || API_CONFIG.CYRUS.CALLBACK_URL;
  const clientId = `RECHARGE_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

  try {
    const rechargeResult = await cyrusService.performRecharge(
      mobileNumber,
      operatorId,
      circleId,
      rechargeAmount,
      clientId,
      finalCallbackUrl,
      serviceType
    );

    if (!rechargeResult.success) {
      throw new Error(rechargeResult.message || 'Recharge failed');
    }

    // Deduct from user wallet after success
    await walletController.deductBalance(req, res, userId, rechargeAmount);

    res.status(201).json({
      success: true,
      data: {
        ...rechargeResult,
        clientId,
        callbackUrl: finalCallbackUrl,
        newBalance: (userBalance - rechargeAmount).toFixed(2),
        serviceType,
      },
    });
  } catch (error) {
    console.error('Recharge Error:', { message: error.message, stack: error.stack }); // Enhanced logging
    res.status(500).json({ success: false, message: 'Internal server error—check logs', details: error.message });
  }
});

/**
 * @desc    Check the status of a recharge
 * @route   GET /api/recharge/status/:clientId
 * @access  Private
 */
export const getRechargeStatus = asyncHandler(async (req, res) => {
  const { clientId } = req.params;

  if (!clientId) {
    res.status(400);
    throw new Error('Client ID is required as a URL parameter.');
  }

  try {
    const status = await cyrusService.getRechargeStatus(clientId);
    if (!status) {
      res.status(404).json({ success: false, error: 'Recharge status not found' });
    } else {
      res.status(200).json({ success: true, data: status });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: 'Failed to fetch recharge status', details: error.message });
  }
});

// Export as UserBalance (capitalized)
export const UserBalance = asyncHandler(async (req, res) => {
  const { userId } = req.params;

  if (!userId) {
    res.status(400);
    throw new Error('User ID is required as a URL parameter.');
  }

  try {
    const balance = await walletController.getBalance(req, res, userId);
    res.status(200).json({ success: true, data: { balance: balance.toFixed(2) } });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Failed to fetch user balance', details: error.message });
  }
});
