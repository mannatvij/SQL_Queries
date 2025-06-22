CREATE TABLE SubjectAllotments (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Is_valid BIT
);
CREATE TABLE SubjectRequest (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20)
);
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

-- New request
INSERT INTO SubjectRequest (StudentId, SubjectId) VALUES
('159103036', 'PO1496');

-- Step 1: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS UpdateSubjectAllotments;
GO

-- Step 2: Re-create the procedure
CREATE PROCEDURE UpdateSubjectAllotments
AS
BEGIN
    DECLARE @StudentId VARCHAR(20);
    DECLARE @SubjectId VARCHAR(20);
    DECLARE @CurrentValidSubject VARCHAR(20);

    DECLARE request_cursor CURSOR FOR
        SELECT StudentId, SubjectId FROM SubjectRequest;

    OPEN request_cursor;

    FETCH NEXT FROM request_cursor INTO @StudentId, @SubjectId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT TOP 1 @CurrentValidSubject = SubjectId
        FROM SubjectAllotments
        WHERE StudentId = @StudentId AND Is_valid = 1;

        IF EXISTS (
            SELECT 1 FROM SubjectAllotments
            WHERE StudentId = @StudentId AND SubjectId = @SubjectId
        )
        BEGIN
            IF @SubjectId != @CurrentValidSubject
            BEGIN
                UPDATE SubjectAllotments
                SET Is_valid = 0
                WHERE StudentId = @StudentId AND SubjectId = @CurrentValidSubject;

                UPDATE SubjectAllotments
                SET Is_valid = 1
                WHERE StudentId = @StudentId AND SubjectId = @SubjectId;
            END
        END
        ELSE
        BEGIN
            UPDATE SubjectAllotments
            SET Is_valid = 0
            WHERE StudentId = @StudentId AND Is_valid = 1;

            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
            VALUES (@StudentId, @SubjectId, 1);
        END

        FETCH NEXT FROM request_cursor INTO @StudentId, @SubjectId;
    END

    CLOSE request_cursor;
    DEALLOCATE request_cursor;

    -- Optional: cleanup
    DELETE FROM SubjectRequest;
END;
GO


EXEC UpdateSubjectAllotments;
