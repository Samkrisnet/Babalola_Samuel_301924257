-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. learner pk duplicate. Expected: pk_learner, SQLSTATE 23505.
INSERT INTO portfolio."learner" ("learner_id", "email", "created_at")
VALUES (101, 'fresh.pk.learner@example.test', '2026-03-01T10:00:00Z');

-- 2. learner unique duplicate. Expected: uq_learner_0, SQLSTATE 23505.
INSERT INTO portfolio."learner" ("learner_id", "email", "created_at")
VALUES (5001, 'learner.one@example.test', '2026-03-01T10:01:00Z');

-- 3. learner id not null. Expected: learner_id, SQLSTATE 23502.
INSERT INTO portfolio."learner" ("learner_id", "email", "created_at")
VALUES (NULL, 'fresh.nn.id@example.test', '2026-03-01T10:02:00Z');

-- 4. learner email not null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."learner" ("learner_id", "email", "created_at")
VALUES (5002, NULL, '2026-03-01T10:03:00Z');

-- 5. learner created at not null. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."learner" ("learner_id", "email", "created_at")
VALUES (5003, 'fresh.nn.time@example.test', NULL);

-- 6. course pk duplicate. Expected: pk_course, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date")
VALUES (201, 'FRESH-PK', 'Fresh Course', TRUE, NULL);

-- 7. course unique duplicate. Expected: uq_course_0, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date")
VALUES (5004, 'LMS-101', 'Fresh Course', TRUE, NULL);

-- 8. course id not null. Expected: course_id, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date")
VALUES (NULL, 'FRESH-NN-ID', 'Fresh Course', TRUE, NULL);

-- 9. course code not null. Expected: course_code, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date")
VALUES (5005, NULL, 'Fresh Course', TRUE, NULL);

-- 10. course title not null. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date")
VALUES (5006, 'FRESH-NN-TITLE', NULL, TRUE, NULL);

-- 11. course published not null. Expected: published, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "published", "start_date")
VALUES (5007, 'FRESH-NN-PUBLISHED', 'Fresh Course', NULL, NULL);

-- 12. enrollment pk duplicate. Expected: pk_enrollment, SQLSTATE 23505.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (301, 102, 201, '2026-03-02T10:00:00Z', 'enrolled', 50);

-- 13. enrollment unique duplicate. Expected: uq_enrollment_0, SQLSTATE 23505.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5008, 101, 201, '2026-03-02T10:01:00Z', 'enrolled', 50);

-- 14. enrollment learner fk. Expected: fk_enrollment_0, SQLSTATE 23503.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5009, 9001, 201, '2026-03-02T10:02:00Z', 'enrolled', 50);

-- 15. enrollment course fk. Expected: fk_enrollment_1, SQLSTATE 23503.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5010, 101, 9002, '2026-03-02T10:03:00Z', 'enrolled', 50);

-- 16. enrollment id not null. Expected: enrollment_id, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (NULL, 101, 201, '2026-03-02T10:04:00Z', 'enrolled', 50);

-- 17. enrollment learner not null. Expected: learner_id, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5011, NULL, 201, '2026-03-02T10:05:00Z', 'enrolled', 50);

-- 18. enrollment course not null. Expected: course_id, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5012, 101, NULL, '2026-03-02T10:06:00Z', 'enrolled', 50);

-- 19. enrollment time not null. Expected: enrolled_at, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5013, 101, 201, NULL, 'enrolled', 50);

-- 20. enrollment status not null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5014, 101, 201, '2026-03-02T10:07:00Z', NULL, 50);

-- 21. enrollment status check. Expected: enrollment_status_check, SQLSTATE 23514.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5015, 101, 201, '2026-03-02T10:08:00Z', 'paused', 50);

-- 22. enrollment score check. Expected: enrollment_score_check, SQLSTATE 23514.
INSERT INTO portfolio."enrollment" ("enrollment_id", "learner_id", "course_id", "enrolled_at", "status", "final_score")
VALUES (5016, 101, 201, '2026-03-02T10:09:00Z', 'enrolled', 101);
