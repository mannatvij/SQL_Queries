CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentId INT;
    DECLARE @SubjectId VARCHAR(10);
    DECLARE @Preference INT;
    DECLARE @RemainingSeats INT;
    DECLARE @Found BIT;

    -- Cursor to fetch students ordered by GPA DESC
    DECLARE StudentCursor CURSOR FOR
        SELECT StudentId FROM StudentDetails ORDER BY GPA DESC;

    OPEN StudentCursor;
    FETCH NEXT FROM StudentCursor INTO @StudentId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Preference = 1;
        SET @Found = 0;

        WHILE @Preference <= 5 AND @Found = 0
        BEGIN
            SELECT @SubjectId = SubjectId 
            FROM StudentPreference 
            WHERE StudentId = @StudentId AND Preference = @Preference;

            IF @SubjectId IS NOT NULL
            BEGIN
                SELECT @RemainingSeats = RemainingSeats 
                FROM SubjectDetails 
                WHERE SubjectId = @SubjectId;

                IF @RemainingSeats > 0
                BEGIN
                    -- Allot subject
                    INSERT INTO Allotments (SubjectId, StudentId) 
                    VALUES (@SubjectId, @StudentId);

                    -- Decrement seat
                    UPDATE SubjectDetails 
                    SET RemainingSeats = RemainingSeats - 1 
                    WHERE SubjectId = @SubjectId;

                    SET @Found = 1;
                END
            END

            SET @Preference = @Preference + 1;
        END

        -- If not found, mark student as unallotted
        IF @Found = 0
        BEGIN
            INSERT INTO UnallotedStudents (StudentId) 
            VALUES (@StudentId);
        END

        FETCH NEXT FROM StudentCursor INTO @StudentId;
    END

    CLOSE StudentCursor;
    DEALLOCATE StudentCursor;
END;
