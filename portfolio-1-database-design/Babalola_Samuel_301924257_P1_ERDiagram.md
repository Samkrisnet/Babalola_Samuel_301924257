# Online Learning & LMS Platform — ER diagram

```mermaid
erDiagram
    direction LR
    learner {
        bigint learner_id PK
        text email UK
        timestamptz created_at
    }
    course {
        bigint course_id PK
        text course_code UK
        text title
        boolean published
        date start_date "Optional"
    }
    enrollment {
        bigint enrollment_id PK
        bigint learner_id FK
        bigint course_id FK
        timestamptz enrolled_at
        text status
        numeric final_score "Optional"
    }
    learner ||--o{ enrollment : "learner_id"
    course ||--o{ enrollment : "course_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Babalola_Samuel_301924257_ERDiagram.png)
