CREATE TABLE AUDIT(
   auditId INT NOT NULL,
   Date text
);

CREATE TRIGGER audit_log AFTER INSERT 
ON owners
BEGIN
    INSERT INTO AUDIT(auditId, date) VALUES (NEW.owner_id, datetime('now'));
END;

select * from AUDIT;