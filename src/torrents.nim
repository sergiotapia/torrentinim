import db_sqlite
import strformat
import times
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