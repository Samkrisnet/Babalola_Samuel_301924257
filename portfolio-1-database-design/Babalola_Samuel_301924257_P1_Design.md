# Online Learning & LMS Platform — database design

My case study records learner, course, enrollment.

## Users

- Learners enrolling in courses and participating in lessons.
- Instructors and administrators managing course offerings and reviewing participation.

## Main operations

- Create and manage learner and course records.
- Enroll learners in courses and track enrollment status and scores.
- Review enrollment details and summarize participation by course.

## Entities

| Entity | Information stored |
| --- | --- |
| learner | Stores a learner account and its contact address. |
| course | Stores a course offering and its publication details. |
| enrollment | Links one learner to one course and stores enrollment-specific progress. |

## learner

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| learner_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## course

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| course_id | BIGINT | PK | Yes |
| course_code | TEXT | Unique | Yes |
| title | TEXT |  | Yes |
| published | BOOLEAN |  | Yes |
| start_date | DATE |  | No |
- Unique key: (course_code).

## enrollment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| enrollment_id | BIGINT | PK | Yes |
| learner_id | BIGINT | FK | Yes |
| course_id | BIGINT | FK | Yes |
| enrolled_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| final_score | NUMERIC(18,2) |  | No |
- learner_id → learner.learner_id
- course_id → course.course_id
- Unique key: (learner_id, course_id).

## Relationships and business rules

- Each learner account must have a distinct email address.
- Each course offering must have a distinct course code.
- Every enrollment must reference an existing learner through learner_id.
- Every enrollment must reference an existing course through course_id.
- A learner may have at most one enrollment record for a given course.
- Enrollment status must be enrolled, completed, or withdrawn.
- A recorded final score must be between zero and one hundred, inclusive.

## Assumptions

- Use only fabricated data and generated UUIDs; do not use real student names, IDs, or contact details.
- For a worked normalization example, begin with an enrollment worksheet containing learner email, course title, enrollment status, enrollment date, and score. Use enrollment as the root record referencing each distinct parent once; keep learner email in learner, course title in course, and enrollment-specific attributes in enrollment.
- Separate benchmark plan: load 25,000 synthetic enrollment rows, compare filtering by status before and after adding the specified B-tree index, and record query plans and measurements without assuming an outcome.

