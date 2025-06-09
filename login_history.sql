-- External Table

CREATE EXTERNAL TABLE spectrum.login_history (
    id                      STRING,
    apitype                 STRING,
    apiversion              STRING,
    application             STRING,
    authmethodreference     STRING,
    authenticationserviceid STRING,
    browser                 STRING,
    ciphersuite             STRING,
    clientversion           STRING,
    countryiso              STRING,
    forwardedforisp         STRING,
    logingeoid              STRING,
    loginsubtype            STRING,
    logintime               TIMESTAMP,
    logintype               STRING,
    loginurl                STRING,
    optionsisget            BOOLEAN,
    optionsispost           BOOLEAN,
    platform                STRING,
    sourceip                STRING,
    status                  STRING,
    tlsprotocol             STRING,
    userid                  STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
    'serialization.format' = ',',
    'field.delim' = ','
)
STORED AS TEXTFILE
LOCATION 's3://'
TABLE PROPERTIES ('skip.header.line.count' = '1');


CREATE TABLE "Login_History" (
    Id                      VARCHAR,
    ApiType                 VARCHAR,
    ApiVersion              VARCHAR,
    Application             VARCHAR,
    AuthMethodReference     VARCHAR,
    AuthenticationServiceId VARCHAR,
    Browser                 VARCHAR,
    CipherSuite             VARCHAR,
    ClientVersion           VARCHAR,
    CountryIso              VARCHAR,
    ForwardedForIsp         VARCHAR,
    LoginGeoId              VARCHAR,
    LoginSubType            VARCHAR,
    LoginTime               TIMESTAMP,
    LoginType               VARCHAR,
    LoginUrl                VARCHAR,
    OptionsIsGet            BOOLEAN,
    OptionsIsPost           BOOLEAN,
    Platform                VARCHAR,
    SourceIp                VARCHAR,
    Status                  VARCHAR,
    TlsProtocol             VARCHAR,
    UserId                  VARCHAR
);