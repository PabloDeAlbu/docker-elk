DROP TABLE IF EXISTS cant_per_com;
CREATE TEMPORARY TABLE cant_per_com AS (
WITH RECURSIVE cte (
    id_padre,
    handle_padre,
    name_padre,
    id,
    handle,
    name,
    depth
) as
(
--SELECT cm2cm.parent_comm_id, mv.text_value, cm2cm.child_comm_id, mv2.text_value
-- base
SELECT DISTINCT 0 as id_padre, null as handle_padre, null as name_padre, cm2cm.parent_comm_id as id, h2.handle, mv.text_value, 0 as depth
FROM community2community cm2cm 
INNER JOIN metadatavalue mv ON (mv.resource_id = cm2cm.parent_comm_id AND mv.resource_type_id = 4 AND mv.metadata_field_id = 64)
INNER JOIN metadatavalue mv2 ON (mv2.resource_id = cm2cm.child_comm_id AND mv2.resource_type_id = 4 AND mv2.metadata_field_id = 64)
INNER JOIN handle h on h.resource_type_id = 4 and h.resource_id = cm2cm.child_comm_id    
INNER JOIN handle h2 on h2.resource_type_id = 4 and h2.resource_id = cm2cm.parent_comm_id
WHERE cm2cm.parent_comm_id not in (SELECT DISTINCT(child_comm_id) FROM community2community)

UNION ALL

SELECT DISTINCT cm2cm.parent_comm_id, h.handle, mv.text_value, cm2cm.child_comm_id, h2.handle, mv2.text_value, depth + 1
FROM community2community cm2cm 
INNER JOIN cte ON cte.id = cm2cm.parent_comm_id
INNER JOIN metadatavalue mv ON (mv.resource_id = cm2cm.parent_comm_id AND mv.resource_type_id = 4 AND mv.metadata_field_id = 64)
INNER JOIN metadatavalue mv2 ON (mv2.resource_id = cm2cm.child_comm_id AND mv2.resource_type_id = 4 AND mv2.metadata_field_id = 64)
INNER JOIN handle h on h.resource_type_id = 4 and h.resource_id = cm2cm.parent_comm_id
INNER JOIN handle h2 on h2.resource_type_id = 4 and h2.resource_id = cm2cm.child_comm_id    
)

-- fin cte 

SELECT cte.id_padre, cte.handle_padre,    cte.name_padre,    cte.id,    cte.handle,    cte.name, cte.depth, COUNT(*) FILTER (WHERE i.item_id is not null) as cant
FROM cte
LEFT join community2collection cm2cl on cm2cl.community_id = cte.id
left join collection2item cl2i on cm2cl.collection_id = cl2i.collection_id
left join item i on cl2i.item_id = i.item_id and i.in_archive = true and i.withdrawn = false and cl2i.collection_id = i.owning_collection
INNER JOIN handle h on h.resource_type_id = 4 and h.resource_id = cte.id    
--WHERE cte.depth = 4
GROUP BY cte.id_padre, cte.handle_padre, cte.name_padre,    cte.id,    cte.handle,    cte.name, cte.depth
ORDER BY cte.depth

) -- fin del create temp
;

SELECT * FROM cant_per_com
--where handle = '10915/41'
order by handle, depth;

--SELECT handle, name, CONCAT(handle_padre, '.', handle), cant
SELECT handle, name, CONCAT(handle), cant, depth
FROM cant_per_com cp
WHERE depth = 0;
-- where handle = '10915/42414'

DROP TABLE IF EXISTS tree;
create table tree(
    handle text,
    name text,
    cant bigint,
    path text,
    depth integer
);

-- insert nivel 0
insert into tree
    SELECT handle, name, cant, CONCAT('.', handle,'.'), depth
    FROM cant_per_com cp
    WHERE depth = 0;

-- insert nivel 1
insert into tree
SELECT cp.handle, cp.name, cp.cant, CONCAT(t.path, cp.handle, '.'), cp.depth
--SELECT handle, name, CONCAT(handle), cant, depth
FROM cant_per_com cp
INNER JOIN tree t on cp.handle_padre = t.handle
WHERE cp.depth = 1 -- and cp.handle = '10915/41'
ORDER BY cp.handle_padre, cp.handle;

-- insert nivel 2
insert into tree
SELECT cp.handle, cp.name, cp.cant, CONCAT(t.path, cp.handle, '.'), cp.depth
FROM cant_per_com cp
INNER JOIN tree t on cp.handle_padre = t.handle
WHERE cp.depth = 2
ORDER BY cp.handle_padre, cp.handle;

-- insert nivel 3
insert into tree
SELECT cp.handle, cp.name, cp.cant, CONCAT(t.path, cp.handle, '.'), cp.depth
FROM cant_per_com cp
INNER JOIN tree t on cp.handle_padre = t.handle
WHERE cp.depth = 3
ORDER BY cp.handle_padre, cp.handle;

-- insert nivel 4
insert into tree
SELECT cp.handle, cp.name, cp.cant, CONCAT(t.path, cp.handle, '.'), cp.depth
FROM cant_per_com cp
INNER JOIN tree t on cp.handle_padre = t.handle
WHERE cp.depth = 4
ORDER BY cp.handle_padre, cp.handle;


SELECT * FROM public.tree;