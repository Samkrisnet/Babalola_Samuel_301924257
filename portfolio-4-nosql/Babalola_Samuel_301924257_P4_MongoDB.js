// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("learning_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("learning_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "enrollment_created",
                    "lesson_started"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "enrollment"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "enrollment_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("learning_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "lesson_started",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "lesson_id": "illustrative lesson_id",
                "quiz_score": "illustrative quiz_score",
                "device_type": "illustrative device_type",
                "duration_seconds": "illustrative duration_seconds"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "enrollment_created",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "enrollment",
            "key": {
                "enrollment_id": 302
            },
            "snapshot": {
                "enrollment_id": 302,
                "learner_id": 102,
                "course_id": 202,
                "enrolled_at": "2026-02-03T11:00:00+00:00",
                "status": "enrolled",
                "final_score": null
            }
        },
        "embedded": {
            "course": [
                {
                    "key": {
                        "course_id": 202
                    },
                    "snapshot": {
                        "course_id": 202,
                        "course_code": "LMS-202",
                        "title": "Applied Study Skills",
                        "published": false,
                        "start_date": null
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
                        "learner_id": 102
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "lesson_started",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "enrollment",
            "key": {
                "enrollment_id": 302
            },
            "snapshot": {
                "enrollment_id": 302,
                "learner_id": 102,
                "course_id": 202,
                "enrolled_at": "2026-02-03T11:00:00+00:00",
                "status": "enrolled",
                "final_score": null
            }
        },
        "embedded": {
            "course": [
                {
                    "key": {
                        "course_id": 202
                    },
                    "snapshot": {
                        "course_id": 202,
                        "course_code": "LMS-202",
                        "title": "Applied Study Skills",
                        "published": false,
                        "start_date": null
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
                        "learner_id": 102
                    },
                    "via": [
                        "enrollment.learner_id → learner"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "lesson_id": "illustrative lesson_id",
                "quiz_score": "illustrative quiz_score",
                "device_type": "illustrative device_type",
                "duration_seconds": "illustrative duration_seconds"
            }
        }
    }
]));
  await db.getCollection("learning_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("learning_events").find({"eventType":"enrollment_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("learning_events").find({"source.key.enrollment_id":301}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("learning_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("learning_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("learning_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("learning_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("learning_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
