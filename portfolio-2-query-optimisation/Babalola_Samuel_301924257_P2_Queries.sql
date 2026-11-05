-- Show related enrollment, learner, course records (up to 20).
SELECT t0."enrollment_id" AS "enrollment_enrollment_id",
       t0."enrolled_at" AS "enrollment_enrolled_at",
       t1."learner_id" AS "learner_learner_id",
       t1."email" AS "learner_email",
       t2."course_id" AS "course_course_id",
       t2."course_code" AS "course_course_code"
FROM portfolio."enrollment" t0
JOIN portfolio."learner" t1 ON t0."learner_id" = t1."learner_id"
JOIN portfolio."course" t2 ON t0."course_id" = t2."course_id"
ORDER BY t0."enrollment_id", t1."learner_id", t2."course_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."enrollment_id" AS "enrollment_enrollment_id",
       t0."enrolled_at" AS "enrollment_enrolled_at",
       t1."learner_id" AS "learner_learner_id",
       t1."email" AS "learner_email",
       t2."course_id" AS "course_course_id",
       t2."course_code" AS "course_course_code"
FROM portfolio."enrollment" t0
JOIN portfolio."learner" t1 ON t0."learner_id" = t1."learner_id"
JOIN portfolio."course" t2 ON t0."course_id" = t2."course_id"
ORDER BY t0."enrollment_id", t1."learner_id", t2."course_id"
LIMIT 20;

-- Find course records where course_code matches "LMS-101" (up to 20).
SELECT * FROM portfolio."course"
WHERE "course_code" IS NOT DISTINCT FROM 'LMS-101'
ORDER BY "course_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."course"
WHERE "course_code" IS NOT DISTINCT FROM 'LMS-101'
ORDER BY "course_id"
LIMIT 20;

-- Count enrollment records for each learner_id (up to 20 groups).
SELECT "learner_id", count(*) AS record_count
FROM portfolio."enrollment"
GROUP BY "learner_id"
ORDER BY record_count DESC, "learner_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "learner_id", count(*) AS record_count
FROM portfolio."enrollment"
GROUP BY "learner_id"
ORDER BY record_count DESC, "learner_id" NULLS LAST
LIMIT 20;
