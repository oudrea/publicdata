MATCH (n:Entity {data_source: "logo_classes"}) CALL { WITH n DETACH DELETE n } IN TRANSACTIONS OF 500 ROWS;