// controllers/jobController.js
// DESIGN PATTERN: Repository Pattern (data via JobRepository / CompanyRepository)
const JobRepository = require('../repositories/JobRepository');
const CompanyRepository = require('../repositories/CompanyRepository');
const ApplicationRepository = require('../repositories/ApplicationRepository');

// ── POST A JOB ────────────────────────────────────────────────────────────────
exports.createJob = async (req, res) => {
    const { company_id, employer_id, employer_email, title, description, job_type, is_remote, accommodation_offerings } = req.body;
    try {
        let companyId = company_id;

        if (!companyId && employer_email) {
            const company = await CompanyRepository.findByEmployerEmail(employer_email);
            if (company) companyId = company.company_id;
        }
        if (!companyId && employer_id) {
            const company = await CompanyRepository.findByAdminUserId(employer_id);
            if (company) companyId = company.company_id;
        }
        if (!companyId) {
            return res.status(404).json({ message: 'No company profile found for this employer.' });
        }

        const jobId = await JobRepository.create({
            companyId, employerId: employer_id || null,
            title, description, jobType: job_type,
            isRemote: is_remote, accommodations: accommodation_offerings
        });

        res.status(201).json({ message: 'Job posted successfully!', jobId });
    } catch (err) {
        console.error('Create job error:', err);
        res.status(500).json({ message: 'Server error.' });
    }
};

// ── GET ALL JOBS ──────────────────────────────────────────────────────────────
exports.getJobs = async (req, res) => {
    try {
        const jobs = await JobRepository.findAll();
        res.status(200).json(jobs);
    } catch (err) {
        console.error('Get jobs error:', err);
        res.status(500).json({ message: 'Server error.' });
    }
};

// ── EMPLOYER DASHBOARD (by email query param) ─────────────────────────────────
exports.getEmployerDashboard = async (req, res) => {
    const { email } = req.query;
    if (!email) return res.status(400).json({ message: 'Email required.' });
    try {
        const company = await CompanyRepository.findByEmployerEmail(email);
        if (!company) return res.status(200).json({ stats: { totalPosts: 0, totalApps: 0, interviews: 0 }, jobs: [] });

        const adminUserId = company.admin_user_id;
        const jobs         = await JobRepository.findByEmployerId(adminUserId);
        const totalApps    = await ApplicationRepository.countByEmployerId(adminUserId);
        const interviews   = await ApplicationRepository.countInterviewsByEmployerId(adminUserId);

        res.status(200).json({
            stats: { totalPosts: jobs.length, totalApps, interviews },
            jobs
        });
    } catch (err) {
        console.error('Employer dashboard error:', err);
        res.status(500).json({ message: 'Server error.' });
    }
};
