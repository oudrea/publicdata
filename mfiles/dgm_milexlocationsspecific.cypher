:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/mfiles/dgm_milexlocationsspecific.csv' AS line     CALL apoc.create.node([line.ENTITY_LABEL, 'Entity'], line) YIELD n RETURN n;