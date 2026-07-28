
CREATE TABLE user_activity (
    activity_id NUMBER PRIMARY KEY,
    username    VARCHAR2(50),
    login_time  DATE
);
 
CREATE SEQUENCE activity_seq START WITH 1 INCREMENT BY 1;
 
CREATE OR REPLACE TRIGGER trg_logon
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO user_activity VALUES (activity_seq.NEXTVAL, USER, SYSDATE);
END;
/
