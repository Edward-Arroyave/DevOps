CREATE PROCEDURE CalculateNetSalary
    @EmployeeId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT e.EmployeeId, e.FullName, e.Salary,
           (e.Salary * 0.85) AS NetSalary
    FROM Employees e
    WHERE e.EmployeeId = @EmployeeId;
END;
