

CREATE DATABASE consultorio_sem;
GO
USE consultorio_sem;
GO


  --TABLAS
  
CREATE TABLE dbo.Pacientes (
  paciente_id      INT  NOT NULL PRIMARY KEY,
  nombre           NVARCHAR(100),
  apellido1        NVARCHAR(100),
  apellido2        NVARCHAR(100),
  fecha_nacimiento DATE,
  edad             INT,
  telefono         NVARCHAR(15)
);

CREATE TABLE dbo.Medicos (
  medico_id    INT           NOT NULL PRIMARY KEY,
  nombre       NVARCHAR(100),
  apellido1    NVARCHAR(100),
  apellido2    NVARCHAR(100),
  especialidad NVARCHAR(100),
  edad         INT,
  telefono     NVARCHAR(15)
);

CREATE TABLE dbo.Citas (
  cita_id      INT            NOT NULL PRIMARY KEY,
  paciente_id  INT            NOT NULL,
  medico_id    INT            NOT NULL,
  fecha_cita   DATETIME       NOT NULL,
  diagnostico  NVARCHAR(180),
  costo_cita   DECIMAL(10,2),
  categoria    NVARCHAR(10),
  CONSTRAINT FK_Citas_Pacientes FOREIGN KEY (paciente_id) REFERENCES dbo.Pacientes(paciente_id),
  CONSTRAINT FK_Citas_Medicos   FOREIGN KEY (medico_id)   REFERENCES dbo.Medicos(medico_id)
);

 


 Select * from dbo.Medicos
 select * from dbo.Citas
 select * from dbo.Pacientes

-- 10 pacientes (7 con citas y 3 SIN citas). Uno de los SIN citas también es médico.
INSERT INTO dbo.Pacientes (paciente_id, nombre, apellido1, apellido2, fecha_nacimiento, edad, telefono) VALUES
(1,  N'Juan',N'Pérez',N'García','1980-01-15',44,N'8555-1234'),
(2,  N'Ana',N'Martínez',N'Rodríguez','1992-06-25',32,N'8555-5678'),
(3,  N'Luis',N'Gómez',N'Hernández','1985-03-30',39, N'7555-9101'), 
(4,  N'María',N'Castro',N'Vázquez','1978-09-20',46, N'7555-1212'),
(5,  N'Carlos',N'López', N'Sánchez','1988-11-11',36, N'6555-1313'),
(6,  N'Laura',N'Mendoza',N'Jiménez','1995-12-05',28, N'6555-1414'), 
(7,  N'Pedro',N'Ruiz',N'García','1974-02-18', 51,N'8555-1515'),            
(8,  N'Sofía',N'Vargas',N'López','1979-07-09',45,N'8555-1616'),                 
(9,  N'Diego',N'Torres',N'Mora','1990-05-14',34,N'8455-1717'),
(10, N'Elena',N'Rojas',N'León', '1993-03-01',31,N'8355-1818');  

-- 5 médicos
INSERT INTO dbo.Medicos (medico_id, nombre, apellido1, apellido2, especialidad, edad, telefono) VALUES
(1, N'Pedro',N'Ruiz',N'García',N'Cardiología',50, N'8555-1515'),
(2, N'Sofía',N'Vargas',N'López',N'Pediatría',45, N'8555-1616'),
(3, N'Laura',N'Mendoza', N'Jiménez', N'Neurología',28,N'7555-1414'),
(4, N'Luis',N'Gómez',N'Hernández',N'Medicina General',39,N'7555-9101'),
(5, N'Andrea', N'Salas', N'Quesada',N'Dermatología',41,N'8355-1919');
GO

-- 10 citas (pacientes 1,2,3,4,5,6,9)
INSERT INTO dbo.Citas(cita_id, paciente_id, medico_id, fecha_cita, diagnostico, costo_cita, categoria) VALUES
(1,1, 1,'2024-09-20 10:00:00',N'Chequeo general',100.00,N'verde'),
(2,2,2,'2024-09-21 11:00:00',N'Control de crecimiento',150.00, N'amarillo'),
(3,3,1,'2024-09-22 09:00:00',N'Revisión de hipertensión',120.00, N'verde'),
(4,4,3,'2024-09-23 14:00:00',N'Dolor de cabeza persistente',130.00, N'rojo'),
(5,5,2,'2024-09-24 15:00:00',N'Chequeo anual',110.00,N'verde'),
(6,6,3,'2024-09-26 16:00:00',N'Evaluación neurológica',200.00, N'amarillo'),
(7,2,5,'2024-09-26 10:30:00',N'Chequeo de rutina',140.00,N'verde'),
(8,3,2,'2024-09-27 11:30:00',N'Consulta de seguimiento',160.00,N'amarillo'),
(9,9,3,'2024-09-28 12:00:00',N'Control de medicación',150.00,N'verde'),
(10,1,4,'2024-09-29 13:00:00',N'Dolor en el pecho',180.00,N'rojo');
GO

   ---CONSULTAS


-- 1) Pacientes con nombre que contenga 'a' y costo de cita > 150
SELECT DISTINCT p.*
FROM dbo.Pacientes p
JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
WHERE p.nombre LIKE N'%a%' AND c.costo_cita > 150;

-- 2) Paciente con el costo de cita más alto
SELECT TOP (1)
       p.paciente_id,
       p.nombre + N' ' + p.apellido1 AS paciente,
       c.costo_cita
FROM dbo.Citas c
JOIN dbo.Pacientes p ON p.paciente_id = c.paciente_id
ORDER BY c.costo_cita DESC;

-- 3) Médicos con edad entre 30 y 50 y nombre que empiece con 'L'
SELECT *
FROM dbo.Medicos
WHERE edad BETWEEN 30 AND 50
  AND nombre LIKE N'L%';

-- 4) Médico y promedio de costo (solo Cardiología)
SELECT m.medico_id,
       m.nombre + N' ' + m.apellido1 AS medico,
       AVG(c.costo_cita) AS promedio
FROM dbo.Medicos m
JOIN dbo.Citas c ON c.medico_id = m.medico_id
WHERE m.especialidad = N'Cardiología'
GROUP BY m.medico_id, m.nombre, m.apellido1;

-- 5) Cita con el costo más bajo + nombre del médico
SELECT TOP (1)
       c.cita_id, c.costo_cita,
       m.nombre + N' ' + m.apellido1 AS medico
FROM dbo.Citas c
JOIN dbo.Medicos m ON m.medico_id = c.medico_id
ORDER BY c.costo_cita ASC;

-- 6) Pacientes con citas entre 100 y 150 y nombre termine en 'a'
SELECT DISTINCT p.nombre + N' ' + p.apellido1 AS paciente
FROM dbo.Pacientes p
JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
WHERE c.costo_cita BETWEEN 100 AND 150
  AND p.nombre LIKE N'%a';

-- 7) Médicos con más de 2 citas (desc por # citas)
SELECT m.medico_id,
       m.nombre + N' ' + m.apellido1 AS medico,
       COUNT(*) AS total_citas
FROM dbo.Medicos m
JOIN dbo.Citas c ON c.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido1
HAVING COUNT(*) > 2
ORDER BY total_citas DESC;



-- 8) Médico con su # de citas, solo los que tienen más de 5
SELECT m.medico_id,
       m.nombre + N' ' + m.apellido1 AS medico,
       COUNT(*) AS total_citas
FROM dbo.Medicos m
JOIN dbo.Citas c ON c.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido1
HAVING COUNT(*) > 5;

-- 9) Total de citas por categoría
SELECT categoria, COUNT(*) AS total
FROM dbo.Citas
GROUP BY categoria;

-- 10) Costo promedio por categoría (solo categorías con más de 2 citas)
SELECT categoria, AVG(costo_cita) AS promedio, COUNT(*) AS total
FROM dbo.Citas
GROUP BY categoria
HAVING COUNT(*) > 2;







-- 11) TOP 3 pacientes que más ingresos generaron
SELECT TOP (3)
       p.paciente_id,
       p.nombre + N' ' + p.apellido1 AS paciente,
       SUM(c.costo_cita) AS ingresos
FROM dbo.Pacientes p
JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
GROUP BY p.paciente_id, p.nombre, p.apellido1
ORDER BY ingresos DESC;








-- 12) Fecha de cita más reciente por paciente
SELECT p.paciente_id,
       p.nombre + N' ' + p.apellido1 AS paciente,
       MAX(c.fecha_cita) AS ultima_cita
FROM dbo.Pacientes p
LEFT JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
GROUP BY p.paciente_id, p.nombre, p.apellido1;

-- 13) Nombres distintos de médicos y pacientes mayores de 30
SELECT DISTINCT nombre FROM dbo.Pacientes WHERE edad > 30
UNION
SELECT DISTINCT nombre FROM dbo.Medicos   WHERE edad > 30;







-- 14) Pacientes con citas cuyo costo > 100 (equivalente a > ANY (SELECT 100))
SELECT DISTINCT p.paciente_id,
       p.nombre + N' ' + p.apellido1 AS paciente
FROM dbo.Pacientes p
JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
WHERE c.costo_cita > 100;



-- 15) Pacientes con citas en el último año
SELECT DISTINCT p.paciente_id,
       p.nombre + N' ' + p.apellido1 AS paciente
FROM dbo.Pacientes p
JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
WHERE c.fecha_cita >= DATEADD(YEAR, -1, CAST(GETDATE() AS DATE));






-- 16) Pacientes con categoría 'rojo'
SELECT DISTINCT p.paciente_id,
       p.nombre + N' ' + p.apellido1 AS paciente
FROM dbo.Pacientes p
JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
WHERE c.categoria = N'rojo';







-- 17) Pacientes que están en Pacientes pero no en Citas
SELECT p.*
FROM dbo.Pacientes p
LEFT JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
WHERE c.paciente_id IS NULL;

-- 18) ¿Qué pacientes tienen nombres diferentes a los de los médicos?
SELECT DISTINCT p.nombre
FROM dbo.Pacientes p
WHERE p.nombre NOT IN (SELECT m.nombre FROM dbo.Medicos m);



-- 19) ¿Qué médicos no son pacientes?
SELECT DISTINCT m.nombre
FROM dbo.Medicos m
WHERE m.nombre NOT IN (SELECT p.nombre FROM dbo.Pacientes p);

-- 20) Médicos con mayor ingreso (maneja empates)


WITH ingresos AS (
  SELECT m.medico_id,
         m.nombre + N' ' + m.apellido1 AS medico,
         SUM(c.costo_cita) AS total_ingreso
  FROM dbo.Medicos m
  JOIN dbo.Citas c ON c.medico_id = m.medico_id
  GROUP BY m.medico_id, m.nombre, m.apellido1
)
SELECT *
FROM ingresos
WHERE total_ingreso = (SELECT MAX(total_ingreso) FROM ingresos);




-- 21) Pacientes atendidos por más de un médico diferente
SELECT p.paciente_id,
       p.nombre + N' ' + p.apellido1 AS paciente,
       COUNT(DISTINCT c.medico_id) AS medicos_distintos
FROM dbo.Pacientes p
JOIN dbo.Citas c ON c.paciente_id = p.paciente_id
GROUP BY p.paciente_id, p.nombre, p.apellido1
HAVING COUNT(DISTINCT c.medico_id) > 1;