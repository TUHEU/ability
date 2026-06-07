// routes/jobRoutes.js
const express = require('express');
const router = express.Router();
const job = require('../controllers/jobController');
router.get('/', job.getJobs);
router.post('/', job.createJob);
router.get('/employer-dashboard', job.getEmployerDashboard);
module.exports = router;
