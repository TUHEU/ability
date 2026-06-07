// controllers/employerController.js
// DESIGN PATTERN: Repository Pattern
const JobRepository = require('../repositories/JobRepository');
const ApplicationRepository = require('../repositories/ApplicationRepository');

exports.getEmployerDashboardStats = async (req, res) => {
    const { employerId } = req.params;
    try {
        const jobs       = await JobRepository.findByEmployerId(employerId);
        const totalApps  = await ApplicationRepository.countByEmployerId(employerId);
        const interviews = await ApplicationRepository.countInterviewsByEmployerId(employerId);
        res.status(200).json({
            stats: { totalPosts: jobs.length, totalApps, interviews },
            jobs
        });
    } catch (err) {
        console.error('Employer dashboard error:', err);
        res.status(500).json({ stats: { totalPosts: 0, totalApps: 0, interviews: 0 }, jobs: [] });
    }
};

exports.getEmployerActiveJobs = async (req, res) => {
    try {
        const jobs = await JobRepository.findByEmployerId(req.params.employerId);
        res.status(200).json(jobs);
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};
