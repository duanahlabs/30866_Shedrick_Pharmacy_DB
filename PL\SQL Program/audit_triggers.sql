CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_audit_drugs
AFTER INSERT OR UPDATE OR DELETE ON drugs
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
BEGIN
    IF INSERTING THEN v_op := 'INSERT';
    ELSIF UPDATING THEN v_op := 'UPDATE';
    ELSE v_op := 'DELETE';
    END IF;

    INSERT INTO audit_log (
        audit_id, table_name, operation, record_id,
        old_value, new_value, changed_by, change_date
    ) VALUES (
        audit_seq.NEXTVAL, 'DRUGS', v_op,
        NVL(:NEW.drug_id, :OLD.drug_id),
        TO_CHAR(:OLD.drug_name), TO_CHAR(:NEW.drug_name),
        USER, SYSDATE
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_stock_batches
AFTER INSERT OR UPDATE OR DELETE ON stock_batches
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
BEGIN
    IF INSERTING THEN v_op := 'INSERT';
    ELSIF UPDATING THEN v_op := 'UPDATE';
    ELSE v_op := 'DELETE';
    END IF;

    INSERT INTO audit_log (
        audit_id, table_name, operation, record_id,
        old_value, new_value, changed_by, change_date
    ) VALUES (
        audit_seq.NEXTVAL, 'STOCK_BATCHES', v_op,
        NVL(:NEW.batch_id, :OLD.batch_id),
        TO_CHAR(:OLD.quantity_available), TO_CHAR(:NEW.quantity_available),
        USER, SYSDATE
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_dispensing
AFTER INSERT OR UPDATE OR DELETE ON dispensing
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
BEGIN
    IF INSERTING THEN v_op := 'INSERT';
    ELSIF UPDATING THEN v_op := 'UPDATE';
    ELSE v_op := 'DELETE';
    END IF;

    INSERT INTO audit_log (
        audit_id, table_name, operation, record_id,
        old_value, new_value, changed_by, change_date
    ) VALUES (
        audit_seq.NEXTVAL, 'DISPENSING', v_op,
        NVL(:NEW.dispensing_id, :OLD.dispensing_id),
        TO_CHAR(:OLD.quantity_dispensed), TO_CHAR(:NEW.quantity_dispensed),
        USER, SYSDATE
    );
END;
/
