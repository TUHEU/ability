-- ============================================================
-- AbilityBridge — Complete Database Schema
-- ============================================================
CREATE DATABASE IF NOT EXISTS ability_bridge;
USE ability_bridge;

-- 1. USERS
CREATE TABLE IF NOT EXISTS users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100),
    role          ENUM('seeker','employer','mentor','admin') NOT NULL,
    is_verified   BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. COMPANIES (before job_listings — FK dependency)
CREATE TABLE IF NOT EXISTS companies (
    company_id       INT AUTO_INCREMENT PRIMARY KEY,
    admin_user_id    INT NOT NULL,
    company_name     VARCHAR(255) NOT NULL,
    reality_score    DECIMAL(3,2) DEFAULT 0.00,
    inclusivity_tier ENUM('None','Bronze','Silver','Gold') DEFAULT 'None',
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. JOB LISTINGS (employer_id added — required by employerController)
CREATE TABLE IF NOT EXISTS job_listings (
    job_id                  INT AUTO_INCREMENT PRIMARY KEY,
    company_id              INT NOT NULL,
    employer_id             INT,
    title                   VARCHAR(255) NOT NULL,
    description             TEXT,
    job_type                ENUM('full-time','part-time','micro-task') NOT NULL,
    is_remote               BOOLEAN DEFAULT TRUE,
    accommodation_offerings JSON,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 4. SEEKER PROFILES
CREATE TABLE IF NOT EXISTS seeker_profiles (
    profile_id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id              INT UNIQUE NOT NULL,
    full_name            VARCHAR(100),
    location             VARCHAR(150),
    bio                  TEXT,
    resume_text          TEXT,
    anonymous_apply_mode BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 5. APPLICATIONS (interview_scheduled added to ENUM)
CREATE TABLE IF NOT EXISTS applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id         INT NOT NULL,
    seeker_id      INT NOT NULL,
    cover_letter   TEXT,
    status         ENUM('pending','viewed','interview_offered','interview_scheduled','accepted','rejected') DEFAULT 'pending',
    applied_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES job_listings(job_id) ON DELETE CASCADE,
    FOREIGN KEY (seeker_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (job_id, seeker_id)
);

-- 6. MESSAGES
CREATE TABLE IF NOT EXISTS messages (
    message_id  INT AUTO_INCREMENT PRIMARY KEY,
    sender_id   INT NOT NULL,
    receiver_id INT NOT NULL,
    job_id      INT,
    content     TEXT NOT NULL,
    media_url   VARCHAR(255),
    sent_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id),
    FOREIGN KEY (job_id) REFERENCES job_listings(job_id) ON DELETE SET NULL
);

-- 7. SKILLS
CREATE TABLE IF NOT EXISTS skills (
    skill_id   INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS user_skills (
    user_id           INT NOT NULL,
    skill_id          INT NOT NULL,
    is_verified_badge BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (user_id, skill_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

-- 8. ACCESSIBILITY SETTINGS
CREATE TABLE IF NOT EXISTS accessibility_settings (
    setting_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id            INT NOT NULL,
    high_contrast      BOOLEAN DEFAULT FALSE,
    screen_reader_mode BOOLEAN DEFAULT FALSE,
    font_size_scale    DECIMAL(3,2) DEFAULT 1.00,
    dyslexia_font      BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 9. DISABILITY INFO
CREATE TABLE IF NOT EXISTS seeker_disability_info (
    info_id                  INT AUTO_INCREMENT PRIMARY KEY,
    user_id                  INT UNIQUE NOT NULL,
    disability_type          VARCHAR(255),
    accommodation_needs_json JSON,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 10. ACCOMMODATION NEGOTIATIONS
CREATE TABLE IF NOT EXISTS accommodation_negotiations (
    neg_id              INT AUTO_INCREMENT PRIMARY KEY,
    job_id              INT NOT NULL,
    seeker_id           INT NOT NULL,
    status              ENUM('pending','agreed','declined') DEFAULT 'pending',
    final_agreement_log TEXT,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES job_listings(job_id),
    FOREIGN KEY (seeker_id) REFERENCES users(user_id)
);

-- 11. REPORTS
CREATE TABLE IF NOT EXISTS reports (
    report_id         INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id       INT NOT NULL,
    target_company_id INT NOT NULL,
    reason            TEXT NOT NULL,
    status            ENUM('submitted','under_review','resolved') DEFAULT 'submitted',
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES users(user_id),
    FOREIGN KEY (target_company_id) REFERENCES companies(company_id)
);

-- 12. MENTORSHIP PROFILES
CREATE TABLE IF NOT EXISTS mentorship_profiles (
    mentor_id                 INT PRIMARY KEY,
    industry                  VARCHAR(100),
    disability_type_specialty VARCHAR(255),
    bio                       TEXT,
    availability_status       BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (mentor_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 13. MENTORSHIP REQUESTS (uses seeker_id — matches communityController)
CREATE TABLE IF NOT EXISTS mentorship_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    seeker_id  INT NOT NULL,
    mentor_id  INT NOT NULL,
    message    TEXT,
    status     ENUM('pending','accepted','declined','completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seeker_id) REFERENCES users(user_id),
    FOREIGN KEY (mentor_id) REFERENCES users(user_id)
);

-- 14. LEARNING
CREATE TABLE IF NOT EXISTS external_courses (
    course_id       INT AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(255),
    provider        VARCHAR(100),
    url             VARCHAR(500),
    target_skill_id INT,
    FOREIGN KEY (target_skill_id) REFERENCES skills(skill_id)
);

CREATE TABLE IF NOT EXISTS user_learning_history (
    history_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id           INT NOT NULL,
    course_id         INT NOT NULL,
    completion_status ENUM('enrolled','completed') DEFAULT 'enrolled',
    certificate_url   VARCHAR(500),
    completed_at      DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES external_courses(course_id)
);

-- 15. COMMUNITY TABLES
CREATE TABLE IF NOT EXISTS learning_resources (
    resource_id   INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(255) NOT NULL,
    description   TEXT,
    category      VARCHAR(100),
    icon_name     VARCHAR(50),
    lessons_count VARCHAR(50),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS mentors (
    mentor_id  INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    role       VARCHAR(255),
    expertise  VARCHAR(255),
    experience VARCHAR(50),
    available  BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS forum_posts (
    post_id       INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(255) NOT NULL,
    category      VARCHAR(100),
    upvotes       INT DEFAULT 0,
    replies_count INT DEFAULT 0,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── SEED DATA ────────────────────────────────────────────────
INSERT IGNORE INTO learning_resources (title, description, icon_name, lessons_count) VALUES
('Resume Writing for PWDs', 'Craft a standout CV highlighting your strengths', 'description', '5 lessons'),
('Interview Confidence', 'Practice answering common interview questions', 'mic', '8 lessons'),
('Workplace Rights', 'Know your legal rights as a person with a disability', 'gavel', '4 lessons'),
('Negotiating Accommodations', 'How to request what you need from employers', 'handshake', '3 lessons');

INSERT IGNORE INTO mentors (name, role, expertise, experience, available) VALUES
('Dr. Amara Nwosu',  'Career Coach',  'Tech & Accessibility', '10 yrs', TRUE),
('James Feh',        'HR Specialist', 'Inclusive Hiring',     '7 yrs',  TRUE),
('Sophie Tabi',      'Entrepreneur',  'Remote Work',          '5 yrs',  TRUE);

INSERT IGNORE INTO forum_posts (title, category, upvotes, replies_count) VALUES
('Tips for disclosing disability in interviews?', 'Career Advice',  24, 11),
('Best remote jobs for wheelchair users',         'Job Search',     18,  7),
('Accommodation negotiation success story',       'Success Stories', 31, 15);
