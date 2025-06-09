CREATE TABLE event (
    id                    VARCHAR,
    isalldayevent         BOOLEAN,
    ownerid               VARCHAR,
    createdbyid           VARCHAR,
    activitydate          DATE,
    description           VARCHAR(32000),
    durationinminutes     NUMERIC(8,0),
    enddatetime           TIMESTAMP,
    eventsubtype          VARCHAR,
    lastmodifiedbyid      VARCHAR,
    location              VARCHAR(255),
    whoid                 VARCHAR,
    isreminderset         BOOLEAN,
    isrecurrence2         BOOLEAN,
    showas                VARCHAR,
    startdatetime         TIMESTAMP,
    subject               VARCHAR,
    activitydatetime      TIMESTAMP,
    type                  VARCHAR,
    isprivate             BOOLEAN
);



CREATE EXTERNAL TABLE spectrum.event (
    id                    STRING,
    isalldayevent         BOOLEAN,
    ownerid               STRING,
    createdbyid           STRING,
    activitydate          DATE,
    description           STRING,
    durationinminutes     INT,
    enddatetime           TIMESTAMP,
    eventsubtype          STRING,
    lastmodifiedbyid      STRING,
    location              STRING,
    whoid                 STRING,
    isreminderset         BOOLEAN,
    isrecurrence2         BOOLEAN,
    showas                STRING,
    startdatetime         TIMESTAMP,
    subject               STRING,
    activitydatetime      TIMESTAMP,
    type                  STRING,
    isprivate             BOOLEAN
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
    'serialization.format' = ',',
    'field.delim' = ','
)
STORED AS TEXTFILE
LOCATION 's3://'
TABLE PROPERTIES ('skip.header.line.count' = '1');