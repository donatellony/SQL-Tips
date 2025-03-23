BEGIN TRAN

CREATE TABLE Fibonacci(Value INT NOT NULL)
CREATE TABLE NumSequence(Value INT NOT NULL)

INSERT INTO Fibonacci (Value) VALUES (1), (1), (2), (3), (5);
INSERT INTO NumSequence (Value) VALUES (1), (2), (3), (4), (5);

-- Example #1 (ONE OF THE BEST ONES!)
-- Combines both tables and returns distinct rows only
-- 1, 2, 3, 4, 5
SELECT Value FROM Fibonacci
UNION
SELECT Value FROM NumSequence
ORDER BY Value

-- Example #2 (ONE OF THE BEST ONES!)
-- Combines both tables and returns all the rows
-- 1, 1, 1, 2, 2, 3, 3, 4, 5, 5
SELECT Value FROM Fibonacci
UNION ALL
SELECT Value FROM NumSequence
ORDER BY Value

-- Example #3 (ONE OF THE BEST ONES!)
-- Does the same thing as the Example #1
-- 1, 2, 3, 4, 5
SELECT DISTINCT Value
FROM (SELECT Value FROM Fibonacci
      UNION ALL
      SELECT Value FROM NumSequence
     ) union_all
ORDER BY Value

-- Example #4 (DIFFERENT FROM THE OTHERS)
-- Combines distinct rows from both tables,
-- but does not make this combination distinct
-- (NOT the same, as Examples #1 and #3!)
-- 1, 1, 2, 2, 3, 3, 4, 5, 5
SELECT DISTINCT Value FROM Fibonacci
UNION ALL
SELECT DISTINCT Value FROM NumSequence
ORDER BY Value

-- Example #5 (ONE OF THE WORST ONES!)
-- Combines distinct rows from both tables... And makes them distinct
-- Result is the same as in Examples #1 and #3, but it is not optimal
-- 1, 2, 3, 4, 5
SELECT DISTINCT Value FROM Fibonacci
UNION
SELECT DISTINCT Value FROM NumSequence
ORDER BY Value

-- Example #6 (ONE OF THE WORST ONES!)
-- Combines both tables and returns distinct rows only... And makes them distinct
-- Result is the same as in Examples #1 and #3, but it is not optimal
-- 1, 2, 3, 4, 5
SELECT DISTINCT Value
FROM (SELECT Value FROM Fibonacci
      UNION
      SELECT Value FROM NumSequence
     ) union_all
ORDER BY Value

/* To decide which ones are the GOAT,
   Let's imagine that we've got another table to UNION with.
   (I'll just reuse NumSequence in this example) ;)
*/

-- Example #7 (THE GOAT)
-- Both of these share exactly the same execution plan
-- These are the best options if you want to get distinct values from all the sets
SELECT Value FROM Fibonacci
UNION
SELECT Value FROM NumSequence AS FirstSequence
UNION
SELECT Value FROM NumSequence AS AnotherSequence
ORDER BY Value

SELECT DISTINCT Value
FROM (SELECT Value FROM Fibonacci
      UNION ALL
      SELECT Value FROM NumSequence AS FirstSequence
	  UNION ALL
      SELECT Value FROM NumSequence AS AnotherSequence
     ) union_all
ORDER BY Value

-- Example #8 (THE GOAT)
-- This is the best option if you want to get all the values from all the sets
SELECT Value FROM Fibonacci
UNION ALL
SELECT Value FROM NumSequence AS FirstSequence
UNION ALL
SELECT Value FROM NumSequence AS AnotherSequence
ORDER BY Value

ROLLBACK