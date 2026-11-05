-- Fictional sample records for Online Learning & LMS Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."learner" ("learner_id", "email", "created_at") VALUES (101, 'learner.one@example.test', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."learner" ("learner_id", "email", "created_at") VALUES (102, 'learner.two@example.test', '2026-01-11T09:30:00+00:00');
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date") VALUES (201, 'LMS-101', 'Foundations of Learning', TRUE, '2026-02-01');
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date") VALUES (202, 'LMS-202', 'Applied Study Skills', FALSE, NULL);
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score") VALUES (301, 101, 201, '2026-02-02T10:15:00Z', 'completed', 92);
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score") VALUES (302, 102, 202, '2026-02-03T11:00:00+00:00', 'enrolled', NULL);
COMMIT;
