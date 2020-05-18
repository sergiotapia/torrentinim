import httpClient
import streams
import xmlparser
import xmltree
import os
import strutils
import "../torrents/torrent"

proc fetchXml(): XmlNode =
    var client = newHttpClient()
    let xml = client.getContent("https://eztv.io/ezrss.xml")
    let xmlStream = newStringStream(xml)
    return parseXML(xmlStream)

proc fetchLatest*() =
    echo "[eztv] Starting EZTV crawl"

    var xmlRoot = fetchXml()
    for item_node in xmlRoot.findAll("item"):
        var torrent: Torrent = newTorrent()
        torrent.name = item_node.child("title").innerText
        torrent.canonical_url = item_node.child("link").innerText
        torrent.size = item_node.child("torrent:contentLength").innerText
        torrent.seeders = parseInt(item_node.child("torrent:seeds").innerText)
        torrent.leechers = parseInt(item_node.child("torrent:peers").innerText)
        for ic in item_node.child("torrent:magnetURI").items:
            torrent.magnet_url = ic.text
        # echo torrent
        # discard insert_torrent(torrent)

    sleep(10000)
    fetchLatest()

proc start_crawl*() =
    fetchLatest()
