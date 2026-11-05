# Online Learning & LMS Platform — SQL queries

## 1. Show related enrollment, learner, course records (up to 20).

```sql
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
```

| enrollment_enrollment_id | enrollment_enrolled_at | learner_learner_id | learner_email | course_course_id | course_course_code |
| --- | --- | --- | --- | --- | --- |
| 301 | 2026-02-02T10:15:00+00:00 | 101 | learner.one@example.test | 201 | LMS-101 |
| 302 | 2026-02-03T11:00:00+00:00 | 102 | learner.two@example.test | 202 | LMS-202 |

## 2. Find course records where course_code matches "LMS-101" (up to 20).

```sql
SELECT * FROM portfolio."course"
WHERE "course_code" IS NOT DISTINCT FROM 'LMS-101'
ORDER BY "course_id"
LIMIT 20;
```

| course_id | course_code | title | published | start_date |
| --- | --- | --- | --- | --- |
| 201 | LMS-101 | Foundations of Learning | true | 2026-02-01 |

## 3. Count enrollment records for each learner_id (up to 20 groups).

```sql
SELECT "learner_id", count(*) AS record_count
FROM portfolio."enrollment"
GROUP BY "learner_id"
ORDER BY record_count DESC, "learner_id" NULLS LAST
LIMIT 20;
```

| learner_id | record_count |
| --- | --- |
| 101 | 1 |
| 102 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.485 | 1.486, 1.471, 1.485 | Sort → Seq Scan | 163 |
| After index | 0.232 | 0.272, 0.22, 0.232 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.485 ms to 0.232 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.46..1.462 rows=25 loops=1)
  Seq Scan on enrollment (actual time=0.022..1.424 rows=25 loops=1)
Planning Time: 0.392 ms
Execution Time: 1.486 ms
```

### Before index, run 2

```text
Sort (actual time=1.448..1.45 rows=25 loops=1)
  Seq Scan on enrollment (actual time=0.021..1.412 rows=25 loops=1)
Planning Time: 0.389 ms
Execution Time: 1.471 ms
```

### Before index, run 3

```text
Sort (actual time=1.444..1.446 rows=25 loops=1)
  Seq Scan on enrollment (actual time=0.022..1.406 rows=25 loops=1)
Planning Time: 0.408 ms
Execution Time: 1.485 ms
```

### After index, run 1

```text
Sort (actual time=0.211..0.214 rows=25 loops=1)
  Bitmap Heap Scan on enrollment (actual time=0.038..0.16 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.02..0.02 rows=25 loops=1)
Planning Time: 0.828 ms
Execution Time: 0.272 ms
```

### After index, run 2

```text
Sort (actual time=0.174..0.176 rows=25 loops=1)
  Bitmap Heap Scan on enrollment (actual time=0.031..0.133 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=25 loops=1)
Planning Time: 0.785 ms
Execution Time: 0.22 ms
```

### After index, run 3

```text
Sort (actual time=0.177..0.179 rows=25 loops=1)
  Bitmap Heap Scan on enrollment (actual time=0.031..0.134 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=25 loops=1)
Planning Time: 0.787 ms
Execution Time: 0.232 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Babalola_Samuel_301924257_P2_Queries.sql, then Babalola_Samuel_301924257_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Babalola_Samuel_301924257_P2_QueryResults.png) · [Index comparison](screenshots/Babalola_Samuel_301924257_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

