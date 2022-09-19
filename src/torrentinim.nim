import os
import json
import prologue
import strutils
import strformat

import prologue/middlewares/cors

import "database"
import "./helpers/datetime"
import "./torrents"
from "./crawlers/eztv" import nil
from "./crawlers/leetx.nim" import nil
from "./crawlers/nyaa.nim" import nil
from "./crawlers/yts.nim" import nil
from "./crawlers/torrent_downloads.nim" import nil
from "./crawlers/thepiratebay.nim" import nil
from "./crawlers/rarbg.nim" import nil

when isMainModule:
  if (initRequested()):
    discard initDatabase()

  asyncCheck eztv.startCrawl()
  asyncCheck leetx.startCrawl()
  asyncCheck nyaa.startCrawl()
  asyncCheck yts.startCrawl()
  asyncCheck torrentdownloads.startCrawl()  
  asyncCheck rarbg.startCrawl()

  proc hello*(ctx: Context) {.async.} =
    resp "Torrentinim is running, bambino."

  proc getQueryParamOrDefault(ctx: Context, queryParam: string, defaultValue: int): int =
    let value = ctx.getQueryParams(queryParam)
    
    if value == "":
      result = 0          

    try:
      result = parseInt(value)
    except ValueError as e:
      result = 0

  proc search*(ctx: Context) {.async.} =
    let query = ctx.getQueryParams("query")
    let page = getQueryParamOrDefault(ctx, "page", 0)
    let results = searchTorrents(query, page)
    resp jsonResponse(%results)

  proc hot*(ctx: Context) {.async.} =
    let page = getQueryParamOrDefault(ctx, "page", 0)    
    let results = hotTorrents(page)
    resp jsonResponse(%results)

  var allowOrigins = getEnv("ALLOW_ORIGINS", "")
  let port = getEnv("TORRENTINIM_PORT", "50123").parseInt()
  let settings = newSettings(debug = false, port = Port(port))
  var app = newApp(settings = settings)
  app.use(CorsMiddleware(allowOrigins = @[allowOrigins]))
  app.addRoute("/", hello)
  app.addRoute("/search", search)
  app.addRoute("/hot", hot)

  echo &"Torrentinim is running, bambino. http://localhost:{port}"
  app.run()
  
