declare 
N integer := &enter_val;
v varchar(30) := &city_name;
BEGIN

SELECT isDBA INTO N FROM USERS WHERE users.NAME = 'Pavas Garg';
if N = 1 then

dbms_output.put_line('is dba');
end if;
end;
/
