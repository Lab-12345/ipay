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
    const url = 'https://cyrusrecharge.in/services_cyapi/recharge_cyapi.aspx';
    const params = {
      memberid: this.memberId,
      pin: this.pin,
      number,
      operator,
      circle,
      amount,
      usertx: referenceId,
      format: 'json',
      RechargeMode: 1,
    };

    console.log(`➡️ Requesting Recharge: ${url}`, params);

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus Recharge API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Get balance
  async getBalance() {
    return await this.makeRequest('api/GetOperator.aspx', 'getbalance');
  }

  // 🔹 Get operators
  async getOperators() {
    return await this.makeRequest('api/GetOperator.aspx', 'getoperator');
  }

  // 🔹 Get circles
  async getCircles() {
    return await this.makeRequest('api/GetOperator.aspx', 'getcircle');
  }

  // 🔹 Get recharge status
  async getRechargeStatus(referenceId) {
    const url = 'http://cyrusrecharge.in/api/rechargestatus.aspx';
    const params = {
      memberid: this.memberId,
      pin: this.pin,
      transid: referenceId,
    };

    console.log(`➡️ Requesting Status: ${url}`, params);

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus Status API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Get plans
  async getPlans(operator, circle, mobile) {
    const url = 'https://cyrusrecharge.in/API/CyrusPlanFatchAPI.aspx';
    const params = {
      APIID: this.memberId,
      PASSWORD: this.pin,
      Operator_Code: operator,
      Circle_Code: circle,
      MobileNumber: mobile,
      data: 'ALL',
    };

    console.log(`➡️ Requesting Plans: ${url}`, params);

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus Plans API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Get operator by mobile number (MNP detection)
  async getOperatorByNumber(number) {
    return await this.makeRequest('API/CyrusOperatorFatchAPI.aspx', 'getoperatorbymnp', {
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
    const url = 'https://cyrusrecharge.in/api/api_raise_dispute.aspx';
    const params = {
      memberid: this.memberId,
      pin: this.pin,
      transid: refid,
      reason: remarks,
    };

    console.log(`➡️ Requesting Dispute: ${url}`, params);

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus Dispute API error:`, error.message);
      throw error;
    }
  }
}

export default new CyrusService();
