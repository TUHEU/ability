// controllers/companyController.js
// DESIGN PATTERN: Repository Pattern
const CompanyRepository = require('../repositories/CompanyRepository');

exports.getCompanyAdmin = async (req, res) => {
    try {
        const company = await CompanyRepository.findById(req.params.companyId);
        if (!company) return res.status(404).json({ message: 'Company not found.' });
        res.status(200).json({ admin_user_id: company.admin_user_id, company_name: company.company_name });
    } catch (err) {
        res.status(500).json({ message: 'Server error.' });
    }
};
