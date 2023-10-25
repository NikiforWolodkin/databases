--CREATE TABLE project_stages (
--    id INT IDENTITY(1,1) PRIMARY KEY,
--    project_id INT NOT NULL,
--    start_date DATE NOT NULL,
--    end_date DATE NULL,
--    event_type INT NOT NULL,
--    previous_stage hierarchyid NULL,
--    description VARCHAR(200) NOT NULL,
--    FOREIGN KEY (project_id) REFERENCES projects(id),
--    FOREIGN KEY (event_type) REFERENCES project_event_types(id),
--);

SELECT 
    f.name AS ForeignKey,
    OBJECT_NAME(f.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName
FROM 
    sys.foreign_keys AS f
INNER JOIN 
    sys.foreign_key_columns AS fc 
       ON f.OBJECT_ID = fc.constraint_object_id
WHERE 
    OBJECT_NAME (f.referenced_object_id) = 'project_stages';



ALTER TABLE project_stages
DROP CONSTRAINT FK__project_s__previ__4BAC3F29;

ALTER TABLE project_stages
ADD previous_stage_hierarchy hierarchyid;

ALTER TABLE project_stages
DROP COLUMN previous_stage;

EXEC sp_rename 'project_stages.previous_stage_hierarchy', 'previous_stage', 'COLUMN';



DELETE FROM project_stages WHERE id != 1 AND id != 2
INSERT INTO project_stages(project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(2 ,1 ,hierarchyid::Parse('/1/1/'),'Project Beta development', '2023-10-15', '2023-11-15');
INSERT INTO project_stages(project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(2 ,1 ,hierarchyid::Parse('/1/2/'),'Project Beta refinement', '2023-10-15', '2024-05-15');
INSERT INTO project_stages(project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(2 ,1 ,hierarchyid::Parse('/1/1/1/'),'Project Beta testing', '2023-11-15', '2023-02-15');
INSERT INTO project_stages(project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(2 ,1 ,hierarchyid::Parse('/1/1/2/'),'Project Beta deployment', '2023-11-15', '2023-02-15');

SELECT id, project_id, description, previous_stage.ToString() FROM project_stages;

DROP PROCEDURE display_stage_subnodes;
GO
CREATE PROCEDURE display_stage_subnodes (@node hierarchyid)
AS
BEGIN
    SELECT 
        id,
        project_id,
        event_type,
        description,
        start_date,
        end_date,
        previous_stage.ToString() as node,
        previous_stage.GetLevel() as level
    FROM 
        project_stages
    WHERE 
        previous_stage.IsDescendantOf(@node) = 1
END;
GO

DECLARE @node hierarchyid
SET @node = hierarchyid::Parse('/1/')
EXEC display_stage_subnodes @node



DROP PROCEDURE add_stage_subnode;
GO
CREATE PROCEDURE add_stage_subnode (@parent_node hierarchyid, @project_id INT, @description VARCHAR(200), @event_type INT, @start_date DATE, @end_date DATE)
AS
BEGIN
    DECLARE @new_node hierarchyid

    -- Find the maximum child node under the parent
    SELECT @new_node = MAX(previous_stage)
    FROM project_stages
    WHERE previous_stage.GetAncestor(1) = @parent_node

    -- If there are no child nodes, start with the first child
    IF @new_node IS NULL 
        SET @new_node = @parent_node.GetDescendant(NULL, NULL)
    -- Otherwise, add the new node as the next sibling
    ELSE 
        SET @new_node = @parent_node.GetDescendant(@new_node, NULL)

    INSERT INTO project_stages (project_id, start_date, end_date, event_type, previous_stage, description)
    VALUES (@project_id, @start_date, @end_date, @event_type, @new_node, @description)
END;
GO

DECLARE @parent_node hierarchyid
SET @parent_node = hierarchyid::Parse('/1/1/2/')
EXEC add_stage_subnode @parent_node, 1, 'Project Beta finished', 1, '2023-06-15', '2023-06-15';

DECLARE @node hierarchyid
SET @node = hierarchyid::Parse('/1/')
EXEC display_stage_subnodes @node



DROP PROCEDURE move_stage_subtree;
GO
CREATE PROCEDURE move_stage_subtree
    @old_parent hierarchyid,
    @new_parent hierarchyid
AS
BEGIN
    DECLARE @old_parent_string nvarchar(max) = @old_parent.ToString();
    DECLARE @new_parent_string nvarchar(max) = @new_parent.ToString();

    UPDATE project_stages
    SET previous_stage = hierarchyid::Parse(
        replace(previous_stage.ToString(), @old_parent_string, @new_parent_string)
    )
    WHERE previous_stage.IsDescendantOf(@old_parent) = 1
    AND previous_stage <> @old_parent;
END;
GO

EXEC move_stage_subtree @old_parent = '/1/1/', @new_parent = '/1/2/';

DECLARE @node hierarchyid
SET @node = hierarchyid::Parse('/1/')
EXEC display_stage_subnodes @node