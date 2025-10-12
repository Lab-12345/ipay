// services/cyrusService.js
import axios from 'axios';
import { API_CONFIG, CYRUS_ENDPOINTS } from '../config/constants.js';

class CyrusService {
  constructor() {
    this.baseUrl = API_CONFIG.CYRUS.BASE_URL;
    this.memberId = API_CONFIG.CYRUS.MEMBER_ID;
    this.pin = API_CONFIG.CYRUS.PIN;
    this.callbackUrl = API_CONFIG.CYRUS.CALLBACK_URL;
  }

  // 🔹 Generic request handler
  async makeRequest(endpoint, method, extraParams = {}) {
    try {
      const url = `${this.baseUrl}/${endpoint}`;
      const params = {
        memberid: this.memberId,
        pin: this.pin,
        Method: method,
        ...extraParams,
      };

      console.log(`➡️ Requesting: ${url}`, params);

      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus API error (${endpoint}):`, error.message);
      throw error;
    }
  }

  // 🔹 Recharge API
  async recharge({ number, amount, operator, circle, referenceId }) {
    return await this.makeRequest(CYRUS_ENDPOINTS.RECHARGE, 'recharge', {
      mobile: number,
      amount,
      operator,
      circle,
      refid: referenceId,
      callbackurl: this.callbackUrl,
    });
  }

  // 🔹 Get balance
  async getBalance() {
    return await this.makeRequest(CYRUS_ENDPOINTS.BALANCE, 'getbalance');
  }

  // 🔹 Get operators
  async getOperators() {
    return await this.makeRequest(CYRUS_ENDPOINTS.OPERATORS, 'getoperator');
  }

  // 🔹 Get circles
  async getCircles() {
    return await this.makeRequest(CYRUS_ENDPOINTS.CIRCLES, 'getcircle');
  }

  // 🔹 Get recharge status
  async getRechargeStatus(referenceId) {
    return await this.makeRequest(CYRUS_ENDPOINTS.STATUS, 'rechargestatus', {
      refid: referenceId,
    });
  }

  // 🔹 Get plans
  async getPlans(operator, circle) {
    return await this.makeRequest(CYRUS_ENDPOINTS.PLANS, 'getplan', {
      operator,
      circle,
    });
  }

  // 🔹 Get operator by mobile number (MNP detection)
  async getOperatorByNumber(number) {
    return await this.makeRequest('CyrusOperatorFatchAPI.aspx', 'getoperatorbymnp', {
      mobile: number,
    });
  }

  // 🔹 Get recharge offers (Roffers)
  async getRechargeOffers(operator, mobile, offerType = 'roffer') {
    // Note: This uses a different param structure based on the endpoint
    try {
      const url = `${this.baseUrl}/CyrusROfferAPI.aspx`;
      const params = {
        MerchantID: this.memberId, // Assuming MerchantID is same as memberId
        MerchantKey: this.pin, // Assuming MerchantKey is same as pin
        MethodName: 'roffer',
        operator,
        mobile,
        offer: offerType,
      };

      console.log(`➡️ Requesting Roffers: ${url}`, params);

      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus Roffers API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Raise dispute
  async raiseDispute(refid, remarks) {
    return await this.makeRequest(CYRUS_ENDPOINTS.DISPUTE, 'raiseDispute', {
      refid,
      remarks,
    });
  }
}

export default new CyrusService();
