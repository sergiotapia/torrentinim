import httpClient
import strformat
import times
import streams
import xmlparser
import xmltree
import strutils
import asyncdispatch
import "../torrents"
import "../torrents/torrent"

proc fetchXml(): Future[XmlNode] {.async.} =
  let client = newAsyncHttpClient()
  let xml = await client.getContent("https://eztv.re/ezrss.xml")
  let xmlStream = newStringStream(xml)
  client.close()
  return parseXML(xmlStream)

proc fetchLatest*() {.async.} =
  echo &"{now()} [eztv] Starting EZTV crawl"

  var xmlRoot = await fetchXml()
  for item_node in xmlRoot.findAll("item"):
    var torrent: Torrent = newTorrent()
    torrent.name = item_node.child("title").innerText
    torrent.source = "eztv"
    torrent.canonical_url = item_node.child("link").innerText
    torrent.size = item_node.child("torrent:contentLength").innerText
    torrent.seeders = parseInt(item_node.child("torrent:seeds").innerText)
    torrent.leechers = parseInt(item_node.child("torrent:peers").innerText)
    for ic in item_node.child("torrent:magnetURI").items:
      torrent.magnet_url = ic.text

    if insert_torrent(torrent):
      echo &"{now()} [{torrent.source}] Insert successful: {torrent.name}"
    else:
      echo &"{now()} [{torrent.source}] Insert not successful: {torrent.name}"

proc startCrawl*() {.async.} =
  while true:
    try:
      await fetchLatest()
      await sleepAsync(30000)
    except:
      echo &"{now()} [eztv] Crawler error, restarting..."
