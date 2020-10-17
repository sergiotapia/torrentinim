import os
import htmlgen
import jester
import threadpool
import strutils
import json
import "database"
import "./helpers/datetime"
import "./torrents"
from "./crawlers/eztv" import nil
from "./crawlers/leetx.nim" import nil
from "./crawlers/nyaa.nim" import nil
from "./crawlers/nyaa_pantsu.nim" import nil
from "./crawlers/yts.nim" import nil
from "./crawlers/torrent_downloads.nim" import nil
from "./crawlers/nyaa_sukebei.nim" import nil
from "./crawlers/thepiratebay.nim" import nil
from "./crawlers/rarbg.nim" import nil

when isMainModule:
  if (initRequested()):
    discard initDatabase()

  asyncCheck eztv.startCrawl()
  asyncCheck leetx.startCrawl()
  asyncCheck nyaa.startCrawl()
  asyncCheck nyaa_pantsu.startCrawl()
  asyncCheck nyaa_sukebei.startCrawl()
  asyncCheck yts.startCrawl()
  asyncCheck torrentdownloads.startCrawl()
  asyncCheck thepiratebay.startCrawl()
  asyncCheck rarbg.startCrawl()
  
  router apiRouter:
    get "/":
      resp "Torrentinim is running, bambino."
    get "/search":
      cond @"query" != ""
      cond @"page" != ""
      let query = request.params["query"]
      let page = request.params["page"]
      let results = searchTorrents(query, page)
      resp %results

  let port = Port getEnv("TORRENTINIM_PORT", "50123").parseInt()
  var jesterServer = initJester(apiRouter, settings=newSettings(port=port))
  jesterServer.serve()
  