import httpClient
import times
import streams
import json
import strformat
import strutils
import asyncdispatch
import "../torrents"
import "../torrents/torrent"

let clientHeaders = newHttpHeaders({ 
    "Content-Type": "application/json", 
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36"
  }) 

proc fetchToken(): Future[string] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = clientHeaders
  let tokenJson = await client.getContent("https://torrentapi.org/pubapi_v2.php?get_token=get_token&app_id=torrentinim")
  let tokenJsonStream = newStringStream(tokenJson)
  client.close()
  await sleepAsync(1500)
  return parseJson(tokenJsonStream)["token"].getStr()

proc fetchJson(): Future[JsonNode] {.async.} =
  let token = await fetchToken()
  let client = newAsyncHttpClient()
  client.headers = clientHeaders
  let torrentsJson = await client.getContent(&"https://torrentapi.org/pubapi_v2.php?mode=search&format=json_extended&sort=last&token={token}&app_id=torrentinim")
  let torrentsJsonStream = newStringStream(torrentsJson)
  client.close()
  await sleepAsync(1500)
  return parseJson(torrentsJsonStream)

proc fetchLatest*() {.async.} =
  echo &"{now()} [rarbg] Starting Rarbg crawl"

  var json = await fetchJson()
  for item in json["torrent_results"].items:
    var torrent: Torrent = newTorrent()
    torrent.name = item["title"].getStr()
    torrent.size = $item["size"].getInt()
    torrent.seeders = item["seeders"].getInt()
    torrent.leechers = item["leechers"].getInt()
    torrent.source = "rarbg"
    torrent.magnet_url = item["download"].getStr()
    torrent.canonical_url = item["info_page"].getStr()
    
    discard insert_torrent(torrent)

proc startCrawl*() {.async.} =
  while true:
    try:
      await fetchLatest()
      await sleepAsync(30000)
    except:
      echo &"{now()} [rarbg] Crawler error, restarting..."
