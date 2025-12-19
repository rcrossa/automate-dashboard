-- =============================================
-- SCRIPT DE ACTUALIZACIÓN: Agregar columna CUIT
-- =============================================
-- Este script agrega la columna 'cuit' a la tabla clientes
-- Ejecutar si ya creaste la BD sin esta columna

-- Verificar si la columna ya existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'clientes' 
        AND column_name = 'cuit'
    ) THEN
        -- Agregar columna cuit
        ALTER TABLE clientes 
        ADD COLUMN cuit text;
        
        RAISE NOTICE 'Columna cuit agregada exitosamente a la tabla clientes';
    ELSE
        RAISE NOTICE 'La columna cuit ya existe en la tabla clientes';
    END IF;
END $$;

-- Verificación
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'clientes' 
AND column_name = 'cuit';
