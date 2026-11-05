-- PostgreSQL 16 - fictional data for database development only.
-- Run AFTER 001_create_tables.sql, in project_collab, using Execute SQL Script.
-- Run once. Existing data is not deleted or overwritten.
-- Demo password hashes are NOT login credentials. Test registration/login
-- through the backend when its password encoder is implemented.

BEGIN;
SET LOCAL search_path = public;

DO $seed$
DECLARE
    u_owner BIGINT; u_backend BIGINT; u_designer BIGINT;
    u_marketing BIGINT; u_applicant BIGINT;
    d_tech BIGINT; d_design BIGINT; d_marketing BIGINT;
    s_java BIGINT; s_sql BIGINT; s_figma BIGINT;
    s_ui BIGINT; s_content BIGINT; s_seo BIGINT;
    p_web BIGINT; p_campaign BIGINT;
    pos_backend BIGINT; pos_designer BIGINT; pos_content BIGINT;
    task_db BIGINT; task_api BIGINT; task_ui BIGINT; task_plan BIGINT;
    t0 TIMESTAMPTZ := CURRENT_TIMESTAMP - INTERVAL '7 days';
    -- Public bcrypt example hash: sample rows only, not a shared login.
    demo_hash TEXT := '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy';
BEGIN
    IF current_database() <> 'project_collab' THEN
        RAISE EXCEPTION 'Connect to project_collab first.';
    END IF;
    IF EXISTS (
        SELECT 1 FROM users
        WHERE email IN (
            'owner.demo@example.com', 'backend.demo@example.com',
            'designer.demo@example.com', 'marketing.demo@example.com',
            'applicant.demo@example.com'
        )
    ) THEN
        RAISE EXCEPTION 'Demo users already exist. Do not run this seed twice.';
    END IF;

    INSERT INTO users (email, password_hash, full_name, bio, created_at)
    VALUES ('owner.demo@example.com', demo_hash, 'Demo Owner', 'Project coordinator', t0 - INTERVAL '1 day')
    RETURNING id INTO u_owner;
    INSERT INTO users (email, password_hash, full_name, bio, created_at)
    VALUES ('backend.demo@example.com', demo_hash, 'Demo Backend', 'Java and SQL developer', t0 - INTERVAL '1 day')
    RETURNING id INTO u_backend;
    INSERT INTO users (email, password_hash, full_name, bio, created_at)
    VALUES ('designer.demo@example.com', demo_hash, 'Demo Designer', 'UI/UX designer', t0 - INTERVAL '1 day')
    RETURNING id INTO u_designer;
    INSERT INTO users (email, password_hash, full_name, bio, created_at)
    VALUES ('marketing.demo@example.com', demo_hash, 'Demo Marketing', 'Campaign coordinator', t0 - INTERVAL '1 day')
    RETURNING id INTO u_marketing;
    INSERT INTO users (email, password_hash, full_name, bio, created_at)
    VALUES ('applicant.demo@example.com', demo_hash, 'Demo Applicant', 'Looking for a project', t0 - INTERVAL '1 day')
    RETURNING id INTO u_applicant;

    -- Reuse an existing domain with the same unique name, if present.
    INSERT INTO domain (name) VALUES ('Technology') ON CONFLICT (name) DO NOTHING;
    INSERT INTO domain (name) VALUES ('Design') ON CONFLICT (name) DO NOTHING;
    INSERT INTO domain (name) VALUES ('Marketing') ON CONFLICT (name) DO NOTHING;
    SELECT id INTO d_tech FROM domain WHERE name = 'Technology';
    SELECT id INTO d_design FROM domain WHERE name = 'Design';
    SELECT id INTO d_marketing FROM domain WHERE name = 'Marketing';

    INSERT INTO skill (name) VALUES ('Java') RETURNING id INTO s_java;
    INSERT INTO skill (name) VALUES ('SQL') RETURNING id INTO s_sql;
    INSERT INTO skill (name) VALUES ('Figma') RETURNING id INTO s_figma;
    INSERT INTO skill (name) VALUES ('UI/UX Design') RETURNING id INTO s_ui;
    INSERT INTO skill (name) VALUES ('Content Writing') RETURNING id INTO s_content;
    INSERT INTO skill (name) VALUES ('SEO') RETURNING id INTO s_seo;

    INSERT INTO skill_domain (skill_id, domain_id) VALUES
        (s_java, d_tech), (s_sql, d_tech), (s_figma, d_design),
        (s_ui, d_design), (s_ui, d_tech),
        (s_content, d_marketing), (s_seo, d_marketing), (s_seo, d_tech);

    INSERT INTO user_skill (user_id, skill_id, level) VALUES
        (u_owner, s_java, 3), (u_owner, s_sql, 3),
        (u_backend, s_java, 4), (u_backend, s_sql, 4),
        (u_designer, s_figma, 4), (u_designer, s_ui, 4),
        (u_marketing, s_content, 4), (u_marketing, s_seo, 4),
        (u_applicant, s_java, 3), (u_applicant, s_sql, 2);

    INSERT INTO project (creator_id, title, description, status, created_at, last_activity_at)
    VALUES (u_owner, 'SkillBridge Demo', 'A collaboration website built by developers and designers.',
        'active', t0, t0 + INTERVAL '5 days')
    RETURNING id INTO p_web;
    INSERT INTO project (creator_id, title, description, status, created_at, last_activity_at)
    VALUES (u_marketing, 'Community Campaign Demo', 'A community campaign currently paused while seeking collaborators.',
        'paused', t0, t0 + INTERVAL '3 days 1 hour')
    RETURNING id INTO p_campaign;

    INSERT INTO project_domain (project_id, domain_id) VALUES
        (p_web, d_tech), (p_web, d_design),
        (p_campaign, d_marketing), (p_campaign, d_design);

    INSERT INTO position (project_id, title, description, slots, status, created_at)
    VALUES (p_web, 'Backend Developer', 'Build the API and database integration.', 2, 'open', t0)
    RETURNING id INTO pos_backend;
    INSERT INTO position (project_id, title, description, slots, status, created_at, closed_at)
    VALUES (p_web, 'UI/UX Designer', 'Design the collaboration screens.', 1, 'closed', t0, t0 + INTERVAL '2 days')
    RETURNING id INTO pos_designer;
    INSERT INTO position (project_id, title, description, slots, status, created_at, closed_at)
    VALUES (p_campaign, 'Content Writer', 'Create campaign content.', 2, 'closed', t0, t0 + INTERVAL '3 days')
    RETURNING id INTO pos_content;

    INSERT INTO position_skill_requirement (position_id, skill_id, min_level) VALUES
        (pos_backend, s_java, 3), (pos_backend, s_sql, 3),
        (pos_designer, s_figma, 3), (pos_designer, s_ui, 3),
        (pos_content, s_content, 3), (pos_content, s_seo, 2);

    INSERT INTO project_member (project_id, user_id, role, joined_at) VALUES
        (p_web, u_owner, 'owner', t0),
        (p_web, u_backend, 'member', t0 + INTERVAL '1 day'),
        (p_web, u_designer, 'member', t0 + INTERVAL '2 days'),
        (p_campaign, u_marketing, 'owner', t0);

    INSERT INTO position_assignment (user_id, position_id, started_at) VALUES
        (u_backend, pos_backend, t0 + INTERVAL '1 day'),
        (u_designer, pos_designer, t0 + INTERVAL '2 days');

    -- Accepted decisions match the memberships and assignments above.
    INSERT INTO application (position_id, applicant_id, processed_by, message, status, applied_at, decided_at) VALUES
        (pos_backend, u_backend, u_owner, 'I can develop the Java API.', 'accepted',
            t0 + INTERVAL '12 hours', t0 + INTERVAL '1 day'),
        (pos_designer, u_designer, u_owner, 'I can design the interface.', 'accepted',
            t0 + INTERVAL '36 hours', t0 + INTERVAL '2 days'),
        (pos_backend, u_applicant, NULL, 'I would like to join the backend team.', 'pending',
            t0 + INTERVAL '3 days', NULL),
        (pos_designer, u_applicant, u_owner, 'I am also interested in design.', 'rejected',
            t0 + INTERVAL '18 hours', t0 + INTERVAL '20 hours'),
        (pos_backend, u_designer, NULL, 'I withdrew this additional application.', 'withdrawn',
            t0 + INTERVAL '3 days', NULL);

    INSERT INTO task (project_id, title, description, status, due_date, created_at, updated_at, completed_at)
    VALUES (p_web, 'Design database', 'Prepare the relational schema.', 'done',
        (t0 + INTERVAL '5 days')::DATE, t0 + INTERVAL '2 days', t0 + INTERVAL '4 days', t0 + INTERVAL '4 days')
    RETURNING id INTO task_db;
    INSERT INTO task (project_id, title, description, status, due_date, created_at, updated_at)
    VALUES (p_web, 'Implement project API', 'Build project endpoints.', 'in_progress',
        CURRENT_DATE + 5, t0 + INTERVAL '2 days', t0 + INTERVAL '5 days')
    RETURNING id INTO task_api;
    INSERT INTO task (project_id, title, description, status, due_date, created_at, updated_at)
    VALUES (p_web, 'Review interface', 'Review the design with the project owner.', 'todo',
        CURRENT_DATE + 7, t0 + INTERVAL '3 days', t0 + INTERVAL '3 days')
    RETURNING id INTO task_ui;
    INSERT INTO task (project_id, title, description, status, due_date, created_at, updated_at)
    VALUES (p_campaign, 'Prepare campaign plan', 'Draft the plan before recruiting new collaborators.', 'todo',
        NULL, t0 + INTERVAL '1 day', t0 + INTERVAL '1 day')
    RETURNING id INTO task_plan;

    -- Two members collaborate on the same task.
    INSERT INTO task_assignment (task_id, user_id, assigned_at) VALUES
        (task_db, u_backend, t0 + INTERVAL '2 days 3 hours'),
        (task_db, u_designer, t0 + INTERVAL '2 days 3 hours'),
        (task_api, u_backend, t0 + INTERVAL '2 days 3 hours'),
        (task_ui, u_owner, t0 + INTERVAL '3 days'),
        (task_plan, u_marketing, t0 + INTERVAL '1 day 1 hour');

    INSERT INTO project_status_history (project_id, changed_by, old_status, new_status, changed_at, note) VALUES
        (p_web, u_owner, 'planning', 'active', t0 + INTERVAL '6 hours', 'Started the project.'),
        (p_campaign, u_marketing, 'planning', 'active', t0 + INTERVAL '12 hours', 'Started the campaign.'),
        (p_campaign, u_marketing, 'active', 'paused', t0 + INTERVAL '3 days 1 hour', 'Paused while seeking more people.');

    INSERT INTO project_handover (project_id, from_user_id, to_user_id, requested_at, status, note)
    VALUES (p_web, u_owner, u_backend, t0 + INTERVAL '5 days', 'pending',
        'A pending request does not change the current owner.');
END;
$seed$;

COMMIT;

-- Expected counts if this database had no rows before seeding:
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL SELECT 'domain', COUNT(*) FROM domain
UNION ALL SELECT 'skill', COUNT(*) FROM skill
UNION ALL SELECT 'skill_domain', COUNT(*) FROM skill_domain
UNION ALL SELECT 'user_skill', COUNT(*) FROM user_skill
UNION ALL SELECT 'project', COUNT(*) FROM project
UNION ALL SELECT 'project_domain', COUNT(*) FROM project_domain
UNION ALL SELECT 'position', COUNT(*) FROM position
UNION ALL SELECT 'position_skill_requirement', COUNT(*) FROM position_skill_requirement
UNION ALL SELECT 'project_member', COUNT(*) FROM project_member
UNION ALL SELECT 'position_assignment', COUNT(*) FROM position_assignment
UNION ALL SELECT 'application', COUNT(*) FROM application
UNION ALL SELECT 'task', COUNT(*) FROM task
UNION ALL SELECT 'task_assignment', COUNT(*) FROM task_assignment
UNION ALL SELECT 'project_status_history', COUNT(*) FROM project_status_history
UNION ALL SELECT 'project_handover', COUNT(*) FROM project_handover;
