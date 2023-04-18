--Insert new user
create or replace procedure insertUser(aadharid in varchar2, name in varchar,age in integer,email in varchar,user_password in varchar,door in varchar,street in varchar,city in varchar,state_name in varchar,pincode in varchar) as begin 
insert into users values(aadharid,name,age,email,user_password,door,street,city,state_name,pincode,0,0,0,0);
end;
/


--insert manager
create or replace procedure insertManager(aadharid_dba in varchar,aadharid_manager in varchar2, name in varchar,age in integer,email in varchar,user_password in varchar,door in varchar,street in varchar,city in varchar,state_name in varchar,pincode in varchar) as
n integer;
begin
select isDBA into n from users where aadharid = aadharid_dba; --checks if aadharid_dba is actually dba
if n = 1 then
insert into users values(aadharid_manager,name,age,email,user_password,door,street,city,state_name,pincode,0,1,0,0);
else 
dbms_output.put_line('Only DBA is allowed to add managers');
end if;
end;
/

--delete manager
create or replace procedure deleteManager(aadharid_dba in varchar,aadharid_manager in varchar2) as
n integer;
m integer;
begin
select isDBA into n from users where aadharid = aadharid_dba;
select isManager into m from users where aadharid = aadharid_manager;
if n =1 and m =1 then 
delete from users where aadharid = aadharid_manager;
else
if n != 1 then
dbms_output.put_line('Only DBA is allowed to delete managers');
else 
dbms_output.put_line('User provided was not manager');
end if;
end if;
end;
/
-- delete user
create or replace procedure deleteManager(aadharid_dba in varchar,aadharid_user in varchar2) as
n integer;
begin
select isDBA into n from users where aadharid = aadharid_dba;
if n =1  then 
delete from users where aadharid = aadharid_user;
else
dbms_output.put_line('Only DBA is allowed to delete managers');
end if;
end;
/

--getTenantDetails
create or replace procedure getTenantDetails(PROP_ID IN INTEGER) AS
TID VARCHAR(200);
tenant_dets users%rowtype;
RENTED_FLAG INTEGER;
BEGIN
SELECT ISRENTED INTO RENTED_FLAG FROM PROPERTY WHERE PROPERTYID = PROP_ID;
IF RENTED_FLAG = 1 THEN
SELECT TENANTID INTO TID FROM TENANT_PROP_RENT WHERE RENT_PROPERTYID = PROP_ID AND END_DATE = (SELECT MAX(END_DATE) FROM TENANT_PROP_RENT);
select * into tenant_dets from users where aadharid = tid;
DBMS_OUTPUT.PUT_LINE('AadharID of Tenant: '|| tenant_dets.aadharid);
DBMS_OUTPUT.PUT_LINE('Name of Tenant: '|| tenant_dets.name);
DBMS_OUTPUT.PUT_LINE('age of Tenant: '|| tenant_dets.age);
DBMS_OUTPUT.PUT_LINE('Email of Tenant: '|| tenant_dets.email);
DBMS_OUTPUT.PUT_LINE('Address of Tenant: '|| tenant_dets.door||', '||tenant_dets.street||', '||tenant_dets.city||', '||tenant_dets.pincode||', '||tenant_dets.state_name);
ELSE
DBMS_OUTPUT.PUT_LINE('This property is currently not rented');
END IF;
end;
/








