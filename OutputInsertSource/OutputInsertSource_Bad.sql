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
INSERT INTO Users
    (Company, Name)
OUTPUT eu.ExternalId, -- ERROR: The multi-part identifier "eu.ExternalId" could not be bound.
       inserted.Id INTO @IdMapping
SELECT Company, Name
FROM #ExternalUsers eu

-- See the mapping of ExternalId -> New IDENTITY values. (Is not possible in this script!)
SELECT * FROM @IdMapping;

-- Please, run this ROLLBACK manually after an ERROR, because the transaction is still active!
ROLLBACK