CREATE KEYSPACE IF NOT EXISTS dirdemo WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'};
USE dirdemo;
CREATE TABLE IF NOT EXISTS media (
    filename text,
    contents blob,
    mimetype text,
    id uuid,
    PRIMARY KEY(id)
);
