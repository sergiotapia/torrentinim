import httpClient
import streams
import strformat
import xmlparser
import xmltree
import os
import strutils
import filesize
import "../torrents"
import "../torrents/torrent"

proc fetchXml(): XmlNode =
  let client = newHttpClient()
  let xml = client.getContent("https://yts.am/rss")
  let xmlStream = newStringStream(xml)
  client.close()
  return parseXML(xmlStream)

proc fetchLatest*() =
  echo "[yts] Starting YTS crawl"

  var xmlRoot = fetchXml()
  for item_node in xmlRoot.child("channel").findAll("item"):
    var torrent: Torrent = newTorrent()
    # torrent.name = item_node.child("title").kind()
    echo item_node.child("title").innerText()
    echo item_node.rawText()
    torrent.source = "yts"
    torrent.canonical_url = item_node.child("link").innerText
    torrent.seeders = 0
    torrent.leechers = 0
    torrent.size = "0"

    var infoHash = item_node.child("enclosure").attr("url").split("/download/")[1]
    torrent.magnet_url = &"magnet:?xt=urn:btih:{infoHash}&dn=f&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://tracker.port443.xyz:6969/announce&tr=http://tracker3.itzmx.com:6961/announce&tr=udp://tracker.moeking.me:6969/announce&tr=http://vps02.net.orel.ru:80/announce&tr=http://tracker.openzim.org:80/announce&tr=udp://tracker.skynetcloud.tk:6969/announce&tr=https://1.tracker.eu.org:443/announce&tr=https://3.tracker.eu.org:443/announce&tr=http://re-tracker.uz:80/announce&tr=https://tracker.parrotsec.org:443/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.filemail.com:6969/announce&tr=udp://tracker.nyaa.uk:6969/announce&tr=udp://retracker.netbynet.ru:2710/announce&tr=http://tracker.gbitt.info:80/announce&tr=http://tracker2.dler.org:80/announce"

    discard insert_torrent(torrent)

  sleep(30000)
  fetchLatest()

proc start_crawl*() =
  fetchLatest()
