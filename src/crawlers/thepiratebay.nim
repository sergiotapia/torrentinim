import httpClient
import streams
import json
import strformat
import strutils
import asyncdispatch
import "../torrents"
import "../torrents/torrent"

proc fetchJson(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  let json = await client.getContent("https://apibay.org/precompiled/data_top100_recent.json")
  let jsonStream = newStringStream(json)
  client.close()
  return parseJson(jsonStream)

proc fetchLatest*() {.async.} =
  echo "[thepiratebay] Starting ThePirateBay crawl"

  var json = await fetchJson()
  for item in json.items:
    var torrent: Torrent = newTorrent()
    torrent.name = item["name"].getStr()
    torrent.size = $item["size"].getInt()
    torrent.seeders = item["seeders"].getInt()
    torrent.leechers = item["leechers"].getInt()
    torrent.source = "thepiratebay"

    var id = $item["id"].getInt()
    torrent.canonical_url = &"https://thepiratebay.org/description.php?id={id}"
    
    var infoHash = item["info_hash"].getStr()
    torrent.magnet_url = &"magnet:?xt=urn:btih:{infoHash}&dn=f&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://tracker.port443.xyz:6969/announce&tr=http://tracker3.itzmx.com:6961/announce&tr=udp://tracker.moeking.me:6969/announce&tr=http://vps02.net.orel.ru:80/announce&tr=http://tracker.openzim.org:80/announce&tr=udp://tracker.skynetcloud.tk:6969/announce&tr=https://1.tracker.eu.org:443/announce&tr=https://3.tracker.eu.org:443/announce&tr=http://re-tracker.uz:80/announce&tr=https://tracker.parrotsec.org:443/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.filemail.com:6969/announce&tr=udp://tracker.nyaa.uk:6969/announce&tr=udp://retracker.netbynet.ru:2710/announce&tr=http://tracker.gbitt.info:80/announce&tr=http://tracker2.dler.org:80/announce"
    
    discard insert_torrent(torrent)

proc startCrawl*() {.async} =
  while true:
    try:
      await fetchLatest()
      await sleepAsync(30000)
    except:
      echo "[thepiratebay] Crawler error, restarting..."
