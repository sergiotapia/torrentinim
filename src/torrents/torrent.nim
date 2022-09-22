import times

type Torrent* = object
  ## Torrent represents a crawled torrent from one of our
  ## supported sources.  
  name*: string
  source*: string
  uploaded_at*: DateTime
  canonical_url*: string
  magnet_url*: string
  size*: string
  seeders*: int
  leechers*: int

proc newTorrent*(): Torrent =
  result = Torrent(uploaded_at: now().utc)