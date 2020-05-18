import htmlgen
import jester
import threadpool
import "database"
import "./helpers/datetime"
from "./crawlers/eztv" import nil
from "./crawlers/leetx.nim" import nil


when isMainModule:
  if (initRequested()):
    discard initDatabase()

  spawn eztv.fetchLatest()
  spawn leetx.fetchLatest()

  routes:
    get "/":
      resp h1("Hello world")