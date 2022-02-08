USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM $baseURL + 'EntityCollectionTask_Cognizant-namevariants.csv' AS line 
     MERGE (n:Entity {global_identifier: line.global_identifier}) 
     ON CREATE SET n.name=line.name, n.type=line.type, n.type_list=apoc.convert.fromJsonList(line.type_list), n.row_index=line.rowIndex, n.file_source=line.file_source, n.data_source=line.data_source, n.source_identifier=line.source_identifier, n.global_identifier=line.global_identifier, n.company_name=line.COMPANY_NAME, n.url=line.URL, n.hq_address=line.HQ_ADDRESS, n.lat=line.Lat, n.lon=line.Lon, n.sources = [], n.source_identifiers = [] 
     ON MATCH SET n.name=line.name, n.type_list=apoc.convert.fromJsonList(line.type_list), n.row_index=line.rowIndex, n.file_source=line.file_source, n.company_name=line.COMPANY_NAME, n.url=line.URL, n.hq_address=line.HQ_ADDRESS, n.lat=line.Lat, n.lon=line.Lon, n.sources = apoc.coll.toSet(n.sources + line.data_source), n.source_identifiers = apoc.coll.toSet(n.source_identifiers + line.source_identifier) 
     RETURN n;
USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM $baseURL + 'EntityCollectionTask_Cognizant-namevariants.csv' AS line 
     MATCH (n:Entity {global_identifier: line.global_identifier}) 
     WITH n, line CALL apoc.create.addLabels(n, apoc.convert.fromJsonList(line.labels)) YIELD node RETURN node;
