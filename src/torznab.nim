import strformat
import strutils
import times
import xmltree

import "./torrents"
import "./torrents/torrent"

proc torrentXml*(torrent: Torrent): string =
    let uploadDate = torrent.uploaded_at.format("ddd, d MMM yyyy HH:mm:ss zzz")

    fmt"""
    <item>
      <title>{torrent.name}</title>
      <guid isPermaLink="true">{torrent.canonical_url}</guid>
      <link>{torrent.canonical_url}</link>
      <comments>{torrent.canonical_url}</comments>
      <pubDate>{uploadDate}</pubDate>
      <size>{torrent.size}</size>
      <description>{torrent.name}</description>
      <enclosure url="https://hdaccess.net/download.php?torrent=11515&amp;passkey=123456" length="2538463390" type="application/x-bittorrent" />
      <torznab:attr name="category" value="5000" />
      <torznab:attr name="category" value="5040" />
      <torznab:attr name="category" value="100009" />
      <torznab:attr name="category" value="100036" />
      <torznab:attr name="seeders" value="{torrent.seeders}" />
      <torznab:attr name="peers" value="{torrent.leechers}" />
      <torznab:attr name="magneturl" value="{xmltree.escape(torrent.magnet_url)}" />
      <torznab:attr name="minimumratio" value="1.0" />
      <torznab:attr name="minimumseedtime" value="172800" />
    </item>
    """

proc torznabSearch*(query: string, page: string): string =
  let results = searchTorrents(query, page)
  var torrentsXml = newSeq[string](0)
  for item in results:
    torrentsXml.add(torrentXml(item))

  let torrentXmlString = join(torrentsXml, "\n")

  fmt"""
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="1.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:torznab="http://torznab.com/schemas/2015/feed">
  <channel>
    <atom:link href="https://hdaccess.net/api" rel="self" type="application/rss+xml" />
    <title>HDAccess</title>
    <description>HDAccess API</description>
    <link>https://hdaccess.net</link>
    <language>en-us</language>
    <webMaster>($email) (HDA Invites)</webMaster>
    <category>search</category>
    <image>
      <url>https://hdaccess.net/logo_small.png</url>
      <title>HDAccess</title>
      <link>https://hdaccess.net</link>
      <description>HDAccess API</description>
    </image>

    {torrentXmlString}
  </channel>
</rss>
  """

proc torznabCaps*(): string =
  """
<?xml version="1.0" encoding="UTF-8"?>
<xml>
  <caps>
    <!-- server information -->
    <server version="1.0" title="site" strapline="..." email="info@site.com" url="http://servername.com/" image="http://servername.com/theme/black/images/banner.jpg" />
    <limits max="100" default="50" />
    <registration available="yes" open="yes" />
    <searching>
      <search available="yes" supportedParams="q" />
      <tv-search available="yes" supportedParams="q" />
      <movie-search available="yes" supportedParams="q" />
    </searching>
    <!-- supported categories -->
    <categories>
      <category id="1000" name="TV">
      </category>
      <category id="2000" name="Movies">
      </category>
    </categories>
  </caps>
</xml>
"""