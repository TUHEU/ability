// routes/companyRoutes.js
const express = require('express');
const router = express.Router();
const company = require('../controllers/companyController');
router.get('/:companyId/admin', company.getCompanyAdmin);
module.exports = router;
