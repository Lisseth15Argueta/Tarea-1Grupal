/*Crear un stored procedure que genera un reporte de todas las reservaciones hechas en "x" mes. 
  Debe usar while. El reporte debe mostrar las siguientes columnas: Booking Id, Nombre del Cliente, 
  Room Id, Fecha Reservación, Fecha Check-In, Fecha Check-Out, Total y Status*/
  
  CREATE PROCEDURE sp_MonthlyBookingsReport
  ---Declaramos las variables
    @Year INT,
    @Month INT
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @TotalRecords INT;

    -- Creamos una tabla temporal para almacenar los resultados con los datos que se nos pide
    CREATE TABLE #BookingsReport (
        BookingID INT,
        CustomerName NVARCHAR(100),
        RoomID INT,
        BookingDate DATETIME,
        CheckInDate DATE,
        CheckOutDate DATE,
        TotalAmount DECIMAL(10, 2),
        Status NVARCHAR(20)
    );

    -- Insertar las reservaciones del mes en la tabla temporal
    INSERT INTO #BookingsReport (BookingID, CustomerName, RoomID, BookingDate, CheckInDate, CheckOutDate, TotalAmount, Status)
    SELECT 
        b.BookingID,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        b.RoomID,
        b.BookingDate,
        b.CheckInDate,
        b.CheckOutDate,
        b.TotalAmount,
        b.Status
    FROM 
        Bookings b
    INNER JOIN 
        Customers c ON b.CustomerID = c.CustomerID
    WHERE 
        YEAR(b.BookingDate) = @Year
        AND MONTH(b.BookingDate) = @Month;

    -- usamos count´para obtener el número total de registros en la tabla temporal
    SELECT @TotalRecords = COUNT(*) FROM #BookingsReport;

    -- Usamos WHILE para recorrer cada registro
    WHILE @Counter <= @TotalRecords
    BEGIN
        -- Mostramos el reporte para cada registro 
        SELECT *
        FROM #BookingsReport
        WHERE BookingID = (SELECT BookingID FROM #BookingsReport ORDER BY BookingID OFFSET @Counter - 1 ROWS FETCH NEXT 1 ROWS ONLY);
        
        SET @Counter = @Counter + 1;
    END

    -- Limpiamos la tabla temporal
    DROP TABLE #BookingsReport;
END;
GO

---Pueba de uso 
EXEC sp_MonthlyBookingsReport @Year = 2024, @Month = 7;

-- Agregar algunos clientes
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES 
('Lisseth', 'Benitez', 'lisseth.doe@example.com', '54789-1234', '123 Main St'),
('Fernanda', 'Romero', 'fer.smith@example.com', '834-5678', '456 Elm St');

-- Agregar algunas habitaciones
INSERT INTO Rooms (RoomName, RoomType, Capacity, Rate)
VALUES 
('Room 134', 'Single', 1, 100.00),
('Room 113', 'Single', 2, 150.00);

-- Agregar algunas reservaciones
INSERT INTO Bookings (CustomerID, RoomID, BookingDate, CheckInDate, CheckOutDate, TotalAmount, Status)
VALUES 
(1, 1, '2024-07-10', '2024-05-15', '2024-08-20', 500.00, 'Confirmed'),
(2, 2, '2024-07-12', '2024-06-18', '2024-07-22', 600.00, 'Confirmed');
