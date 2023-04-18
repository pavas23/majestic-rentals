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