create or replace procedure insertPropertyRecord(PROP_ID IN INTEGER,OWNER_ID IN VARCHAR,FLOOR_COUNT IN INTEGER, DOOR IN VARCHAR,STREET IN VARCHAR,CITY IN VARCHAR,STATE_NAME IN VARCHAR,PINCODE IN VARCHAR,YEAR_OF_CONST IN INTEGER,AVAIL_START_DATE IN DATE,AVAIL_END_DATE IN DATE,CURRENT_RENT_PM IN INTEGER,LOCALITY IN VARCHAR,ANNUAL_HIKE IN FLOAT,TOTAL_AREA IN INTEGER,PROP_TYPE IN VARCHAR,RES_TYPE IN VARCHAR DEFAULT NULL,COM_TYPE IN VARCHAR DEFAULT NULL,BEDROOM_COUNT IN INTEGER DEFAULT 0) AS
BEGIN
INSERT INTO PROPERTY VALUES(PROP_ID,OWNER_ID,FLOOR_COUNT,DOOR,STREET,CITY,STATE_NAME,PINCODE,YEAR_OF_CONST,AVAIL_START_DATE,AVAIL_END_DATE,CURRENT_RENT_PM,LOCALITY,0,TOTAL_AREA,PROP_TYPE,ANNUAL_HIKE);
UPDATE USERS SET ISOWNER = 1 WHERE AADHARID = OWNER_ID;
IF PROP_TYPE = 'Residential' or PROP_TYPE = 'RESIDENTIAL' OR PROP_TYPE = 'residential' THEN
RES_INSERT(PROP_ID,RES_TYPE,BEDROOM_COUNT);
ELSIF PROP_TYPE = 'COMMERCIAL' or PROP_TYPE = 'commercial' OR PROP_TYPE = 'Commercial' THEN
COMM_INSERT(PROP_ID,COM_TYPE);
ELSE
DBMS_OUTPUT.PUT_LINE('PROPERTY TYPE INVALID!');
END IF;
insert into PROPERTY_RENT(propertyid,rent_pm,annual_hike) values (prop_id,CURRENT_RENT_PM,annual_hike);
END;
/