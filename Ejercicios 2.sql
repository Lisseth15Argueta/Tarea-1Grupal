--2. Crear un stored procedure para cancelar una reservación.
--El stored procedure debe cambiar el estado de la reservación
--a "cancelado" además debe verificar si existe la reservación antes 
--de cancelarla.

CREATE PROCEDURE CancelReservation
    @BookingID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la reservación existe
    IF EXISTS (SELECT 1 FROM dbo.Bookings WHERE BookingID = @BookingID)
    BEGIN
        -- Actualizar el estado de la reservación a "cancelado"
        UPDATE dbo.Bookings
        SET Status = 'cancelado'
        WHERE BookingID = @BookingID;

        PRINT 'Reservación cancelada exitosamente.';
    END
    ELSE
    BEGIN
        PRINT 'Error: La reservación no existe.';
    END
END