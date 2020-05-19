import htmlgen
import jester
import threadpool
import "database"
import "./helpers/datetime"
from "./crawlers/eztv" import nil
from "./crawlers/leetx.nim" import nil
from "./crawlers/nyaa.nim" import nil
from "./crawlers/nyaa_pantsu.nim" import nil
from "./crawlers/yts.nim" import nil
from "./crawlers/torrent_downloads.nim" import nil


when isMainModule:
  if (initRequested()):
    discard initDatabase()

  spawn eztv.fetchLatest()
  spawn leetx.fetchLatest()
  spawn nyaa.fetchLatest()
  spawn nyaa_pantsu.fetchLatest()
  # spawn yts.fetchLatest()
  spawn torrentdownloads.fetchLatest()

  routes:
    get "/":
      resp h1("Hello world")