import axios from 'axios';
import { API_CONFIG, CYRUS_ENDPOINTS } from '../config/constants.js';

class CyrusService {
  constructor() {
    this.baseUrl = API_CONFIG.CYRUS.BASE_URL;
    this.memberId = API_CONFIG.CYRUS.MEMBER_ID;
    this.pin = API_CONFIG.CYRUS.PIN; // Default PIN
    this.operatorPassword = API_CONFIG.CYRUS.OPERATOR_PASSWORD;
    this.dthPassword = API_CONFIG.CYRUS.DTH_PASSWORD;
    this.offerPassword = API_CONFIG.CYRUS.OFFER_PASSWORD;
    this.billPassword = API_CONFIG.CYRUS.BILL_PASSWORD;
    this.callbackUrl = API_CONFIG.CYRUS.CALLBACK_URL;
  }

  // 🔹 Generic GET request handler with password selection
  async makeGetRequest(endpoint, params = {}, password = this.pin) {
    try {
      const url = `${this.baseUrl}${endpoint}`;
      const fullParams = {
        APIID: this.memberId,
        PASSWORD: password,
        ...params,
      };

      console.log(`➡️ GET Requesting: ${url}`, fullParams);

      const response = await axios.get(url, { params: fullParams });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus API GET error (${endpoint}):`, error.message);
      throw error;
    }
  }

  // 🔹 Generic POST request handler
  async makePostRequest(endpoint, methodname, extraData = {}, password = this.pin) {
    try {
      const url = `${this.baseUrl}${endpoint}`;
      const data = {
        APIID: this.memberId,
        PASSWORD: password,
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

  // 🔹 Recharge API
  async recharge({
    number,
    amount,
    operator,
    circle,
    referenceId,
    account = null,
    othervalue = null,
    othervalue1 = null,
    serviceType = 'mobile',
  }) {
    const endpoint = CYRUS_ENDPOINTS.RECHARGE;
    const password = serviceType === 'dth' ? this.dthPassword : this.pin;
    const params = {
      APIID: this.memberId,
      PASSWORD: password,
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
      ...(serviceType && { serviceType }),
    };

    console.log(`➡️ Requesting Recharge: ${url}`, params);

    try {
      const response = await axios.get(`${this.baseUrl}${endpoint}`, { params });
      return response.data;
    } catch (error) {
      console.error(`❌ Cyrus Recharge API error:`, error.message);
      throw error;
    }
  }

  // 🔹 Get balance
  async getBalance() {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.BALANCE, { Method: 'getbalance' });
  }

  // 🔹 Get AEPS balance
  async getAEPSBalance() {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.AEPS_BALANCE, { Method: 'getaepsbalance' });
  }

  // 🔹 Get operator by mobile number (MNP detection)
  async getOperators(number) {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.MNP, { MOBILENUMBER: number }, this.operatorPassword);
  }

  // 🔹 Get circle by mobile number
  async getCircles(number) {
    const response = await this.getOperators(number); // Reuse MNP fetch
    if (response.success) {
      return { id: response.data.circleId, name: response.data.circleName };
    }
    throw new Error(response.error || 'Failed to fetch circle');
  }

  // 🔹 Get recharge status
  async getRechargeStatus(referenceId) {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.STATUS, { transid: referenceId });
  }

  // 🔹 Get plans
  async getPlans(operator, circle, mobile) {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.PLANS, {
      Operator_Code: operator,
      Circle_Code: circle,
      MobileNumber: mobile,
      data: 'ALL',
    }, this.dthPassword); // Use DTH password for plans
  }

  // 🔹 Get recharge offers
  async getRechargeOffers(operator, mobile, offerType = 'roffer') {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.ROFFERS, {
      MethodName: 'roffer',
      operator,
      mobile,
      offer: offerType,
    }, this.offerPassword);
  }

  // 🔹 Get DTH info
  async getDTHInfo(mobile, offerType = 'roffer') {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.DTH_INFO, {
      MethodName: 'dthinfo',
      operator: 'DTD',
      mobile,
      offer: offerType,
    }, this.offerPassword);
  }

  // 🔹 Raise dispute
  async raiseDispute(refid, remarks) {
    return await this.makeGetRequest(CYRUS_ENDPOINTS.DISPUTE, { transid: refid, reason: remarks });
  }

  // 🔹 BBPS: Get biller info
  async getBillerInfo(operator) {
    return await this.makePostRequest(CYRUS_ENDPOINTS.BILL_FETCH, 'get_billerinfo', { operator }, this.billPassword);
  }

  // 🔹 BBPS: Get bill fetch
  async getBillFetch(operator, requestData) {
    return await this.makePostRequest(CYRUS_ENDPOINTS.BILL_FETCH, 'get_billfetch', {
      operator,
      RequestData: requestData,
      format: 'json',
    }, this.billPassword);
  }
}

export default new CyrusService();
