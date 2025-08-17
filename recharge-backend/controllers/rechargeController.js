import cyrusService from '../services/cyrusService.js';
import { STATUS_CODES, RECHARGE_STATUS, API_CONFIG } from '../config/constants.js';

class RechargeController {
  // Get account balance
  async getBalance(req, res) {
    try {
      const balance = await cyrusService.getBalance();
      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: balance
      });
    } catch (error) {
      console.error('Balance Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get balance',
        error: error.message
      });
    }
  }

  // Get operators list
  async getOperators(req, res) {
    try {
      console.log('Fetching operators from Cyrus API...');
      const operators = await cyrusService.getOperators();
      console.log('Successfully fetched operators');
      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: operators
      });
    } catch (error) {
      console.error('Operators Error:', error);
      console.error('Error details:', {
        message: error.message,
        stack: error.stack,
        response: error.response?.data || 'No response data'
      });
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get operators',
        error: error.message
      });
    }
  }

  // Get circles list
  async getCircles(req, res) {
    try {
      console.log('Fetching circles from Cyrus API...');
      const circles = await cyrusService.getCircles();
      console.log('Successfully fetched circles');
      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: circles
      });
    } catch (error) {
      console.error('Circles Error:', error);
      console.error('Error details:', {
        message: error.message,
        stack: error.stack,
        response: error.response?.data || 'No response data'
      });
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get circles',
        error: error.message
      });
    }
  }

  // Get recharge plans
  async getPlans(req, res) {
    try {
      const { operatorId, circleId } = req.query;
      
      if (!operatorId || !circleId) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({
          success: false,
          message: 'Operator ID and Circle ID are required'
        });
      }

      const plans = await cyrusService.getPlans(operatorId, circleId);
      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: plans
      });
    } catch (error) {
      console.error('Plans Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get plans',
        error: error.message
      });
    }
  }

  // Perform recharge
  async performRecharge(req, res) {
    try {
      const { mobileNumber, operatorId, circleId, amount, callbackUrl } = req.body;

      // Use provided callback URL or fall back to configured default
      const finalCallbackUrl = callbackUrl || API_CONFIG.CYRUS.CALLBACK_URL;

      console.log('Received recharge request:', { mobileNumber, operatorId, circleId, amount, callbackUrl: finalCallbackUrl });

      if (!mobileNumber || !operatorId || !circleId || !amount) {
        console.log('Bad request: Missing required fields');
        return res.status(STATUS_CODES.BAD_REQUEST).json({
          success: false,
          message: 'Mobile number, operator ID, circle ID, and amount are required'
        });
      }

      // Generate unique client ID
      const clientId = `RECHARGE_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

      const rechargeResult = await cyrusService.performRecharge(
        mobileNumber,
        operatorId,
        circleId,
        amount,
        clientId,
        finalCallbackUrl
      );

      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: {
          ...rechargeResult,
          clientId: clientId,
          callbackUrl: finalCallbackUrl
        }
      });
    } catch (error) {
      console.error('Recharge Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to perform recharge',
        error: error.message
      });
    }
  }

  // Check recharge status
  async getRechargeStatus(req, res) {
    try {
      const { clientId } = req.params;
      
      if (!clientId) {
        return res.status(STATUS_CODES.BAD_REQUEST).json({
          success: false,
          message: 'Client ID is required'
        });
      }

      const status = await cyrusService.getRechargeStatus(clientId);
      res.status(STATUS_CODES.SUCCESS).json({
        success: true,
        data: status
      });
    } catch (error) {
      console.error('Status Error:', error);
      res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
        success: false,
        message: 'Failed to get recharge status',
        error: error.message
      });
    }
  }
}

export default new RechargeController();