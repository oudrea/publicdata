USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM $baseURL + 'EntityCollectionTask_Cognizant-base.csv' AS line 
     MERGE (n:Entity {global_identifier: line.global_identifier}) 
     ON CREATE SET n.name=line.name, n.caption=line.caption, n.type=line.type, n.type_list=apoc.convert.fromJsonList(line.type_list), n.wikipedia_url=line.wikipedia_url, n.wikidata_id=line.wikidata_id, n.dbpedia_id=line.dbpedia_id, n.file_source=line.file_source, n.data_source=line.data_source, n.source_identifier=line.source_identifier, n.global_identifier=line.global_identifier, n.needs_human_review=line.needs_human_review, n.human_review_reason=line.human_review_reason, n.description=line.description, n.logo=apoc.convert.fromJsonList(line.logo), n.image=apoc.convert.fromJsonList(line.image), n.homepage=line.homepage, n.handles=apoc.convert.fromJsonList(line.handles), n.sources = [], n.source_identifiers = [] 
     ON MATCH SET n.name=line.name, n.caption=line.caption, n.type_list=apoc.convert.fromJsonList(line.type_list), n.wikipedia_url=line.wikipedia_url, n.wikidata_id=line.wikidata_id, n.dbpedia_id=line.dbpedia_id, n.file_source=line.file_source, n.needs_human_review=line.needs_human_review, n.human_review_reason=line.human_review_reason, n.description=line.description, n.logo=apoc.convert.fromJsonList(line.logo), n.image=apoc.convert.fromJsonList(line.image), n.homepage=line.homepage, n.handles=apoc.convert.fromJsonList(line.handles), n.sources = apoc.coll.toSet(n.sources + line.data_source), n.source_identifiers = apoc.coll.toSet(n.source_identifiers + line.source_identifier) 
     RETURN n;
USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM $baseURL + 'EntityCollectionTask_Cognizant-base.csv' AS line 
     MATCH (n:Entity {global_identifier: line.global_identifier}) 
     WITH n, line CALL apoc.create.addLabels(n, apoc.convert.fromJsonList(line.labels)) YIELD node RETURN node;
