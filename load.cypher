LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_Bucket.csv' AS line CREATE (:Bucket {guid: line.identifier, name: line.name})
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_Sector.csv' AS line CREATE (:Sector {guid: line.identifier, name: line.name})
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_SuperSector.csv' AS line CREATE (:SuperSector {guid: line.identifier, name: line.name})
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_Region.csv' AS line CREATE (:Region {guid: line.identifier, name: line.name})
:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_TwitterHandle.csv' AS line CREATE (:TwitterHandle {guid: line.identifier, name: line.name, handle:line.handle})
:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_Mention.csv' AS line CREATE (:Mention {guid: line.identifier, name: line.name, popularity: line.popularity, wikipedia_url: "wikipedia.org/wiki/" + line.Wikipedia})
:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_Ticker.csv' AS line CREATE (:Ticker {guid: line.identifier, name: line.name, countryCode: line.countryCode, type: line.type, capiq_id: line.CapitalIQ})
:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_Organization.csv' AS line WITH apoc.convert.fromJsonList(line.location) as locations, line WITH apoc.convert.fromJsonList(line.handles) as handles, locations, line CREATE (:Organization {guid: line.identifier, name:line.name, handles: handles, description: line.description, webpage:line.webpage, status:line.status, type: line.type, capiq_id:line.CapitalIQ, source: "KP"})-[:LOCATED_AT]->(:Address {postalCode: locations[0].postalCode, country: locations[0].country, streetAddress: locations[0].streetAddress, state:locations[0].state, city: locations[0].city, source: "KP"})
:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/all_Person.csv' AS line CREATE (:Person {guid: line.identifier, name: line.name, description: line.description, birthPlace: line.birthPlace, birthName: line.birthName, deathPlace: line.deathPlace, birthDate: line.birthDate, deathDate: line.deathDate, capiq_id: line.CapitalIQ, wikipedia_url: line.Wikipedia})
:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/per_Person_relationship.csv' AS line WITH apoc.convert.fromJsonMap(line.relationship_self) as rd, line MATCH (n1 {guid: line.id}) WITH rd, line, n1 MATCH (n2 {guid: rd.id}) CALL apoc.create.relationship(n1, toUpper(line.relationship_type), rd.meta, n2) YIELD rel RETURN rel
MATCH(n) SET n:Entity
CREATE INDEX entity_guid IF NOT EXISTS FOR (n:Entity) ON (n.guid)
CREATE INDEX person_guid IF NOT EXISTS FOR (n:Person) ON (n.guid)
CREATE INDEX organization_guid IF NOT EXISTS FOR (n:Organization) ON (n.guid)
CREATE INDEX ticker_guid IF NOT EXISTS FOR (n:Ticker) ON (n.guid)
CREATE INDEX twitterhandle_guid IF NOT EXISTS FOR (n:TwitterHandle) ON (n.guid)
CREATE INDEX mention_guid IF NOT EXISTS FOR (n:Mention) ON (n.guid)
CREATE INDEX bucket_guid IF NOT EXISTS FOR (n:Bucket) ON (n.guid)
CREATE INDEX region_guid IF NOT EXISTS FOR (n:Region) ON (n.guid)
CREATE INDEX sector_guid IF NOT EXISTS FOR (n:Sector) ON (n.guid)
CREATE INDEX ssector_guid IF NOT EXISTS FOR (n:SuperSector) ON (n.guid)
:auto USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/oudrea/publicdata/main/per_Organization_relationship.csv' AS line WITH apoc.convert.fromJsonMap(line.relationship_self) as rd, line MATCH (n1:Entity {guid: line.id}) WITH rd, line, n1 MATCH (n2:Entity {guid: rd.id}) CALL apoc.create.relationship(n1, toUpper(line.relationship_type), rd.meta, n2) YIELD rel RETURN rel
CREATE FULLTEXT INDEX nameAndDescriptions FOR (n:Person|Organization|Region|Sector|SuperSector|Bucket|Ticker|TwitterHandle) ON EACH [n.name, n.description]
CREATE FULLTEXT INDEX name_fulltext FOR (n:Person|Organization|Region|Sector|SuperSector|Bucket|Mention|Ticker|TwitterHandle) ON EACH [n.name]