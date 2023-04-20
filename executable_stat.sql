--INSERT PROPERTY;
exec insertProperty(270603, '4897-9155-4284', 2, '205-A', 'Scheme-113', 'Vadodara', 'Gujurat', '300018', 1995, '13-JAN-23', '13-JAN-24', 10000, 'Vijay Nagar', 5.0, 5000, 'Residential', 'Villa',null,3);
exec insertProperty(280603, '4897-9155-4284', 2, '205-B', 'Scheme-113', 'Vadodara', 'Gujurat', '300018', 1995, '13-JAN-23', '14-JUN-23', 12000, 'Vijay Nagar', 5.0, 5500, 'Residential','Villa',null,4);
exec insertProperty(270703, '4897-9155-4284', 2, '205-C', 'Scheme-113', 'Vadodara', 'Gujurat', '300018', 1995, '13-JAN-23', '15-JAN-27', 8000, 'Vijay Nagar', 5.0, 4500, 'Residential', 'Villa',null,3);
exec insertProperty(270604, '4897-9155-4284', 2, '205-D', 'Scheme-113', 'Vadodara', 'Gujurat', '300018', 1995, '13-JAN-23', '16-MAY-24', 15000, 'Vijay Nagar', 5.0, 6500, 'Residential', 'Villa',null,5);
exec insertProperty(370603, '4897-9155-4284', 2, '205-E', 'Scheme-113', 'Vadodara', 'Gujurat', '300018', 1995, '13-JAN-23', '17-JAN-25', 7500, 'Vijay Nagar', 5.0, 4000, 'Residential', 'Villa',null,3);
exec insertProperty(270803, '3042-1644-6808', 1, '311', 'GD Road', 'Srinagar', 'Kashmir', '190001', 2005, '26-JUL-23', '26-JUL-30', 10000, 'Gandhi Nagar', 7.0, 1500, 'Residential', 'Flat',null,3);
exec insertProperty(280804, '3042-1644-6808', 1, '211', 'GD Road', 'Srinagar', 'Kashmir', '190001', 2005, '26-JUL-23', '26-JUL-30', 10000, 'Gandhi Nagar', 7.0, 1500, 'Residential', 'Flat',null,3);
exec insertProperty(270809, '3042-1644-6808', 1, '111', 'GD Road', 'Srinagar', 'Kashmir', '190001', 2005, '26-JUL-23', '26-JUL-30', 10000, 'Gandhi Nagar', 7.0, 1500, 'Residential', 'Flat',null,3);
exec insertProperty(192845, '5154-8124-2429', 3, '102-A', 'Grafton Street', 'Mumbai', 'Maharashtra', '400001', 1895, '27-SEP-23', '26-SEP-24', 70000, 'Narayan Nagar', 10.0, 7000, 'Residential', 'Villa',null,6);
exec insertProperty(197346, '5154-8124-2429', 3, '102-B', 'Grafton Street', 'Mumbai', 'Maharashtra', '400001', 1895, '27-SEP-23', '26-SEP-24', 70000, 'Narayan Nagar', 10.0, 7000, 'Residential', 'Villa',null,6);
exec insertProperty(247687, '5114-8817-7684', 1, '232', 'BK Road', 'Itanagar', 'Arunachal Pradesh', '791111', 2008, '21-FEB-23', '21-FEB-26', 12000, 'Sabhya Nagar', 3.0, 2500, 'Residential', 'Flat',null,4);
exec insertProperty(234868, '5114-8817-7684', 1, '222', 'BK Road', 'Itanagar', 'Arunachal Pradesh', '791111', 2008, '21-FEB-23', '21-FEB-26', 12000, 'Sabhya Nagar', 3.0, 2500, 'Residential', 'Flat',null,4);
exec insertProperty(298987, '5114-8817-7684', 1, '212', 'BK Road', 'Itanagar', 'Arunachal Pradesh', '791111', 2008, '21-FEB-23', '21-FEB-26', 12000, 'Sabhya Nagar', 3.0, 2500, 'Residential', 'Flat',null,4);
exec insertProperty(274843, '9711-1712-1294', 7, 'Building 1', 'Reech Road', 'Delhi', 'Delhi', '110021', 2015, '23-MAR-22', '23-MAR-42', 10000000, 'Lajpat Nagar', 1.0, 150000,'Commercial',null, 'Office Building',0);
exec insertProperty(286603, '9711-1712-1294', 7, 'Building 2', 'Reech Road', 'Delhi', 'Delhi', '110021', 2015, '23-MAR-22', '23-MAR-42', 10000000, 'Lajpat Nagar', 1.0, 150000, 'Commercial',null, 'Office Building',0);

-- RENT PROPERTY TEST;
 EXEC RENTPROPERTY('5678-9101-1234',270603,'13-DEC-23','12-JUL-23'); --SUCCESS
 EXEC RENTPROPERTY('8425-5438-2750',270603,'13-NOV-23','12-JUN-23'); -- PROPERTY ALREADY RENTED
 EXEC RENTPROPERTY('4897-9155-4284',270603,'13-NOV-23','12-JUN-24'); --OWNER CANT RENT THEIR PROPERTY