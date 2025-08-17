import { API_CONFIG, CYRUS_ENDPOINTS } from '../config/constants.js';

class CyrusService {
  constructor() {
    this.baseURL = API_CONFIG.CYRUS.BASE_URL;
    this.memberId = API_CONFIG.CYRUS.MEMBER_ID;
    this.pin = API_CONFIG.CYRUS.PIN;
  }

  // Helper method to make API requests
  async makeRequest(endpoint, method, params = {}) {
    try {
      // Construct the full URL properly
      const fullUrl = `${this.baseURL}${endpoint}`;
      const url = new URL(fullUrl);

      // Add common parameters
      const requestParams = {
        memberid: this.memberId,
        pin: this.pin,
        Method: method,
        ...params
      };

      // Add parameters to URL
      Object.keys(requestParams).forEach(key => {
        url.searchParams.append(key, requestParams[key]);
      });

      console.log(`Making request to: ${url.toString()}`);

      const response = await fetch(url.toString(), {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Cyrus API Error:', error);
      throw error;
    }
  }

  // Get account balance
  async getBalance() {
    return await this.makeRequest(CYRUS_ENDPOINTS.OPERATOR_CIRCLE, 'getbalance');
  }

  // Get operators list
  async getOperators() {
    return await this.makeRequest(CYRUS_ENDPOINTS.OPERATOR_CIRCLE, 'getoperator');
  }

  // Get circles list
  async getCircles() {
    return await this.makeRequest(CYRUS_ENDPOINTS.OPERATOR_CIRCLE, 'getcircle');
  }

  // Get recharge plans
  async getPlans(operatorId, circleId) {
    return await this.makeRequest(CYRUS_ENDPOINTS.PLANS, 'getplans', {
      OperatorID: operatorId,
      CircleID: circleId
    });
  }

  // Perform recharge
  async performRecharge(mobileNumber, operatorId, circleId, amount, clientId, callbackUrl = null) {
    const params = {
      number: mobileNumber,
      operator: operatorId,
      circle: circleId,
      amount: amount,
      usertx: clientId,
      format: 'json',
      RechargeMode: 1
    };

    // Add callback URL if provided
    if (callbackUrl) {
      params.callbackurl = callbackUrl;
    }

    return await this.makeRequest(CYRUS_ENDPOINTS.RECHARGE, 'recharge', params);
  }

  // Check recharge status
  async getRechargeStatus(clientId) {
    return await this.makeRequest(CYRUS_ENDPOINTS.STATUS, 'getstatus', {
      transid: clientId
    });
  }

  // Validate API configuration
  validateConfig() {
    // Allow default values for development/testing
    if (!this.memberId) {
      throw new Error('Cyrus Member ID is not configured');
    }

    if (!this.pin) {
      throw new Error('Cyrus PIN is not configured');
    }

    if (!this.baseURL) {
      throw new Error('Cyrus Base URL is not configured');
    }

    return true;
  }
}

export default new CyrusService();