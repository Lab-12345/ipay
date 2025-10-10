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
  res.status(200).json({ success: true, data: balance });
});

// Get Cyrus wallet balance (for reseller, not user-specific)
export const getBalance = asyncHandler(async (req, res) => {
  const balance = await cyrusService.getBalance(); // Cyrus reseller balance
  res.status(200).json({ success: true, data: balance });
});

export const getOperators = asyncHandler(async (req, res) => {
  const operators = await cyrusService.getOperators();
  res.status(200).json({ success: true, data: operators });
});

/**
 * @desc    Get telecom circles list from Cyrus
 * @route   GET /api/recharge/circles
 * @access  Private
 */
export const getCircles = asyncHandler(async (req, res) => {
  const circles = await cyrusService.getCircles();
  res.status(200).json({ success: true, data: circles });
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

  const plans = await cyrusService.getPlans(operatorId, circleId);
  res.status(200).json({ success: true, data: plans });
});

/**
 * @desc    Perform a mobile recharge
 * @route   POST /api/recharge/perform
 * @access  Private
 */
export const performRecharge = asyncHandler(async (req, res) => {
  const { mobileNumber, operatorId, circleId, amount, callbackUrl, userId, planId } = req.body; // Add planId for plan-based amount

  // Input validation
  if (!mobileNumber || !operatorId || !circleId || !userId) {
    res.status(400);
    throw new Error('Mobile number, operator ID, circle ID, and userId are required.');
  }

  // Fetch plan amount if planId is provided, otherwise use amount
  let rechargeAmount;
  if (planId) {
    const plans = await cyrusService.getPlans(operatorId, circleId);
    const selectedPlan = plans.find(plan => plan.id === planId); // Adjust 'id' based on Cyrus plan structure
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
  const userBalance = await walletController.getBalance(req, res, userId); // Fetch current balance
  if (userBalance < rechargeAmount) {
    res.status(400);
    throw new Error(`Insufficient balance. Available: ₹${userBalance.toFixed(2)}`);
  }

  // Proceed with recharge
  const finalCallbackUrl = callbackUrl || API_CONFIG.CYRUS.CALLBACK_URL;
  const clientId = `RECHARGE_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

  try {
    const rechargeResult = await cyrusService.performRecharge(
      mobileNumber,
      operatorId,
      circleId,
      rechargeAmount, // Use plan amount or provided amount
      clientId,
      finalCallbackUrl
    );

    if (!rechargeResult.success) {
      throw new Error(rechargeResult.message || 'Recharge failed');
    }

    // Deduct from user wallet after success (use transaction if available)
    await walletController.deductBalance(req, res, userId, rechargeAmount); // Use rechargeAmount

    res.status(201).json({
      success: true,
      data: {
        ...rechargeResult,
        clientId,
        callbackUrl: finalCallbackUrl,
        newBalance: userBalance - rechargeAmount, // Update after deduction
      },
    });
  } catch (error) {
    console.error('Recharge Error:', error.message); // Log for Railway
    res.status(500).json({ success: false, message: 'Internal server error—check logs' });
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

  const status = await cyrusService.getRechargeStatus(clientId);
  res.status(200).json({ success: true, data: status });
});

// Export as UserBalance (capitalized)
export const UserBalance = asyncHandler(async (req, res) => {
  const { userId } = req.params;

  if (!userId) {
    res.status(400);
    throw new Error('User ID is required as a URL parameter.');
  }

  const balance = await walletController.getBalance(req, res, userId); // Use walletController
  res.status(200).json({ success: true, data: balance });
});
