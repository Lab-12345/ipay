const BillProvider = require('../models/BillProvider');
const Transaction = require('../models/Transaction');
const { calculateCommission } = require('../utils/commissionCalculator');
const { responseHandler } = require('../utils/responseHandler');
const billService = require('../services/billService');

// Get all bill providers
exports.getBillProviders = async (req, res) => {
  try {
    const { category, serviceType } = req.query;
    let filter = { isActive: true };
    
    if (category) filter.category = category;
    if (serviceType) filter.serviceType = serviceType;
    
    const providers = await BillProvider.find(filter);
    responseHandler(res, 200, 'Bill providers retrieved successfully', providers);
  } catch (error) {
    responseHandler(res, 500, 'Error retrieving bill providers', null, error.message);
  }
};

// Fetch bill details
exports.fetchBill = async (req, res) => {
  try {
    const { providerCode, accountNumber, customerId } = req.body;
    
    const provider = await BillProvider.findOne({ code: providerCode, isActive: true });
    if (!provider) {
      return responseHandler(res, 404, 'Bill provider not found');
    }
    
    // Validate account details based on provider rules
    if (provider.validationRules.accountNumber) {
      if (accountNumber.length !== provider.validationRules.accountNumber.length) {
        return responseHandler(res, 400, provider.validationRules.accountNumber.note);
      }
    }
    
    // If provider supports bill fetch, get details from external API
    let billDetails = null;
    if (provider.supportsFetch) {
      billDetails = await billService.fetchBillDetails(providerCode, accountNumber, customerId);
    }
    
    responseHandler(res, 200, 'Bill details retrieved successfully', {
      provider: provider.name,
      accountNumber,
      customerId,
      billDetails
    });
  } catch (error) {
    responseHandler(res, 500, 'Error fetching bill details', null, error.message);
  }
};

// Pay bill
exports.payBill = async (req, res) => {
  try {
    const { providerCode, amount, accountNumber, customerId, billDetails } = req.body;
    const userId = req.user.id;
    
    const provider = await BillProvider.findOne({ code: providerCode, isActive: true });
    if (!provider) {
      return responseHandler(res, 404, 'Bill provider not found');
    }
    
    // Validate inputs
    if (provider.validationRules.accountNumber && accountNumber) {
      if (accountNumber.length !== provider.validationRules.accountNumber.length) {
        return responseHandler(res, 400, provider.validationRules.accountNumber.note);
      }
    }
    
    if (provider.validationRules.customerId && customerId) {
      if (customerId.length !== provider.validationRules.customerId.length) {
        return responseHandler(res, 400, provider.validationRules.customerId.note);
      }
    }
    
    // Calculate commission
    const commissionAmount = calculateCommission(amount, provider.commissionPercent);
    
    // Create transaction
    const transaction = new Transaction({
      userId,
      serviceType: provider.serviceType,
      provider: provider.name,
      providerCode,
      amount,
      accountNumber,
      customerId,
      commissionPercent: provider.commissionPercent,
      commissionAmount,
      transactionId: generateTransactionId(),
      billDetails
    });
    
    await transaction.save();
    
    // Process bill payment through payment gateway
    const paymentResult = await billService.processBillPayment(transaction);
    
    if (paymentResult.success) {
      transaction.status = 'success';
      transaction.referenceId = paymentResult.referenceId;
      transaction.responseData = paymentResult;
      await transaction.save();
      
      responseHandler(res, 200, 'Bill payment successful', {
        transactionId: transaction.transactionId,
        amount,
        commission: commissionAmount,
        referenceId: paymentResult.referenceId
      });
    } else {
      transaction.status = 'failed';
      transaction.responseData = paymentResult;
      await transaction.save();
      
      responseHandler(res, 400, 'Bill payment failed', {
        transactionId: transaction.transactionId,
        error: paymentResult.message
      });
    }
  } catch (error) {
    responseHandler(res, 500, 'Error processing bill payment', null, error.message);
  }
};

function generateTransactionId() {
  return 'TXN' + Date.now() + Math.random().toString(36).substr(2, 9).toUpperCase();
}