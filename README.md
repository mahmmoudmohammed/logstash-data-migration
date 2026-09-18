# logstash-data-migration
A practical  POC and guide to moving data from a SQL database (MySQL/MariaDB) to search engin using ELK tools (elasticSearch/opensearch, Logstash) and pipelines.
```bash
# create indexes with mapping
curl -u admin:'1a2B3456~' --location --request PUT 'https://localhost:9200/orders/' \
--header 'Content-Type: application/json' \
--data '{
    "mappings": {
        "properties": {
            "agree": {
                "type": "boolean"
            },
        }
    }
}' --insecure
```
