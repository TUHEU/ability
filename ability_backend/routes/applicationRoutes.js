// routes/applicationRoutes.js
const express = require('express');
const router = express.Router();
const app = require('../controllers/applicationController');
router.post('/', app.createApplication);
router.get('/job/:jobId', app.getJobApplications);
router.get('/seeker/:seekerId', app.getSeekerApplications);
router.put('/:applicationId/status', app.updateApplicationStatus);
module.exports = router;
