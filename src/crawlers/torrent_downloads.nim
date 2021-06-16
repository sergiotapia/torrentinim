import httpClient
import times
import streams
import strformat
import xmlparser
import xmltree
import strutils
import asyncdispatch
import "../torrents"
import "../torrents/torrent"

proc fetchXml(): Future[XmlNode] {.async.} =
  let client = newAsyncHttpClient()
  let xml = await client.getContent("https://www.torrentdownloads.me/rss.xml")
  let xmlStream = newStringStream(xml)
  client.close()
  return parseXML(xmlStream)

proc fetchLatest*() {.async.} =
  echo &"{now()} [torrentdownloads] Starting TorrentDownloads.me crawl"

  var xmlRoot = await fetchXml()
  for item_node in xmlRoot.child("channel").findAll("item"):
    var torrent: Torrent = newTorrent()
    torrent.name = item_node.child("title").innerText()
    torrent.source = "torrentdownloads.me"
    torrent.canonical_url = "https://torrentdownloads.me" & item_node.child("link").innerText()
    torrent.seeders = item_node.child("seeders").innerText().parseInt()
    torrent.leechers = item_node.child("leechers").innerText().parseInt()
    torrent.size = item_node.child("size").innerText()

    var infoHash = item_node.child("info_hash").innerText()
    torrent.magnet_url = &"magnet:?xt=urn:btih:{infoHash}&dn=f&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://tracker.port443.xyz:6969/announce&tr=http://tracker3.itzmx.com:6961/announce&tr=udp://tracker.moeking.me:6969/announce&tr=http://vps02.net.orel.ru:80/announce&tr=http://tracker.openzim.org:80/announce&tr=udp://tracker.skynetcloud.tk:6969/announce&tr=https://1.tracker.eu.org:443/announce&tr=https://3.tracker.eu.org:443/announce&tr=http://re-tracker.uz:80/announce&tr=https://tracker.parrotsec.org:443/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.filemail.com:6969/announce&tr=udp://tracker.nyaa.uk:6969/announce&tr=udp://retracker.netbynet.ru:2710/announce&tr=http://tracker.gbitt.info:80/announce&tr=http://tracker2.dler.org:80/announce"

    discard insert_torrent(torrent)

proc startCrawl*() {.async.} =
  while true:
    try:
      await fetchLatest()
      await sleepAsync(30000)
    except:
      echo &"{now()} [torrentdownloads] Crawler error, restarting..."
