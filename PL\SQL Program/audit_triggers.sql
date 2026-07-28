CREATE OR REPLACE TRIGGER trg_audit_drugs
AFTER INSERT OR UPDATE OR DELETE
ON drugs
FOR EACH ROW
BEGIN

    INSERT INTO audit_log
    (
        audit_id,
        table_name,
        operation,
        record_id,
        old_value,
        new_value,
        changed_by,
        change_date
    )

    VALUES
    (
        audit_seq.NEXTVAL,

        'DRUGS',

        CASE
            WHEN INSERTING THEN 'INSERT'
            WHEN UPDATING THEN 'UPDATE'
            WHEN DELETING THEN 'DELETE'
        END,

        NVL(:NEW.drug_id,:OLD.drug_id),

        TO_CHAR(:OLD.drug_name),

        TO_CHAR(:NEW.drug_name),

        USER,

        SYSDATE
    );

END;
/
