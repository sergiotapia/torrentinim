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
      <tv-search available="yes" supportedParams="q,rid,tvmazeid,season,ep" />
      <movie-search available="no" supportedParams="q" />
    </searching>
    <!-- supported categories -->
    <categories>
      <category id="1000" name="Console">
        <subcat id="1010" name="NDS" />
        <subcat id="1020" name="PSP" />
      </category>
      <category id="2000" name="Movies">
        <subcat id="2010" name="Foreign" />
      </category>
    </categories>
  </caps>
</xml>
"""