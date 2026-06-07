// controllers/applicationController.js
// DESIGN PATTERN: Repository Pattern
const ApplicationRepository = require('../repositories/ApplicationRepository');
const JobRepository = require('../repositories/JobRepository');
const UserRepository = require('../repositories/UserRepository');

const VALID_STATUSES = ['pending','viewed','interview_offered','interview_scheduled','accepted','rejected'];

exports.createApplication = async (req, res) => {
    const { job_id, seeker_id } = req.body;
    try {
        if (!await JobRepository.findById(job_id))
            return res.status(404).json({ message: 'Job not found.' });

        const seeker = await UserRepository.findById(seeker_id);
        if (!seeker || seeker.role !== 'seeker')
            return res.status(404).json({ message: 'Seeker not found.' });

        if (await ApplicationRepository.findDuplicate(job_id, seeker_id))
            return res.status(400).json({ message: 'Already applied to this job.' });

        const applicationId = await ApplicationRepository.create(job_id, seeker_id);
        res.status(201).json({ message: 'Application submitted!', applicationId });
    } catch (err) {
        console.error('Create application error:', err);
        res.status(500).json({ message: 'Server error.' });
    }
};

exports.getJobApplications = async (req, res) => {
    try {
        const rows = await ApplicationRepository.findByJobId(req.params.jobId);
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};

exports.getSeekerApplications = async (req, res) => {
    try {
        const rows = await ApplicationRepository.findBySeekerId(req.params.seekerId);
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};

exports.updateApplicationStatus = async (req, res) => {
    const { status } = req.body;
    if (!VALID_STATUSES.includes(status))
        return res.status(400).json({ message: 'Invalid status.' });
    try {
        const updated = await ApplicationRepository.updateStatus(req.params.applicationId, status);
        if (!updated) return res.status(404).json({ message: 'Application not found.' });
        res.status(200).json({ message: 'Status updated.' });
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};
