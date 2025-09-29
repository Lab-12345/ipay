const express = require('express');
const router = express.Router();
const billController = require('../controllers/billController');
const { authenticate } = require('../middleware/auth');
const { validateBillFetch, validateBillPayment } = require('../middleware/validation');

router.get('/providers', billController.getBillProviders);
router.post('/fetch', authenticate, validateBillFetch, billController.fetchBill);
router.post('/pay', authenticate, validateBillPayment, billController.payBill);

module.exports = router;