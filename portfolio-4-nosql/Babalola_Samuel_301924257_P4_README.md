# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection learning_events for enrollment_created and lesson_started events. These are fictional event examples based on learner, course, enrollment.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related course details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "enrollment_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "enrollment",
        "key": {
            "enrollment_id": 301
        },
        "snapshot": {
            "enrollment_id": 301,
            "learner_id": 101,
            "course_id": 201,
            "enrolled_at": "2026-02-02T10:15:00Z",
            "status": "completed",
            "final_score": 92
        }
    },
    "embedded": {
        "course": [
            {
                "key": {
                    "course_id": 201
                },
                "snapshot": {
                    "course_id": 201,
                    "course_code": "LMS-101",
                    "title": "Foundations of Learning",
                    "published": true,
                    "start_date": "2026-02-01"
                },
                "via": [
                    "enrollment.course_id → course"
                ]
            }
        ]
    },
    "references": {
        "learner": [
            {
                "key": {
                    "learner_id": 101
                },
                "via": [
                    "enrollment.learner_id → learner"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("learning_events").find({"eventType":"enrollment_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "enrollment_id": 301
    }
  },
  {
    "_id": "event_000003",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "enrollment_id": 302
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("learning_events").find({"source.key.enrollment_id":301}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "enrollment_id": 301
    }
  },
  {
    "_id": "event_000002",
    "eventType": "lesson_started",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "enrollment_id": 301
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("learning_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "enrollment_id": 301
    }
  },
  {
    "_id": "event_000002",
    "eventType": "lesson_started",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "enrollment_id": 301
    }
  },
  {
    "_id": "event_000003",
    "eventType": "enrollment_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "enrollment_id": 302
    }
  },
  {
    "_id": "event_000004",
    "eventType": "lesson_started",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "enrollment_id": 302
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("learning_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| enrollment_created | 2 |
| lesson_started | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Babalola_Samuel_301924257_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Babalola_Samuel_301924257_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

