#!/usr/bin/env ruby 

require 'nokogiri'

# This script shows how to extract the SAP JPEG names from Digital Walters
# TEI files and give them new names that refect their book order.

xml = Nokogiri::XML::Document.parse open(ARGV.shift)

ns = { 't' => 'http://www.tei-c.org/ns/1.0' }

# XSLT 2.0 below; won't work with Nokogiri, which is backed
# by libxml2, which supports XSLT 1.0 only
# graphics = xml.xpath "//t:surface/t:graphic[matches(@url, 'sap')]", ns

# Fine, we'll examine each graphic
graphics = xml.xpath "//t:surface/t:graphic", ns

index = 0
graphics.each do |g|
  if (url = g.attribute('url').content) =~ /sap/
    old_name = File.basename(url)
    shelfmark = old_name.split(/_/)[0]
    new_name = sprintf '%s_%05d.jpg', shelfmark, (index += 1)
    puts sprintf("%s %s", old_name, new_name)
  end
end

