## This module provides a helper function to convert a 
## DateTime JsonNode to a string representation for 
## rendering in a JSON response.

import times
import json

proc `%`*(dt: DateTime): JsonNode =
  ## Accepts a DateTime JsonNode, and return it's
  ## string representation. 
  return newJString $dt