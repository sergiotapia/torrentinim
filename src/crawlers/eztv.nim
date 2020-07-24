import httpClient
import streams
import xmlparser
import xmltree
import os
import strutils
import asyncdispatch
import "../torrents"
import "../torrents/torrent"

proc fetchXml(): Future[XmlNode] {.async} =
  let client = newAsyncHttpClient()
  let xml = await client.getContent("https://eztv.io/ezrss.xml")
  let xmlStream = newStringStream(xml)
  client.close()
  return parseXML(xmlStream)

proc fetchLatest*() {.async} =
  echo "[eztv] Starting EZTV crawl"

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

    discard insert_torrent(torrent)

proc startCrawl*() {.async} =
  while true:
    try:
      await fetchLatest()
      await sleepAsync(30000)
    except:
      echo "[eztv] Crawler error, restarting..."
