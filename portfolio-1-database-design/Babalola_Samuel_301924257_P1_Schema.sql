-- Online Learning & LMS Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."learner" (
  "learner_id" bigint NOT NULL,
  "email" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_learner" PRIMARY KEY ("learner_id"),
  CONSTRAINT "uq_learner_0" UNIQUE ("email")
);
CREATE TABLE portfolio."course" (
  "course_id" bigint NOT NULL,
  "course_code" text NOT NULL,
  "title" text NOT NULL,
  "published" boolean NOT NULL,
  "start_date" date,
  CONSTRAINT "pk_course" PRIMARY KEY ("course_id"),
  CONSTRAINT "uq_course_0" UNIQUE ("course_code")
);
CREATE TABLE portfolio."enrollment" (
  "enrollment_id" bigint NOT NULL,
  "learner_id" bigint NOT NULL,
  "course_id" bigint NOT NULL,
  "enrolled_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "final_score" numeric(18,2),
  CONSTRAINT "pk_enrollment" PRIMARY KEY ("enrollment_id"),
  CONSTRAINT "uq_enrollment_0" UNIQUE ("learner_id", "course_id")
);
ALTER TABLE portfolio."enrollment" ADD CONSTRAINT "fk_enrollment_0" FOREIGN KEY ("learner_id") REFERENCES portfolio."learner" ("learner_id");
ALTER TABLE portfolio."enrollment" ADD CONSTRAINT "fk_enrollment_1" FOREIGN KEY ("course_id") REFERENCES portfolio."course" ("course_id");
ALTER TABLE portfolio."enrollment" ADD CONSTRAINT "enrollment_status_check" CHECK (("status" = 'enrolled') OR ("status" = 'completed') OR ("status" = 'withdrawn'));
ALTER TABLE portfolio."enrollment" ADD CONSTRAINT "enrollment_score_check" CHECK (("final_score" IS NULL) OR (("final_score" >= 0) AND ("final_score" <= 100)));
COMMIT;
