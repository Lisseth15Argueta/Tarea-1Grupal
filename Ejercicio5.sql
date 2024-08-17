/*Crear un stored procedure que genere un reporte de los pagos de los clientes. 
Si el pago fue cubiero debe mostrar Pagado, si se pagó un adelante debe decir 
Parcialmente pagado y si aún se debe el pago completo debe ser
Pendiente de pago. Use case when para resolver el ejercicio.
*/

CREATE PROCEDURE sp_PaymentsReport
AS
BEGIN
    -- Seleccionamos los datos necesarios para el reporte
    SELECT 
        p.PaymentID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        p.BookingID,
        p.PaymentDate,
        p.Amount,
        -- Utilizamos CASE WHEN para determinar el estado del pago, si este esta pagado, parcialmente pagado o pendiente de pago
        CASE 
            WHEN p.Amount >= b.TotalAmount THEN 'Pagado'
            WHEN p.Amount > 0 AND p.Amount < b.TotalAmount THEN 'Parcialmente pagado'
            ELSE 'Pendiente de pago'
        END AS PaymentStatus
    FROM 
        Payments p
    INNER JOIN 
        Bookings b ON p.BookingID = b.BookingID
    INNER JOIN 
        Customers c ON b.CustomerID = c.CustomerID;
END;
GO
----Ejemplo de uso del procedimiento creamos

EXEC sp_PaymentsReport;

INSERT INTO Payments (BookingID, PaymentDate, Amount, PaymentMethod)
VALUES 
(1, '2024-08-01', 500.00, 'Credit Card'),
(2, '2024-08-05', 150.00, 'Cash'),
(2, '2024-08-10', 0.00, 'Cash');
