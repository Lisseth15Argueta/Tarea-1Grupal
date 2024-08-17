/*Crear una consulta que permita determinar si un cliente puede recibir un descuento especial.
El total gastado por el cliente supera los $1000 debe mostrar que si es elegible sino mostrar que no lo es.
Debe mostrar las consultas: Nombre del cliente, Id del cliente y Eligibilidad. */

-- Consulta para determinar la elegibilidad de los clientes para un descuento
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, 
    CASE 
        WHEN SUM(b.TotalAmount) > 1000 THEN 'Elegible para descuento' -- Gastó más de $1000
        ELSE 'No elegible para descuento' -- Gastó $1000 o menos
    END AS Eligibilidad 
FROM 
    Customers c -- Tabla de clientes
INNER JOIN 
    Bookings b ON c.CustomerID = b.CustomerID -- Relaciona clientes con sus reservaciones
GROUP BY ---Agrupamos id cliente, nombre y la legibilidad cliente para el descuento
    c.CustomerID,
    c.FirstName,  
    c.LastName;  


