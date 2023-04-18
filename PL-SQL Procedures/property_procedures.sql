
-- procedure to add property record to table
create or replace procedure insertPropertyRecord(PROPERTYID in INTEGER,OWNER_ID in VARCHAR,FLOOR_COUNT in INTEGER,DOOR in VARCHAR,STREET in VARCHAR,CITY in VARCHAR,STATE_NAME in VARCHAR,PINCODE in VARCHAR,YEAR_OF_CONST in INTEGER,AVAIL_START_DATE in DATE,AVAIL_END_DATE in DATE,CURRENT_RENT_PM in INTEGER,LOCALITY in VARCHAR,ANNUAL_HIKE in FLOAT,isRented in INTEGER,TOTAL_AREA in INTEGER,PROPERTY_TYPE in VARCHAR) as begin
insert into PROPERTY values(PROPERTYID,OWNER_ID,FLOOR_COUNT,DOOR,STREET,CITY,STATE_NAME,PINCODE,YEAR_OF_CONST,AVAIL_START_DATE,AVAIL_END_DATE,CURRENT_RENT_PM,LOCALITY,ANNUAL_HIKE,isRented,TOTAL_AREA,PROPERTY_TYPE);
dbms_output.put_line('Property: '||PROPERTYID||' added to table');
end;
/

-- procedure to get property records for a given owner id
create or replace procedure getPropertyRecords(OWNER_ID in INTEGER) as begin
