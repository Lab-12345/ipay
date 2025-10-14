import axios from 'axios';
import { API_CONFIG, CYRUS_ENDPOINTS } from '../config/constants.js';

class CyrusService {
  constructor() {
    this.baseUrl = API_CONFIG.CYRUS.BASE_URL;
    this.memberId = API_CONFIG.CYRUS.MEMBER_ID;
    this.pin = API_CONFIG.CYRUS.PIN;
    this.callbackUrl = API_CONFIG.CYRUS.CALLBACK_URL;
  }

  // 🔹 Generic GET request handler (for endpoints like GetOperator.aspx with Method param)
  async makeGetRequest(endpoint, method = null, extraParams = {}) {
    try {
      const url = `${this.baseUrl}${endpoint}`;
      const params = {
        memberid: this.memberId,
        pin: this.pin,
        ...(method && { Method: method }),
        ...extraParams,
      };

      console.log(`➡️ GET Requesting: ${url}`, params);

      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus API GET error (${endpoint}):`, error.message);
      throw error;
    }
  }

  // 🔹 Generic POST request handler (for BBPS endpoints)
  async makePostRequest(endpoint, methodname, extraData = {}) {
    try {
      const url = `${this.baseUrl}${endpoint}`;
      const data = {
        memberid: this.memberId,
        pin: this.pin,
        methodname,
        ...extraData,
      };

      console.log(`➡️ POST Requesting: ${url}`, data);

      const response = await axios.post(url, data, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus API POST error (${endpoint}):`, error.message);
      throw error;
    }
  }

  // 🔹 Recharge API (handles recharge and bill payment)
  async recharge({
    number,
    amount,
    operator,
    circle,
    referenceId,
    account = null,
    othervalue = null,
    othervalue1 = null,
  }) {
    const endpoint = CYRUS_ENDPOINTS.RECHARGE;
    const url = `${this.baseUrl}${endpoint}`;
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
      ...(account && { account }),
      ...(othervalue && { othervalue }),
      ...(othervalue1 && { othervalue1 }),
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

  // 🔹 Get balance (e-wallet)
  async getBalance() {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.BALANCE, 'getbalance');
  }

  // 🔹 Get AEPS balance
  async getAEPSBalance() {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.AEPS_BALANCE, 'getaepsbalance');
  }

  // 🔹 Get operators
  async getOperators() {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.OPERATOR_CIRCLE, 'getoperator');
  }

  // 🔹 Get circles
  async getCircles() {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.OPERATOR_CIRCLE, 'getcircle');
  }

  // 🔹 Get recharge status
  async getRechargeStatus(referenceId) {
    const endpoint = CYRUS_ENDPOINTS.STATUS;
    const url = `${this.baseUrl}${endpoint}`;
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
    const endpoint = CYRUS_ENDPOINTS.PLANS;
    const url = `${this.baseUrl}${endpoint}`;
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
    const endpoint = CYRUS_ENDPOINTS.MNP;
    const url = `${this.baseUrl}${endpoint}`;
    const params = {
      APIID: this.memberId,
      PASSWORD: this.pin,
      MOBILENUMBER: number,
    };

    console.log(`➡️ Requesting MNP Operator: ${url}`, params);

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus MNP API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Get recharge offers (Roffers)
  async getRechargeOffers(operator, mobile, offerType = 'roffer') {
    const endpoint = CYRUS_ENDPOINTS.ROFFERS;
    const url = `${this.baseUrl}${endpoint}`;
    const params = {
      MerchantID: this.memberId,
      MerchantKey: this.pin,
      MethodName: 'roffer',
      operator,
      mobile,
      offer: offerType,
    };

    console.log(`➡️ Requesting Roffers: ${url}`, params);

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus Roffers API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Get DTH info
  async getDTHInfo(mobile, offerType = 'roffer') {
    const endpoint = CYRUS_ENDPOINTS.DTH_INFO;
    const url = `${this.baseUrl}${endpoint}`;
    const params = {
      MerchantID: this.memberId,
      MerchantKey: this.pin,
      MethodName: 'dthinfo',
      operator: 'DTD',
      mobile,
      offer: offerType,
    };

    console.log(`➡️ Requesting DTH Info: ${url}`, params);

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus DTH Info API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Raise dispute
  async raiseDispute(refid, remarks) {
    const endpoint = CYRUS_ENDPOINTS.DISPUTE;
    const url = `${this.baseUrl}${endpoint}`;
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

  // 🔹 BBPS: Get biller info
  async getBillerInfo(operator) {
    return await this.makePostRequest(CYRUS_ENDPOINTS.BILL_FETCH, 'get_billerinfo', { operator });
  }

  // 🔹 BBPS: Get bill fetch
  async getBillFetch(operator, requestData) {
    return await this.makePostRequest(CYRUS_ENDPOINTS.BILL_FETCH, 'get_billfetch', {
      operator,
      RequestData: requestData,
      format: 'json',
    });
  }
}

export default new CyrusService();
