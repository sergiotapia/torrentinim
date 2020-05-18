import htmlgen
import jester
from "./crawlers/eztv" import nil
import "database"

when isMainModule:
  if (initRequested()):
    discard initDatabase()

  # eztv.fetchLatest()

  routes:
    get "/":
      resp h1("Hello world")