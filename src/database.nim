import db_sqlite
import os
import strutils

proc initRequested*(): bool =
  if getEnv("NUKE_MY_DATABASE", "false").parseBool():
    echo "[system] Database nuke requested. Clearing all database tables and data."
    true
  else:
    false

proc initDatabase*(): string =
  let db = open("torrentinim-data.db", "", "", "")

  db.exec(sql"DROP TABLE IF EXISTS torrents")
  db.exec(sql"DROP TABLE IF EXISTS torrents_index")
  db.exec(sql"PRAGMA case_sensitive_like = true;")
  db.exec(sql"PRAGMA encoding = 'UTF-8';")

  echo "[system] Initializing database"
  db.exec(sql"""CREATE TABLE IF NOT EXISTS torrents (
                  id            INTEGER PRIMARY KEY,
                  uploaded_at   DATETIME NOT NULL,
                  name          TEXT NOT NULL,
                  source        TEXT NOT NULL,
                  canonical_url TEXT NOT NULL,
                  magnet_url    TEXT NOT NULL,
                  size          TEXT NOT NULL,
                  seeders       INTEGER,
                  leechers      INTEGER
                )""")
  db.exec(sql"""CREATE UNIQUE INDEX torrents_unique_canonical_url ON torrents(canonical_url)""")
  db.exec(sql"""CREATE INDEX torrents_name ON torrents(name)""")
  db.exec(sql"""CREATE INDEX torrents_uploaded_at ON torrents(uploaded_at)""")
  db.exec(sql"""CREATE INDEX torrents_source ON torrents(source)""")
  db.exec(sql"""CREATE INDEX torrents_seeders ON torrents(seeders)""")
  db.exec(sql"""CREATE INDEX torrents_leechers ON torrents(leechers)""")

  # Now we create the indexes for full-text search.
  db.exec(sql"""CREATE VIRTUAL TABLE torrents_index USING fts5(name, tokenize=porter);""")

  db.exec(sql"""
  CREATE TRIGGER after_torrents_insert AFTER INSERT ON torrents BEGIN
    INSERT INTO torrents_index (
      rowid,
      name
    )
    VALUES(
      new.id,
      new.name
    );
  END;
  """)
  

  db.exec(sql"""
  CREATE TRIGGER after_torrents_update UPDATE OF name ON torrents BEGIN
    UPDATE torrents_index SET name = new.name WHERE rowid = old.id;
  END;
  """)

  db.exec(sql"""
  CREATE TRIGGER after_torrents_delete AFTER DELETE ON torrents BEGIN
    DELETE FROM torrents_index WHERE rowid = old.id;
  END;
  """)

  db.close()
