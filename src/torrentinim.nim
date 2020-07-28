import os
import htmlgen
import jester
import threadpool
import strutils
import "database"
import "./helpers/datetime"
from "./crawlers/eztv" import nil
from "./crawlers/leetx.nim" import nil
from "./crawlers/nyaa.nim" import nil
from "./crawlers/nyaa_pantsu.nim" import nil
from "./crawlers/yts.nim" import nil
from "./crawlers/torrent_downloads.nim" import nil
from "./crawlers/nyaa_sukebei.nim" import nil
from "./crawlers/thepiratebay.nim" import nil

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
  
  router apiRouter:
    get "/":
      resp "Torrentinim is running, bambino."

  let port = Port getEnv("TORRENTINIM_PORT", "50123").parseInt()
  var jesterServer = initJester(apiRouter, settings=newSettings(port=port))
  jesterServer.serve()
  