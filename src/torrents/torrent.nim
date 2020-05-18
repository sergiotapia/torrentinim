import times

type
  Torrent* = object
    name*: string
    uploaded_at*: DateTime
    canonical_url*: string
    magnet_url*: string
    size*: string
    seeders*: int
    leechers*: int

proc newTorrent*(): Torrent =
  result = Torrent(uploaded_at: now())