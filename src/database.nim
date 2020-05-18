import db_sqlite
import os
import strformat
import strutils
import times
import json

proc initRequested*(): bool =
  let params = commandLineParams()
  if (params.len > 0):
    result = params[0] == "init"
  else:
    result = false

proc initDatabase*(): string =
  let db = open("torrentinim-data.db", "", "", "")

  db.exec(sql"DROP TABLE IF EXISTS torrents")
  db.exec(sql"PRAGMA case_sensitive_like = true;")
  echo "[database] Initializing database"
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
  db.close()

# proc latest*(limit: int): seq[Torrent] =
#   let db = open("torrentinim-data.db", "", "", "")
#   let torrents = db.getAllRows(sql"SELECT name, uploaded_at, canonical_url, magnet_url, size, seeders, leechers FROM torrents LIMIT ?", limit)
#   for row in torrents:
#     result.add(
#       Torrent(
#         name: row[0],
#         uploaded_at: parse(row[1], "yyyy-MM-dd'T'HH:mm:sszzz"),
#         canonical_url: row[2],
#         magnet_url: row[3],
#         size: row[4],
#         seeders: parseInt(row[5]),
#         leechers: parseInt(row[6]),
#       )
#     )
#   db.close()

# proc search*(query: string, page: int): seq[Torrent] =
#   let perPage = 5
#   let skip = if page == 1: 0 else: page * perPage
#   let db = open("torrentinim-data.db", "", "", "")
#   let torrents = db.getAllRows(sql"SELECT name, uploaded_at, canonical_url, magnet_url, size, seeders, leechers FROM torrents WHERE name LIKE '%' || ? || '%' LIMIT ?, ?", query, skip, perPage)

#   for row in torrents:
#     result.add(
#       Torrent(
#         name: row[0],
#         uploaded_at: parse(row[1], "yyyy-MM-dd'T'HH:mm:sszzz"),
#         canonical_url: row[2],
#         magnet_url: row[3],
#         size: row[4],
#         seeders: parseInt(row[5]),
#         leechers: parseInt(row[6]),
#       )
#     )
#   db.close()