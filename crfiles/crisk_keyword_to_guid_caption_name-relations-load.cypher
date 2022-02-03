USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM $baseURl + 'crisk_keyword_to_guid_caption_name-rel.csv' AS line 
     MATCH (nsrc:Entity { global_identifier: line.source_global_identifier }) 
     WITH nsrc, line MATCH (ndest:Entity { global_identifier: line.destination_global_identifier }) 
     WITH nsrc, ndest, line, apoc.convert.fromJsonMap(line.rel_properties) as ro 
     CALL apoc.merge.relationship.eager(nsrc, line.rel_type, {}, ro, ndest, ro) YIELD rel RETURN rel;