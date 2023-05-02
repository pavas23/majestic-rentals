--insert into residential TABLE
CREATE OR REPLACE PROCEDURE RES_INSERT(PROP_ID IN INTEGER,RES_TYPE IN VARCHAR,BEDROOM_COUNT IN INTEGER) AS
BEGIN
INSERT INTO RES_PROP VALUES(PROP_ID,BEDROOM_COUNT,RES_TYPE);  
END;
/
-- insert into commercial
CREATE OR REPLACE PROCEDURE COMM_INSERT(PROP_ID IN INTEGER,COM_TYPE IN VARCHAR) AS
BEGIN
INSERT INTO COM_PROP VALUES(PROP_ID,COM_TYPE);  
END;
/
-- INSERT NEW PROPERTY AND DESIGNATE USER AS OWNER
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

--DELETE PROPERTY BY USER
CREATE OR REPLACE PROCEDURE deletePropertyByUser(PROP_ID IN INTEGER,OW_ID IN VARCHAR) AS
PROPERTY_COUNT INTEGER;
BEGIN
SELECT COUNT(*) INTO PROPERTY_COUNT FROM PROPERTY WHERE OWNER_ID = OW_ID;
IF PROPERTY_COUNT > 0 THEN
DELETE FROM PROPERTY WHERE PROPERTYID = PROP_ID AND OWNER_ID = OW_ID;
PROPERTY_COUNT := PROPERTY_COUNT-1;
IF PROPERTY_COUNT = 0 THEN
UPDATE USERS SET ISOWNER = 0 WHERE AADHARID = OW_ID;
END IF;
ELSE 
DBMS_OUTPUT.PUT_LINE('YOU HAVE NO LISTED PROPERTIES');
END IF;
END;
/

--getUserProperty() {rename to getPropertyRecords(OID in varchar)}
CREATE OR REPLACE PROCEDURE getPropertyRecords(OID IN VARCHAR) AS
N INTEGER;
PROP_TYPE VARCHAR(200);
BEGIN
SELECT COUNT(*) INTO N FROM PROPERTY WHERE PROPERTY.OWNER_ID = OID;
IF N > 0 THEN 
FOR ITR IN (SELECT * FROM PROPERTY WHERE PROPERTY.OWNER_ID = OID)
LOOP
IF ITR.PROPERTY_TYPE = 'Residential' or ITR.PROPERTY_TYPE = 'RESIDENTIAL' OR ITR.PROPERTY_TYPE = 'residential' THEN
SELECT BEDROOM_COUNT,RES_TYPE INTO N,PROP_TYPE FROM RES_PROP WHERE RES_PROP.PROPERTYID = ITR.PROPERTYID;
ELSE
SELECT COM_TYPE INTO PROP_TYPE FROM COM_PROP WHERE COM_PROP.PROPERTYID = ITR.PROPERTYID;
END IF;
IF ITR.isRented = 1 AND CHECKRENTSTAT(ITR.PROPERTYID) THEN
DBMS_OUTPUT.PUT_LINE('PROPERTY ID: '||ITR.PROPERTYID|| ' (RENTED)');
ELSE 
DBMS_OUTPUT.PUT_LINE('PROPERTY ID: '||ITR.PROPERTYID|| ' (AVAILABLE)');
END IF;
DBMS_OUTPUT.PUT_LINE('ADDRESS: ' ||ITR.DOOR || ', '|| ITR.STREET||', ' ||ITR.LOCALITY ||', ' || ITR.CITY||', '||ITR.PINCODE||', ' ||ITR.STATE_NAME);
DBMS_OUTPUT.PUT_LINE('Year of Construction: '|| ITR.YEAR_OF_CONST);
DBMS_OUTPUT.PUT_LINE('Rent Per Month: '||ITR.CURRENT_RENT_PM);
DBMS_OUTPUT.PUT_LINE('Annual Hike: '||ITR.ANNUAL_HIKE);
DBMS_OUTPUT.PUT_LINE('Start Date: '||ITR.AVAIL_START_DATE || ' End Date: ' ||ITR.AVAIL_END_DATE);
DBMS_OUTPUT.PUT_LINE('Total Area: '||ITR.TOTAL_AREA);
DBMS_OUTPUT.PUT_LINE('Floor Count: '||ITR.FLOOR_COUNT);
IF ITR.PROPERTY_TYPE = 'Residential' or ITR.PROPERTY_TYPE = 'RESIDENTIAL' OR ITR.PROPERTY_TYPE = 'residential' THEN
DBMS_OUTPUT.PUT_LINE('Property Type: Residential');
DBMS_OUTPUT.PUT_LINE('No. Of bedrooms: '||N);
DBMS_OUTPUT.PUT_LINE('Residential Type: '||PROP_TYPE);
ELSE
DBMS_OUTPUT.PUT_LINE('Property Type: Commercial');
DBMS_OUTPUT.PUT_LINE('Commercial Type: '||PROP_TYPE);
end if;
DBMS_OUTPUT.PUT_LINE(chr(10)); -- CHR(10) is used to insert line breaks, CHR(9) is for tabs, and CHR(13) is for carriage returns.
END LOOP;
ELSE
DBMS_OUTPUT.PUT_LINE('You do not have any listed properties');
END IF;
end;
/

--RENT A PROPERTY
create or replace function checkDates(start_1 in date, end_1 in date,start_2 in date, end_2 in date) return BOOLEAN
IS
b boolean;
BEGIN
b :=  not (start_1 >= start_2 and start_1 <= end_2) and not (end_1 >= start_2 and end_1 <= end_2) and not (start_2 >= start_1 and start_2 <= end_1) and not (end_2 >= start_1 and end_2 <= end_1);
return b;
end;
/

CREATE OR REPLACE PROCEDURE rentProperty(USER_ID in VARCHAR,PROP_ID in INTEGER,START_DATE IN DATE,END_DATE IN DATE) AS
OID VARCHAR(50);
RENTED_FLAG INTEGER;
LAST_END_DATE DATE;
PROP_START_DATE DATE;
b boolean;
BEGIN
SELECT OWNER_ID INTO OID FROM PROPERTY WHERE PROPERTYID = PROP_ID;
IF OID = USER_ID THEN
DBMS_OUTPUT.PUT_LINE('Owner cant rent their own property');
ELSE
FOR date_rec in (select start_date,end_date from tenant_prop_rent where RENT_PROPERTYID = prop_id)
LOOP
b := checkDates(start_date,end_date,date_rec.start_date,date_rec.end_date);
end loop;
if b THEN
INSERT INTO TENANT_PROP_RENT VALUES(USER_ID,PROP_ID,START_DATE,END_DATE);
UPDATE PROPERTY SET ISRENTED = 1 WHERE PROPERTYID = PROP_ID;
DBMS_OUTPUT.PUT_LINE('Property successfully rented!');
ELSE
DBMS_OUTPUT.PUT_LINE('This property is unavailable during this period.');
end if;
END IF;
END;
/


-- Procedures to search for city, locality

CREATE OR REPLACE FUNCTION is_in_string (string_in IN VARCHAR2 ,substring_in   IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
  RETURN INSTR (string_in, substring_in) > 0;
END is_in_string;
/

CREATE OR REPLACE PROCEDURE searchPropertyforRent(location IN VARCHAR2) AS
N INTEGER;
PROP_TYPE VARCHAR(200);
BEGIN
FOR ITR IN (SELECT * FROM PROPERTY)
LOOP
IF is_in_string(LOWER(ITR.LOCALITY), LOWER(location)) OR is_in_string(LOWER(ITR.CITY), LOWER(location)) THEN
IF ITR.PROPERTY_TYPE = 'Residential' or ITR.PROPERTY_TYPE = 'RESIDENTIAL' OR ITR.PROPERTY_TYPE = 'residential' THEN
SELECT BEDROOM_COUNT,RES_TYPE INTO N,PROP_TYPE FROM RES_PROP WHERE RES_PROP.PROPERTYID = ITR.PROPERTYID;
ELSE
SELECT COM_TYPE INTO PROP_TYPE FROM COM_PROP WHERE COM_PROP.PROPERTYID = ITR.PROPERTYID;
END IF;
IF ITR.isRented = 1 AND CHECKRENTSTAT(ITR.PROPERTYID) THEN
DBMS_OUTPUT.PUT_LINE('PROPERTY ID: '||ITR.PROPERTYID|| ' (RENTED)');
ELSE 
DBMS_OUTPUT.PUT_LINE('PROPERTY ID: '||ITR.PROPERTYID|| ' (AVAILABLE)');
END IF;
DBMS_OUTPUT.PUT_LINE('ADDRESS: ' ||ITR.DOOR || ', '|| ITR.STREET||', ' ||ITR.LOCALITY ||', ' || ITR.CITY||', '||ITR.PINCODE||', ' ||ITR.STATE_NAME);
DBMS_OUTPUT.PUT_LINE('Year of Construction: '|| ITR.YEAR_OF_CONST);
DBMS_OUTPUT.PUT_LINE('Rent Per Month: '||ITR.CURRENT_RENT_PM);
DBMS_OUTPUT.PUT_LINE('Annual Hike: '||ITR.ANNUAL_HIKE);
DBMS_OUTPUT.PUT_LINE('Start Date: '||ITR.AVAIL_START_DATE || ' End Date: ' ||ITR.AVAIL_END_DATE);
DBMS_OUTPUT.PUT_LINE('Total Area: '||ITR.TOTAL_AREA);
DBMS_OUTPUT.PUT_LINE('Floor Count: '||ITR.FLOOR_COUNT);
IF ITR.PROPERTY_TYPE = 'Residential' or ITR.PROPERTY_TYPE = 'RESIDENTIAL' OR ITR.PROPERTY_TYPE = 'residential' THEN
DBMS_OUTPUT.PUT_LINE('Property Type: Residential');
DBMS_OUTPUT.PUT_LINE('No. Of bedrooms: '||N);
DBMS_OUTPUT.PUT_LINE('Residential Type: '||PROP_TYPE);
ELSE
DBMS_OUTPUT.PUT_LINE('Property Type: Commercial');
DBMS_OUTPUT.PUT_LINE('Commercial Type: '||PROP_TYPE);
end if;
DBMS_OUTPUT.PUT_LINE(chr(10));
END IF;
END LOOP;
END;
/


--Procedure to check for rented status
create or replace function checkRentStat(prop_id in integer) return boolean
IS
end_date_var date;
curr_date date;
BEGIN
select max(end_date) into end_date_var from TENANT_PROP_RENT where RENT_PROPERTYID = prop_id;
select SYSDATE into curr_date from dual;
if curr_date > end_date_var THEN
update property set isRented = 0 where propertyid = prop_id;
return FALSE;
ELSE
return TRUE;
end IF;
end;
/

CREATE OR REPLACE PROCEDURE rentStatus(PID in NUMBER) AS
    N INTEGER;
BEGIN
	SELECT COUNT(*) INTO N FROM PROPERTY WHERE PROPERTY.PROPERTYID = PID;
	IF N > 0 THEN 
		FOR ITR IN (SELECT * FROM PROPERTY WHERE PROPERTY.PROPERTYID = PID)
		LOOP
        	IF ITR.isRented = 1 THEN
                IF checkRentStat(PID) THEN
        		DBMS_OUTPUT.PUT_LINE('The Property ' || PID || ' has been rented to a customer');
                ELSE
                DBMS_OUTPUT.PUT_LINE('The Property ' || PID || ' is available for rent');
                END IF;
			ELSE
                DBMS_OUTPUT.PUT_LINE('The Property ' || PID || ' is available for rent');
			END IF;
        END LOOP;
	ELSE
        DBMS_OUTPUT.PUT_LINE('The Property ' || PID || ' does not exist');
	END IF;
END;
/

--tenant rent history
create or replace procedure getTenantRentHistory(uid in varchar) as
pid number;
initial date;
final date;
N number;
prop_type varchar(200);
comm float;
cursor rent_cursor is
select rent_propertyid,start_date,end_date from tenant_prop_rent where tenantid=uid;
begin
open rent_cursor;
loop
fetch rent_cursor into pid,initial,final;
exit when rent_cursor%notfound;
FOR ITR IN (SELECT * FROM PROPERTY WHERE PROPERTY.PROPERTYID = pid)
LOOP
IF ITR.PROPERTY_TYPE = 'Residential' or ITR.PROPERTY_TYPE = 'RESIDENTIAL' OR ITR.PROPERTY_TYPE = 'residential' THEN
SELECT BEDROOM_COUNT,RES_TYPE INTO N,PROP_TYPE FROM RES_PROP WHERE RES_PROP.PROPERTYID = ITR.PROPERTYID;
ELSE
SELECT COM_TYPE INTO PROP_TYPE FROM COM_PROP WHERE COM_PROP.PROPERTYID = ITR.PROPERTYID;
END IF;
IF ITR.isRented = 1 AND CHECKRENTSTAT(ITR.PROPERTYID) THEN
DBMS_OUTPUT.PUT_LINE('PROPERTY ID: '||ITR.PROPERTYID|| ' (RENTED)');
ELSE 
DBMS_OUTPUT.PUT_LINE('PROPERTY ID: '||ITR.PROPERTYID|| ' (AVAILABLE)');
END IF;
DBMS_OUTPUT.PUT_LINE('ADDRESS: ' ||ITR.DOOR || ', '|| ITR.STREET||', ' ||ITR.LOCALITY ||', ' || ITR.CITY||', '||ITR.PINCODE||', ' ||ITR.STATE_NAME);
DBMS_OUTPUT.PUT_LINE('Year of Construction: '|| ITR.YEAR_OF_CONST);
DBMS_OUTPUT.PUT_LINE('Rent Per Month: '||ITR.CURRENT_RENT_PM);
DBMS_OUTPUT.PUT_LINE('Annual Hike: '||ITR.ANNUAL_HIKE);
DBMS_OUTPUT.PUT_LINE('Property Available From: '||ITR.AVAIL_START_DATE || ' Till: ' ||ITR.AVAIL_END_DATE);
DBMS_OUTPUT.PUT_LINE('Total Area: '||ITR.TOTAL_AREA);
DBMS_OUTPUT.PUT_LINE('Floor Count: '||ITR.FLOOR_COUNT);
IF ITR.PROPERTY_TYPE = 'Residential' or ITR.PROPERTY_TYPE = 'RESIDENTIAL' OR ITR.PROPERTY_TYPE = 'residential' THEN
DBMS_OUTPUT.PUT_LINE('Property Type: Residential');
DBMS_OUTPUT.PUT_LINE('No. Of bedrooms: '||N);
DBMS_OUTPUT.PUT_LINE('Residential Type: '||PROP_TYPE);
ELSE
DBMS_OUTPUT.PUT_LINE('Property Type: Commercial');
DBMS_OUTPUT.PUT_LINE('Commercial Type: '||PROP_TYPE);
end if;
DBMS_OUTPUT.PUT_LINE('Start Date: '||initial);
DBMS_OUTPUT.PUT_LINE('End Date: '||final);
select agency_com into comm from property_rent where propertyid = pid;
DBMS_OUTPUT.PUT_LINE('Agency Commission: '||comm);
DBMS_OUTPUT.PUT_LINE(chr(10)); -- CHR(10) is used to insert line breaks, CHR(9) is for tabs, and CHR(13) is for carriage returns.
END LOOP;
end loop;
close rent_cursor;
end;
/

--property rent history
create or replace procedure getPropertyRentHistory(pid in int) as
uid varchar(50);
initial date;
final date;
tenant_dets users%rowtype;
contact_count int;
cursor prop_cursor is
select tenantid,start_date,end_date from tenant_prop_rent where RENT_PROPERTYID = pid and sysdate > start_date; 
begin
open prop_cursor;
loop
fetch prop_cursor into uid,initial,final;
exit when prop_cursor%notfound;
select * into tenant_dets from users where aadharid = uid;
DBMS_OUTPUT.PUT_LINE('AadharID of Tenant: '|| tenant_dets.aadharid);
DBMS_OUTPUT.PUT_LINE('Name of Tenant: '|| tenant_dets.name);
DBMS_OUTPUT.PUT_LINE('age of Tenant: '|| tenant_dets.age);
DBMS_OUTPUT.PUT_LINE('Email of Tenant: '|| tenant_dets.email);
DBMS_OUTPUT.PUT_LINE('Address of Tenant: '|| tenant_dets.door||', '||tenant_dets.street||', '||tenant_dets.city||', '||tenant_dets.pincode||', '||tenant_dets.state_name);
DBMS_OUTPUT.PUT_LINE('Start Date: '||initial);
DBMS_OUTPUT.PUT_LINE('End Date: '||final);
DBMS_OUTPUT.PUT_LINE('Contact Details of Tenant: ');
select count(*) into contact_count from user_contact_detail where AADHARID = uid;
if contact_count > 0 then
FOR itr in (select * from user_contact_detail where AADHARID = uid)
LOOP
DBMS_OUTPUT.PUT_LINE(itr.contact);
end loop;
ELSE
DBMS_OUTPUT.PUT_LINE('NO CONTACTS PROVIDED');
end if;
DBMS_OUTPUT.PUT_LINE(chr(10));
end loop;
close prop_cursor;
end;
/

CREATE OR REPLACE PROCEDURE showBookedDates(prop_id in integer) AS
BEGIN
DBMS_OUTPUT.put_line('Property is booked for the following dates: '||chr(10));
for date_rec in (select start_date,end_date from tenant_prop_rent where rent_propertyid = prop_id order by start_date,end_date asc)
LOOP
DBMS_OUTPUT.PUT_LINE(date_rec.start_date || ' to '||date_rec.end_date);
end loop;
end;
/

CREATE OR REPLACE PROCEDURE updateAgencyCom(prop_id integer,uid varchar,commission float) AS
dba_flag integer;
prop_flag integer;
manager_flag integer;
BEGIN
select isDBA into dba_flag from users where aadharid = uid;
select isManager into manager_flag from users where aadharid = uid;
if dba_flag = 1 or manager_flag = 1 then 
update property_rent set AGENCY_COM = commission where PROPERTYid = prop_id;
ELSE
dbms_output.put_line('Only managers and DBA are allowed to update commission');
end if;
end;
/


