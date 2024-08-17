--3. Crear un stored procedure para crear una nueva reservación.
--El store procedure debe verificar si existe una habitación disponible para la fecha deseada

CREATE PROCEDURE CreateReservation
    @CustomerID INT,
    @RoomID INT,
    @BookingDate DATETIME,
    @CheckInDate DATE,
    @CheckOutDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la habitación está disponible
    IF NOT EXISTS (
        SELECT 1 
        FROM dbo.Bookings 
        WHERE RoomID = @RoomID 
        AND (
            (@CheckInDate < CheckOutDate AND @CheckOutDate > CheckInDate)
        )
    )
    BEGIN
        -- Insertar la nueva reservación
        INSERT INTO dbo.Bookings (CustomerID, RoomID, BookingDate, CheckInDate, CheckOutDate, TotalAmount, Status)
        VALUES (@CustomerID, @RoomID, @BookingDate, @CheckInDate, @CheckOutDate, 0, 'reservado');

        PRINT 'Reservación creada exitosamente.';
    END
    ELSE
    BEGIN
        PRINT 'Error: La habitación no está disponible para las fechas seleccionadas.';
    END
END