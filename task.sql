CREATE TABLE task (
    id                               VARCHAR,
    ownerid                          VARCHAR,
    calldurationinseconds            NUMERIC(8,0),
    callobjectidentifier             VARCHAR(255),
    calldisposition                  VARCHAR(255),
    calltype                         VARCHAR,
    description                      VARCHAR(32000),
    completeddate                    TIMESTAMP,
    isrecurrence                     BOOLEAN,
    createdbyid                      VARCHAR,
    activitydate                     DATE,
    lastmodifiedbyid                 VARCHAR,
    whoid                            VARCHAR,
    name                             VARCHAR,
    priority                         VARCHAR,
    recurrenceinterval               NUMERIC(9,0),
    relatedtoid                      VARCHAR,
    isreminderset                    BOOLEAN,
    tasksubtype                      VARCHAR,
    subject                          VARCHAR
);


CREATE EXTERNAL TABLE spectrum.task (
    id                               STRING,
    ownerid                          STRING,
    calldurationinseconds            INT,
    callobjectidentifier             STRING,
    calldisposition                  STRING,
    calltype                         STRING,
    description                      STRING,
    completeddate                    TIMESTAMP,
    isrecurrence                     BOOLEAN,
    createdbyid                      STRING,
    activitydate                     DATE,
    lastmodifiedbyid                 STRING,
    whoid                            STRING,
    name                             STRING,
    priority                         STRING,
    recurrenceinterval               INT,
    relatedtoid                      STRING,
    isreminderset                    BOOLEAN,
    tasksubtype                      STRING,
    subject                          STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
    'serialization.format' = ',',
    'field.delim' = ','
)
STORED AS TEXTFILE
LOCATION 's3://'
TABLE PROPERTIES ('skip.header.line.count' = '1');