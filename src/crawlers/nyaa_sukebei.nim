import httpClient
import streams
import strformat
import xmlparser
import xmltree
import strutils
import filesize
import asyncdispatch
import "../torrents"
import "../torrents/torrent"

proc fetchXml(): Future[XmlNode] {.async} =
  let client = newAsyncHttpClient()
  let xml = await client.getContent("hhttps://sukebei.nyaa.si/?page=rss")
  let xmlStream = newStringStream(xml)
  client.close()
  return parseXML(xmlStream)

proc fetchLatest*() {.async} =
  echo "[nyaa-sukebei] Starting Nyaa Sukebei crawl"

  var xmlRoot = await fetchXml()
  for item_node in xmlRoot.child("channel").findAll("item"):
    var torrent: Torrent = newTorrent()
    torrent.name = item_node.child("title").innerText
    torrent.source = "nyaa-sukebei"
    torrent.canonical_url = item_node.child("guid").innerText
    torrent.seeders = parseInt(item_node.child("nyaa:seeders").innerText)
    torrent.leechers = parseInt(item_node.child("nyaa:leechers").innerText)

    var infoHash = item_node.child("nyaa:infoHash").innerText
    torrent.magnet_url = &"magnet:?xt=urn:btih:{infoHash}&dn=f&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://tracker.port443.xyz:6969/announce&tr=http://tracker3.itzmx.com:6961/announce&tr=udp://tracker.moeking.me:6969/announce&tr=http://vps02.net.orel.ru:80/announce&tr=http://tracker.openzim.org:80/announce&tr=udp://tracker.skynetcloud.tk:6969/announce&tr=https://1.tracker.eu.org:443/announce&tr=https://3.tracker.eu.org:443/announce&tr=http://re-tracker.uz:80/announce&tr=https://tracker.parrotsec.org:443/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.filemail.com:6969/announce&tr=udp://tracker.nyaa.uk:6969/announce&tr=udp://retracker.netbynet.ru:2710/announce&tr=http://tracker.gbitt.info:80/announce&tr=http://tracker2.dler.org:80/announce"

    var rawSize = item_node.child("nyaa:size").innerText.replace("i", "").convert("B").split(" ")[0]
    removeSuffix(rawSize, ".00")
    torrent.size = rawSize

    discard insert_torrent(torrent)

proc startCrawl*() {.async} =
  while true:
    try:
      await fetchLatest()
      await sleepAsync(30000)
    except:
      echo "[nyaa-sukebei] Crawler error, restarting..."
