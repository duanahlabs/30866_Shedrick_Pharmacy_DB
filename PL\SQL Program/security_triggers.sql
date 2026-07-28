CREATE OR REPLACE TRIGGER trg_weekday_block

BEFORE INSERT OR UPDATE OR DELETE

ON drugs

BEGIN

    IF TO_CHAR(
        SYSDATE,
        'DY',
        'NLS_DATE_LANGUAGE=ENGLISH'
    )
    IN ('MON','TUE','WED','THU','FRI')

    THEN

        RAISE_APPLICATION_ERROR(
            -20010,
            'Database modifications are prohibited Monday-Friday.'
        );

    END IF;

END;
/

CREATE OR REPLACE TRIGGER trg_public_holiday

BEFORE INSERT OR UPDATE OR DELETE

ON drugs

DECLARE

    v_count NUMBER;

BEGIN

    SELECT COUNT(*)
    INTO v_count
    FROM public_holidays
    WHERE holiday_date = TRUNC(SYSDATE);

    IF v_count > 0 THEN

        RAISE_APPLICATION_ERROR(
            -20020,
            'Database modifications are not allowed on public holidays.'
        );

    END IF;

END;
/
