import db_sqlite
import strformat
import times
import strformat
import strutils
import "./torrents/torrent"

proc insert_torrent*(torrent: Torrent): bool =
  echo &"{now()} [{torrent.source}] Inserting torrent: {torrent.name}"

  let db = open("torrentinim-data.db", "", "", "")
  result = db.tryInsertID(sql"INSERT INTO torrents (uploaded_at, name, source, canonical_url, magnet_url, size, seeders, leechers) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
    torrent.uploaded_at,
    torrent.name,
    torrent.source,
    torrent.canonical_url,
    torrent.magnet_url,
    torrent.size,
    torrent.seeders,
    torrent.leechers
  ) != -1
  db.close()

proc searchTorrents*(query: string, page: string): seq[Torrent] =
  let limit = 20
  var offset = 0
  if (parseInt(page) > 1):
    offset = parseInt(page) * limit

  let db = open("torrentinim-data.db", "", "", "")
  let torrents = db.getAllRows(sql"""
  SELECT torrents.name, torrents.uploaded_at, torrents.canonical_url, torrents.magnet_url, torrents.size, torrents.seeders, torrents.leechers
  FROM torrents_index 
  INNER JOIN torrents on torrents_index.rowid = torrents.id
  WHERE torrents_index MATCH ?
  ORDER BY rank
  LIMIT ?
  OFFSET ?;
  """, &"name:{query.escape()}", limit, offset)
  
  for row in torrents:
    result.add(
      Torrent(
        name: row[0],
        uploaded_at: parse(row[1], "yyyy-MM-dd'T'HH:mm:sszzz"),
        canonical_url: row[2],
        magnet_url: row[3],
        size: row[4],
        seeders: parseInt(row[5]),
        leechers: parseInt(row[6]),
      )
    )
  db.close()
  
proc hotTorrents*(page: string): seq[Torrent] =
  let limit = 20
  var offset = 0
  if (parseInt(page) > 1):
    offset = parseInt(page) * limit

  let db = open("torrentinim-data.db", "", "", "")
  let torrents = db.getAllRows(sql"""
  SELECT name, uploaded_at, canonical_url, magnet_url, size, seeders, leechers
  FROM torrents 
  ORDER BY seeders DESC
  LIMIT ?
  OFFSET ?;
  """, limit, offset)
  
  for row in torrents:
    result.add(
      Torrent(
        name: row[0],
        uploaded_at: parse(row[1], "yyyy-MM-dd'T'HH:mm:sszzz"),
        canonical_url: row[2],
        magnet_url: row[3],
        size: row[4],
        seeders: parseInt(row[5]),
        leechers: parseInt(row[6]),
      )
    )
  db.close()