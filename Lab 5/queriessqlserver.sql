SELECT [geom].STSrid AS SRID
FROM [dbo].[offices]
WHERE [qgs_fid] = 1;

SELECT [unit_of_measure]
FROM sys.spatial_reference_systems
WHERE [spatial_reference_id] = 4326;



DECLARE @point GEOMETRY;
SET @point = GEOMETRY::STPointFromText('POINT (10 10)', 4326);

SELECT o.[qgs_fid], o.[id]
FROM [dbo].[offices] o
WHERE @point.STBuffer(40).STIntersects(o.[geom]) = 1;



DECLARE @office1 GEOMETRY;
DECLARE @office2 GEOMETRY;

SET @office1 = (SELECT [geom] FROM [dbo].[offices] WHERE id = 1);
SET @office2 = (SELECT [geom] FROM [dbo].[offices] WHERE id = 2);

SELECT @office1.STDistance(@office2) AS Distance;



SELECT m.[id] AS map_object_id
FROM [dbo].[map] m
WHERE EXISTS (
    SELECT 1
    FROM [dbo].[offices] o
    WHERE m.[geom].STIntersects(o.[geom]) = 1
    AND o.[id] = 1
);
