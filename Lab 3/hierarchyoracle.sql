SELECT * FROM project_stages;

INSERT INTO project_stages(id, project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(6 ,2 ,1 ,5 ,'Project Beta development', date '2023-10-15', date '2023-11-15');
INSERT INTO project_stages(id, project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(7 ,2 ,1 ,5 ,'Project Beta refinement', date '2023-10-15', date '2024-05-15');
INSERT INTO project_stages(id, project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(8 ,2 ,1 ,6 ,'Project Beta testing', date '2023-11-15', date '2023-02-15');
INSERT INTO project_stages(id, project_id ,event_type ,previous_stage ,description, start_date, end_date)VALUES 
(9 ,2 ,1 ,8 ,'Project Beta deployment', date '2023-11-15', date '2023-02-15');



CREATE TYPE project_stage_type AS OBJECT (
    id NUMBER,
    project_id NUMBER,
    event_type NUMBER,
    description VARCHAR2(200),
    start_date DATE,
    end_date DATE,
    previous_stage NUMBER,
    node_level NUMBER
);

CREATE TYPE project_stage_table_type AS TABLE OF project_stage_type;

CREATE OR REPLACE FUNCTION display_stage_subnodes (p_previous_stage IN NUMBER)
RETURN project_stage_table_type PIPELINED IS
BEGIN
    FOR rec IN (
        SELECT 
            id,
            project_id,
            event_type,
            description,
            start_date,
            end_date,
            previous_stage,
            LEVEL as node_level
        FROM 
            project_stages
        START WITH id = p_previous_stage
        CONNECT BY PRIOR id = previous_stage
    ) LOOP
        PIPE ROW(project_stage_type(rec.id, rec.project_id, rec.event_type, rec.description, rec.start_date, rec.end_date, rec.previous_stage, rec.node_level));
    END LOOP;
    RETURN;
END;

SELECT * FROM TABLE(display_stage_subnodes(5));



CREATE OR REPLACE PROCEDURE add_stage_subnode (
    p_id IN NUMBER,
    p_parent_node IN NUMBER, 
    p_project_id IN NUMBER, 
    p_description IN VARCHAR2, 
    p_event_type IN NUMBER, 
    p_start_date IN DATE, 
    p_end_date IN DATE
) IS
BEGIN
    INSERT INTO project_stages (id, project_id, start_date, end_date, event_type, previous_stage, description)
    VALUES (p_id, p_project_id, p_start_date, p_end_date, p_event_type, p_parent_node, p_description);
END;

EXEC add_stage_subnode(10, 9, 2, 'Project Beta finished', 1, TO_DATE('2023-06-15', 'YYYY-MM-DD'), TO_DATE('2023-06-15', 'YYYY-MM-DD'));

SELECT * FROM TABLE(display_stage_subnodes(5));



CREATE OR REPLACE PROCEDURE move_stage_subtree (
    p_old_parent IN NUMBER,
    p_new_parent IN NUMBER
) IS
BEGIN
    UPDATE project_stages
    SET previous_stage = p_new_parent
    WHERE previous_stage = p_old_parent;
END;

EXEC move_stage_subtree(6, 7);

SELECT * FROM TABLE(display_stage_subnodes(5));