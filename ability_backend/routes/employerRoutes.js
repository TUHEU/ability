// routes/employerRoutes.js
const express = require('express');
const router = express.Router();
const employer = require('../controllers/employerController');
router.get('/dashboard/:employerId', employer.getEmployerDashboardStats);
router.get('/jobs/:employerId', employer.getEmployerActiveJobs);
module.exports = router;
