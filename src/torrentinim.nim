import htmlgen
import jester
import "database"
import "./helpers/datetime"
from "./crawlers/eztv" import nil


when isMainModule:
  if (initRequested()):
    discard initDatabase()

  eztv.fetchLatest()

  routes:
    get "/":
      resp h1("Hello world")