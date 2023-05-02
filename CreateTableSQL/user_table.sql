CREATE TABLE users(
    AADHARID VARCHAR(50) PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    AGE INTEGER NOT NULL,
    EMAIL VARCHAR(100) NOT NULL,
    USER_PASSWORD VARCHAR(100) NOT NULL,
    DOOR VARCHAR(20),
    STREET VARCHAR(200),
    CITY VARCHAR(200),
    STATE_NAME VARCHAR(200),
    PINCODE VARCHAR(200),
    isDBA INTEGER NOT NULL,
    isManager INTEGER NOT NULL,
    isOwner INTEGER NOT NULL,
    isTenant INTEGER NOT NULL
);
