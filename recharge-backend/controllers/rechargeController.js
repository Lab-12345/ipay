import asyncHandler from 'express-async-handler';
import cyrusService from '../services/cyrusService.js';
import { API_CONFIG } from '../config/constants.js';

/**
 * @desc    Get account balance from Cyrus
 * @route   GET /api/recharge/balance
 * @access  Private
 */
export const getBalance = asyncHandler(async (req, res) => {
  const balance = await cyrusService.getBalance();
  res.status(200).json({ success: true, data: balance });
});

/**
 * @desc    Get mobile operators list from Cyrus
 * @route   GET /api/recharge/operators
 * @access  Private
 */
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
  const { mobileNumber, operatorId, circleId, amount, callbackUrl } = req.body;

  if (!mobileNumber || !operatorId || !circleId || !amount) {
    res.status(400);
    throw new Error('Mobile number, operator ID, circle ID, and amount are required.');
  }

  if (isNaN(parseFloat(amount)) || parseFloat(amount) <= 0) {
    res.status(400);
    throw new Error('Amount must be a positive number.');
  }

  // Use provided callback URL or fall back to configured default
  const finalCallbackUrl = callbackUrl || API_CONFIG.CYRUS.CALLBACK_URL;
  const clientId = `RECHARGE_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

  const rechargeResult = await cyrusService.performRecharge(
    mobileNumber,
    operatorId,
    circleId,
    amount,
    clientId,
    finalCallbackUrl
  );

  res.status(201).json({ // 201 Created is more appropriate for a new resource
    success: true,
    data: {
      ...rechargeResult,
      clientId: clientId,
      callbackUrl: finalCallbackUrl,
    },
  });
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
