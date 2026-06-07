// server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
require('./config/db'); // initialise pool + connection check

const app = express();
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth',         require('./routes/authRoutes'));
app.use('/api/jobs',         require('./routes/jobRoutes'));
app.use('/api/applications', require('./routes/applicationRoutes'));
app.use('/api/messages',     require('./routes/messageRoutes'));
app.use('/api/companies',    require('./routes/companyRoutes'));
app.use('/api/employers',    require('./routes/employerRoutes'));
app.use('/api/community',    require('./routes/communityRoutes'));

app.get('/', (_, res) => res.send('AbilityBridge API is running...'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`🚀 Server on port ${PORT}`));
