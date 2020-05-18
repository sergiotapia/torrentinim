import htmlgen
import jester

when isMainModule:
  echo("Hello, World!")

  routes:
    get "/":
      resp h1("Hello world")