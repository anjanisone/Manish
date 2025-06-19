create external schema sf_external
from data catalog
database 'bronze_db'
iam_role ''
create external database if not exists;

create external table sf_external.event (
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
    isprivate             BOOLEAN)
row format delimited
fields terminated by ','
stored as textfile
location 's3://manish-sup/bronze/'
TABLE PROPERTIES ('skip.header.line.count' = '1');
