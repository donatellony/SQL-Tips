BEGIN TRAN
-- Create a sample table with an IDENTITY column
CREATE TABLE Users
(
    Id      INT IDENTITY (1,1) PRIMARY KEY,
    Name    NVARCHAR(100),
    Company NVARCHAR(100)
);

BEGIN -- Filling data from the external system to be imported
    CREATE TABLE #ExternalUsers
    (
        ExternalId NVARCHAR(50),
        Name       NVARCHAR(100),
        Company    NVARCHAR(100)
    )

    INSERT INTO #ExternalUsers
        (ExternalId, Name, Company)
    VALUES
        ('EXT123', 'Alice', 'Example Corp. 1'      ),
        ('EXT456', 'Bob',   'Tasty Testing Corp. 2')
END

-- Temporary table to store the mappings
DECLARE @IdMapping TABLE
                   (
                       ExternalId NVARCHAR(50),
                       NewId      INT
                   );

-- Inserting new records while capturing IDs
MERGE INTO Users AS target
USING #ExternalUsers AS source
ON 1 = 0 -- Always false, so only INSERT occurs
WHEN NOT MATCHED THEN
    INSERT
        (Company, Name)
    VALUES
        (source.Company, source.Name)
    OUTPUT source.ExternalId, inserted.Id INTO @IdMapping;

-- See the mapping of ExternalId -> New IDENTITY values
SELECT * FROM @IdMapping;

ROLLBACK