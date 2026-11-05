# Online Learning & LMS Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| learner_id | enrollment records (list) |
| --- | --- |
| 101 | [301] |
| 102 | [302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| enrollment.enrollment_id | enrollment.learner_id | enrollment.course_id | enrollment.status | learner.learner_id | learner.email | course.course_id | course.course_code |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | completed | 101 | learner.one@example.test | 201 | LMS-101 |
| 302 | 102 | 202 | enrolled | 102 | learner.two@example.test | 202 | LMS-202 |

Key: enrollment_id.

## 2NF: depend on the whole key

enrollment: learner_id is a proper part of candidate key (learner_id, course_id), and determines learner details. enrollment: course_id is a proper part of candidate key (learner_id, course_id), and determines course details.

## learner_example

| learner.learner_id | learner.email |
| --- | --- |
| 101 | learner.one@example.test |
| 102 | learner.two@example.test |

## course_example

| course.course_id | course.course_code |
| --- | --- |
| 201 | LMS-101 |
| 202 | LMS-202 |

## enrollment_example

| enrollment.enrollment_id | enrollment.learner_id | enrollment.course_id | enrollment.status |
| --- | --- | --- | --- |
| 301 | 101 | 201 | completed |
| 302 | 102 | 202 | enrolled |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## learner

| learner_id | email | created_at |
| --- | --- | --- |
| 101 | learner.one@example.test | 2026-01-10T09:00:00+00:00 |
| 102 | learner.two@example.test | 2026-01-11T09:30:00+00:00 |

## course

| course_id | course_code | title | published | start_date |
| --- | --- | --- | --- | --- |
| 201 | LMS-101 | Foundations of Learning | true | 2026-02-01 |
| 202 | LMS-202 | Applied Study Skills | false | NULL |

## enrollment

| enrollment_id | learner_id | course_id | enrolled_at | status | final_score |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026-02-02T10:15:00+00:00 | completed | 92 |
| 302 | 102 | 202 | 2026-02-03T11:00:00+00:00 | enrolled | NULL |

## Dependencies

- learner: (learner_id) → email, created_at
- course: (course_id) → course_code, title, published, start_date
- enrollment: (enrollment_id) → learner_id, course_id, enrolled_at, status, final_score

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
