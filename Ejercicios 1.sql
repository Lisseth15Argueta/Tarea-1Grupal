-- 1. Cree un trigger que actualice el campo TotalAmount en la tabla
--Bookings cada vez que se cree una nueva reserva o se actualice una reserva existente.
--El importe total debe calcularse en función del precio de la habitación y la duración de la estancia.

CREATE TRIGGER tgr_UpdateTotalAmount
ON dbo.Bookings
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE b
	SET TotalAmount = DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate) * r.Rate
    FROM dbo.Bookings b
    INNER JOIN inserted i ON b.BookingID = i.BookingID
    INNER JOIN dbo.Rooms r ON b.RoomID = r.RoomID
END