-- PostgreSQL 16 - validation of constraints in 001_create_tables.sql.
-- Run the ENTIRE file in project_collab (DBeaver: Alt+X).
-- Run separately from other work: the final ROLLBACK ends this transaction.
-- Test rows are rolled back; existing rows are not updated or deleted.
-- Identity sequences may advance despite ROLLBACK: gaps in IDs are normal.
-- Do not remove BEGIN / ROLLBACK. Do not run the schema or seed again.
-- PASS requires the expected SQLSTATE AND an explicitly allowed named constraint.
-- Alternatives, when documented below, are separated by |.
-- NOT_TESTED describes later business-rule work; it is NOT a passing test.

BEGIN;
SET LOCAL search_path = public;

CREATE TEMP TABLE db_validation_results (
    test_name TEXT NOT NULL,
    result TEXT NOT NULL,
    detail TEXT NOT NULL
) ON COMMIT DROP;

DO $validation$
DECLARE
    u_owner BIGINT; u_member BIGINT; u_applicant BIGINT;
    d_id BIGINT; s_id BIGINT; p_id BIGINT; pos_id BIGINT;
    task_id_value BIGINT; app_id BIGINT; handover_id BIGINT;
    missing_skill_id BIGINT;
    test_case RECORD;
    actual_state TEXT;
    actual_constraint TEXT;
    actual_message TEXT;
    affected_rows BIGINT;
    token TEXT := md5(clock_timestamp()::TEXT || random()::TEXT);
BEGIN
    IF current_database() <> 'project_collab' THEN
        RAISE EXCEPTION 'Connect to project_collab before running validation.';
    END IF;

    -- Dedicated fixtures use their own returned IDs, independent of seed IDs.
    INSERT INTO users (email, password_hash, full_name)
    VALUES ('validation-owner-' || token || '@example.invalid',
        'disabled-validation-account', 'Validation Owner') RETURNING id INTO u_owner;
    INSERT INTO users (email, password_hash, full_name)
    VALUES ('validation-member-' || token || '@example.invalid',
        'disabled-validation-account', 'Validation Member') RETURNING id INTO u_member;
    INSERT INTO users (email, password_hash, full_name)
    VALUES ('validation-applicant-' || token || '@example.invalid',
        'disabled-validation-account', 'Validation Applicant') RETURNING id INTO u_applicant;
    INSERT INTO domain (name) VALUES ('Validation ' || token) RETURNING id INTO d_id;
    INSERT INTO skill (name) VALUES ('Validation Skill ' || token) RETURNING id INTO s_id;
    INSERT INTO skill_domain (skill_id, domain_id) VALUES (s_id, d_id);
    SELECT MAX(id) + 1 INTO missing_skill_id FROM skill;
    INSERT INTO user_skill (user_id, skill_id, level) VALUES (u_member, s_id, 4);

    INSERT INTO project (creator_id, title, description)
    VALUES (u_owner, 'Validation Project ' || token, 'Temporary test fixture')
    RETURNING id INTO p_id;
    INSERT INTO project_domain (project_id, domain_id) VALUES (p_id, d_id);
    INSERT INTO project_member (project_id, user_id, role) VALUES
        (p_id, u_owner, 'owner'), (p_id, u_member, 'member');
    INSERT INTO position (project_id, title, description, slots)
    VALUES (p_id, 'Validation Position', 'Temporary test fixture', 2)
    RETURNING id INTO pos_id;
    INSERT INTO position_skill_requirement (position_id, skill_id, min_level)
    VALUES (pos_id, s_id, 3);
    INSERT INTO position_assignment (user_id, position_id) VALUES (u_member, pos_id);
    INSERT INTO application (position_id, applicant_id)
    VALUES (pos_id, u_applicant) RETURNING id INTO app_id;
    INSERT INTO task (project_id, title, description)
    VALUES (p_id, 'Validation Task', 'Temporary test fixture') RETURNING id INTO task_id_value;
    INSERT INTO task_assignment (task_id, user_id) VALUES (task_id_value, u_member);
    INSERT INTO project_status_history (project_id, changed_by, old_status, new_status)
    VALUES (p_id, u_owner, 'active', 'planning');
    INSERT INTO project_handover (project_id, from_user_id, to_user_id)
    VALUES (p_id, u_owner, u_member) RETURNING id INTO handover_id;

    INSERT INTO db_validation_results VALUES
        ('01_valid_fixture', 'PASS', 'Valid rows were inserted into all 16 tables; all will be rolled back.');

    FOR test_case IN
        SELECT * FROM (VALUES
            ('02_duplicate_email',
                format('UPDATE users SET email = (SELECT email FROM users WHERE id = %s) WHERE id = %s', u_owner, u_member),
                '23505', 'uq_users_email'),
            ('03_duplicate_domain_name',
                format('INSERT INTO domain (name) SELECT name FROM domain WHERE id = %s', d_id),
                '23505', 'uq_domain_name'),
            ('04_required_full_name',
                format('UPDATE users SET full_name = NULL WHERE id = %s', u_member),
                '23502', NULL),
            ('05_missing_skill_foreign_key',
                format('UPDATE user_skill SET skill_id = %s WHERE user_id = %s AND skill_id = %s', missing_skill_id, u_member, s_id),
                '23503', 'user_skill_skill_id_fkey'),
            ('06_duplicate_skill_domain_pair',
                format('INSERT INTO skill_domain (skill_id, domain_id) VALUES (%s, %s)', s_id, d_id),
                '23505', 'skill_domain_pkey'),
            ('07_skill_level_zero',
                format('UPDATE user_skill SET level = 0 WHERE user_id = %s AND skill_id = %s', u_member, s_id),
                '23514', 'ck_user_skill_level'),
            ('08_skill_level_six',
                format('UPDATE user_skill SET level = 6 WHERE user_id = %s AND skill_id = %s', u_member, s_id),
                '23514', 'ck_user_skill_level'),
            ('09_requirement_level_zero',
                format('UPDATE position_skill_requirement SET min_level = 0 WHERE position_id = %s AND skill_id = %s', pos_id, s_id),
                '23514', 'ck_position_skill_min_level'),
            ('10_unknown_project_status',
                format($sql$UPDATE project SET status = 'invalid' WHERE id = %s$sql$, p_id),
                '23514', 'ck_project_status'),
            ('11_position_zero_slots',
                format('UPDATE position SET slots = 0 WHERE id = %s', pos_id),
                '23514', 'ck_position_slots'),
            ('12_position_negative_slots',
                format('UPDATE position SET slots = -1 WHERE id = %s', pos_id),
                '23514', 'ck_position_slots'),
            ('13_closed_position_without_time',
                format($sql$UPDATE position SET status = 'closed', closed_at = NULL WHERE id = %s$sql$, pos_id),
                '23514', 'ck_position_closed_at'),
            ('14_position_closed_before_creation',
                format($sql$UPDATE position SET status = 'closed', closed_at = created_at - INTERVAL '1 second' WHERE id = %s$sql$, pos_id),
                '23514', 'ck_position_closed_at'),
            ('15_unknown_member_role',
                format($sql$UPDATE project_member SET role = 'admin' WHERE project_id = %s AND user_id = %s$sql$, p_id, u_member),
                '23514', 'ck_project_member_role'),
            ('16_second_active_owner',
                format($sql$UPDATE project_member SET role = 'owner' WHERE project_id = %s AND user_id = %s$sql$, p_id, u_member),
                '23505', 'uq_project_active_owner'),
            ('17_membership_ends_before_join',
                format($sql$UPDATE project_member SET left_at = joined_at - INTERVAL '1 second' WHERE project_id = %s AND user_id = %s$sql$, p_id, u_member),
                '23514', 'ck_project_member_dates'),
            ('18_position_assignment_bad_dates',
                format($sql$UPDATE position_assignment SET ended_at = started_at - INTERVAL '1 second' WHERE user_id = %s AND position_id = %s$sql$, u_member, pos_id),
                '23514', 'ck_position_assignment_dates'),
            ('19_second_pending_application',
                format('INSERT INTO application (position_id, applicant_id) VALUES (%s, %s)', pos_id, u_applicant),
                '23505', 'uq_application_pending'),
            ('20_accepted_without_processor_or_time',
                format($sql$UPDATE application SET status = 'accepted' WHERE id = %s$sql$, app_id),
                '23514', 'ck_application_decision'),
            ('21_decision_before_application',
                format($sql$UPDATE application SET status = 'rejected', processed_by = %s, decided_at = applied_at - INTERVAL '1 second' WHERE id = %s$sql$, u_owner, app_id),
                '23514', 'ck_application_decision'),
            ('22_pending_with_processor',
                format('UPDATE application SET processed_by = %s WHERE id = %s', u_owner, app_id),
                '23514', 'ck_application_decision'),
            ('23_unknown_task_status',
                format($sql$UPDATE task SET status = 'invalid' WHERE id = %s$sql$, task_id_value),
                -- Both checks reject an unknown status; either may be reported first.
                '23514', 'ck_task_status|ck_task_completed_at'),
            ('24_done_without_completed_at',
                format($sql$UPDATE task SET status = 'done', completed_at = NULL WHERE id = %s$sql$, task_id_value),
                '23514', 'ck_task_completed_at'),
            ('25_task_completed_before_creation',
                format($sql$UPDATE task SET status = 'done', completed_at = created_at - INTERVAL '1 second' WHERE id = %s$sql$, task_id_value),
                '23514', 'ck_task_completed_at'),
            ('26_task_update_before_creation',
                format($sql$UPDATE task SET updated_at = created_at - INTERVAL '1 second' WHERE id = %s$sql$, task_id_value),
                '23514', 'ck_task_updated_at'),
            ('27_task_assignment_bad_dates',
                format($sql$UPDATE task_assignment SET unassigned_at = assigned_at - INTERVAL '1 second' WHERE task_id = %s AND user_id = %s$sql$, task_id_value, u_member),
                '23514', 'ck_task_assignment_dates'),
            ('28_handover_to_self',
                format('UPDATE project_handover SET to_user_id = from_user_id WHERE id = %s', handover_id),
                '23514', 'ck_handover_users'),
            ('29_second_pending_handover',
                format('INSERT INTO project_handover (project_id, from_user_id, to_user_id) VALUES (%s, %s, %s)', p_id, u_owner, u_member),
                '23505', 'uq_handover_pending'),
            ('30_accepted_handover_without_time',
                format($sql$UPDATE project_handover SET status = 'accepted', decided_at = NULL WHERE id = %s$sql$, handover_id),
                '23514', 'ck_handover_decision'),
            ('31_handover_decision_before_request',
                format($sql$UPDATE project_handover SET status = 'rejected', decided_at = requested_at - INTERVAL '1 second' WHERE id = %s$sql$, handover_id),
                '23514', 'ck_handover_decision'),
            ('32_unchanged_status_history',
                format($sql$INSERT INTO project_status_history (project_id, changed_by, old_status, new_status) VALUES (%s, %s, 'active', 'active')$sql$, p_id, u_owner),
                '23514', 'ck_history_status_change'),
            ('33_valid_level_lower_bound',
                format('UPDATE user_skill SET level = 1 WHERE user_id = %s AND skill_id = %s', u_member, s_id),
                '00000', NULL),
            ('34_valid_level_upper_bound',
                format('UPDATE user_skill SET level = 5 WHERE user_id = %s AND skill_id = %s', u_member, s_id),
                '00000', NULL),
            ('35_valid_closed_position',
                format($sql$UPDATE position SET status = 'closed', closed_at = created_at WHERE id = %s$sql$, pos_id),
                '00000', NULL),
            ('36_valid_completed_task',
                format($sql$UPDATE task SET status = 'done', completed_at = created_at WHERE id = %s$sql$, task_id_value),
                '00000', NULL)
        ) AS tests(test_name, sql_text, expected_state, expected_constraint)
    LOOP
        BEGIN
            EXECUTE test_case.sql_text;
            GET DIAGNOSTICS affected_rows = ROW_COUNT;
            IF affected_rows <> 1 THEN
                RAISE EXCEPTION 'Expected one affected fixture row, got %.', affected_rows;
            END IF;
            IF test_case.expected_state <> '00000' THEN
                -- Force rollback of an invalid write that was incorrectly accepted.
                RAISE EXCEPTION USING ERRCODE = 'P0001',
                    MESSAGE = 'Invalid data was accepted; the expected constraint did not reject it.';
            END IF;
            INSERT INTO db_validation_results VALUES
                (test_case.test_name, 'PASS', 'Valid data was accepted.');
        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS
                actual_state = RETURNED_SQLSTATE,
                actual_constraint = CONSTRAINT_NAME,
                actual_message = MESSAGE_TEXT;
            INSERT INTO db_validation_results VALUES (
                test_case.test_name,
                CASE WHEN actual_state = test_case.expected_state
                    AND (test_case.expected_constraint IS NULL
                        OR actual_constraint = ANY (
                            string_to_array(test_case.expected_constraint, '|')
                        ))
                    THEN 'PASS' ELSE 'FAIL' END,
                format('Expected %s / %s; received %s / %s. %s',
                    test_case.expected_state, COALESCE(test_case.expected_constraint, '(any)'),
                    actual_state, actual_constraint, actual_message)
            );
        END;
    END LOOP;

    INSERT INTO db_validation_results VALUES
        ('NEXT_01_exactly_one_owner', 'NOT_TESTED', 'The base index ensures AT MOST one active owner. AT LEAST one at commit needs additional implementation.'),
        ('NEXT_02_capacity_and_concurrency', 'NOT_TESTED', 'Active assignees <= slots, including simultaneous approvals, needs transactions/locking.'),
        ('NEXT_03_membership_same_project', 'NOT_TESTED', 'Position/task assignments need active membership in the same project.'),
        ('NEXT_04_domain_required', 'NOT_TESTED', 'Each skill/project must have at least one domain; foreign keys alone do not enforce this.'),
        ('NEXT_05_workflow_atomicity', 'NOT_TESTED', 'Approval, handover, leaving, history and activity updates need coordinated workflows and tests.');
END;
$validation$;

-- Expected with the unchanged base schema: 36 PASS, 0 FAIL, 5 NOT_TESTED.
SELECT test_name, result, detail
FROM db_validation_results
ORDER BY test_name;

SELECT result, COUNT(*) AS test_count
FROM db_validation_results
GROUP BY result
ORDER BY result;

ROLLBACK;
