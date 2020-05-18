import htmlgen
import jester
from "./crawlers/eztv" import nil

when isMainModule:
  eztv.fetchLatest()

  routes:
    get "/":
      resp h1("Hello world")