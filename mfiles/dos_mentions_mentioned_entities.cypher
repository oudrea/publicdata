:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/mfiles/dos_mentions_mentioned_entities.csv' AS line     CALL apoc.create.node([line.ENTITY_LABEL, 'Entity'], line) YIELD n RETURN n;