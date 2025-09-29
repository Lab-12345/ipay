const mongoose = require('mongoose');
const RechargePlan = require('../models/RechargePlan');
const BillProvider = require('../models/BillProvider');
const config = require('../config/database');

mongoose.connect(config.mongoURI);

const rechargePlans = [
  {
    name: 'Airtel Prepaid-Mobile',
    serviceType: 'Prepaid',
    provider: 'Airtel',
    category: 'Mobile',
    code: 'AT',
    minAmount: 10.00,
    maxAmount: 10000.00,
    numberRequired: true,
    numberExample: '998419',
    numberValidation: {
      length: 10,
      note: '10 Digit Mobile Number'
    },
    commissionPercent: 0.50
  },
  {
    name: 'Airtel Postpaid',
    serviceType: 'Postpaid',
    provider: 'Airtel',
    category: 'Mobile',
    code: 'ATPOST',
    minAmount: 10.00,
    maxAmount: 10000.00,
    numberRequired: true,
    numberExample: '998419',
    numberValidation: {
      length: 10,
      note: '10 Digit Mobile Number'
    },
    commissionPercent: 2.00
  },
  // Add all other recharge plans
];

const billProviders = [
  {
    name: 'BPSC Electricity',
    serviceType: 'Electricity',
    category: 'Utility',
    code: 'BPSC',
    billType: 'postpaid',
    validationRules: {
      accountNumber: {
        length: 12,
        pattern: '^[0-9]{12}$',
        note: '12 digit account number required'
      }
    },
    commissionPercent: 2.50,
    supportsFetch: true
  },
  {
    name: 'Airtel Broadband',
    serviceType: 'Broadband',
    category: 'Broadband',
    code: 'ATBB',
    billType: 'postpaid',
    validationRules: {
      accountNumber: {
        length: 10,
        pattern: '^[0-9]{10}$',
        note: '10 digit account number required'
      }
    },
    commissionPercent: 2.00,
    supportsFetch: true
  },
  {
    name: 'Jio Fiber',
    serviceType: 'Broadband',
    category: 'Broadband',
    code: 'JIOFIBER',
    billType: 'postpaid',
    validationRules: {
      accountNumber: {
        length: 10,
        pattern: '^[0-9]{10}$',
        note: '10 digit account number required'
      }
    },
    commissionPercent: 1.50,
    supportsFetch: true
  },
  // Add more bill providers
];

async function seedData() {
  try {
    // Clear existing data
    await RechargePlan.deleteMany({});
    await BillProvider.deleteMany({});
    
    // Insert new data
    await RechargePlan.insertMany(rechargePlans);
    await BillProvider.insertMany(billProviders);
    
    console.log('Data seeded successfully');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding data:', error);
    process.exit(1);
  }
}

seedData();