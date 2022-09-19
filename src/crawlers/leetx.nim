import httpClient
import strformat
import times
import xmltree
import sequtils
import strformat
import htmlparser
import strtabs # To access XmlAttributes
import strutils # To use cmpIgnoreCase
import nimquery
import asyncdispatch
import "../torrents"
import "../torrents/torrent"

proc pageUrls(): seq[string] =
    var categories = @[
        "Anime",
        "Apps",
        "Documentaries",
        "Games",
        "Movies",
        "Music",
        "Other",
        "TV",
        "XXX"
    ]

    result = map(categories, proc (category: string): string =
        &"https://1337x.to/cat/{category}/1/"
    )

proc downloadUrl(url: string): Future[string] {.async.} =
    echo &"{now()} [1337x] Download html: {url}"
    await sleepAsync(200)
    let client = newAsyncHttpClient()
    let content = await client.getContent(url)
    client.close()
    return content

proc extractTorrentLinks(html: string): seq[string] =
    let html = parseHtml(html)
    for a in html.findAll("a"):
        if a.attrs.hasKey "href":
            if a.attr("href").contains("/torrent/"):
                result.add(a.attr("href"))

    result = map(result, proc (link: string): string =
        &"https://1337x.to{link}"
    )

proc extractTorrentInformation(link: string): Future[Torrent] {.async.} =
    var torrent: Torrent = newTorrent()

    let torrentHtml = await downloadUrl(link)
    let html = parseHtml(torrentHtml)

    # Fetch the name
    var name = html.findAll("title")[0]
    .innerText
    .replace("Download Torrent ", "")
    .replace("| 1337x", "")
    .replace("Download ", "")
    .strip()

    if name.endsWith(" Torrent"):
        name = name.replace(" Torrent", "")

    # Fetch the magnet url
    var magnet_url = html.findAll("a").filter(proc (link: XmlNode): bool =
        link.attr("href").startsWith("magnet")
    )[0].attr("href")

    # Fetch the size
    var size = html.querySelector(".torrent-detail-page ul.list")
    .findAll("li")[3]
    .findAll("span")[0]
    .innerText

    # Fetch the seeders
    var seeders = html.querySelector(".seeds").innerText.parseInt

    # Fetch the leechers
    var leechers = html.querySelector(".leeches").innerText.parseInt

    torrent.name = name
    torrent.source = "1337x"
    torrent.canonical_url = link
    torrent.magnet_url = magnet_url
    torrent.size = size
    torrent.seeders = seeders
    torrent.leechers = leechers

    return torrent

proc fetchLatest*() {.async.} =
  echo &"{now()} [1337x] Starting 1337x crawl"
  var pages = pageUrls()
  for url in pages:
    var categoryPageHtml = await downloadUrl(url)
    var torrentLinks = extractTorrentLinks(categoryPageHtml)

    for link in torrentLinks:
      let torrent = await extractTorrentInformation(link)

      let (insertSuccessful, msg) = insert_torrent(torrent)

      if insertSuccessful:
        echo &"{now()} [{torrent.source}] Insert successful: {torrent.name}"
      else:
        echo &"{now()} [{torrent.source}] Insert not successful: {torrent.name} - {msg}"

proc startCrawl*() {.async.} =
  while true:
    try:
      await fetchLatest()
      await sleepAsync(10000)
    except:
      echo &"{now()} [1337x] Crawler error, restarting..."