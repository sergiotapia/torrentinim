import times
import json

proc `%`*(dt: DateTime): JsonNode =
  result = newJString $dt