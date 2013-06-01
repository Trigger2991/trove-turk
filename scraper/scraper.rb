require 'nokogiri'
require 'json'

url = 'http://trove.nla.gov.au/ndp/del/article/4256657/826890?zoomLevel=3#pstart826890'
id = /\/(\d+\/\d+)/.match(url)[1]
edit_doc = `curl --silent 'http://trove.nla.gov.au/ndp/del/articleForEdit/#{id}'`

scale_3 = {
  level_scale: 0.35,
  maxLevel_scale: 1.0,
  level_offset_x: 777,
  level_offset_y: 340,
  viewer_x: -1858.0,
  viewer_y: -482
}

# scale_7 = {
#   level_scale: 0.68,
#   maxLevel_scale: 1.0,
#   level_offset_x: 777,
#   level_offset_y: 340,
#   viewer_x: -2880.0,
#   viewer_y: -618
# }

scale_7 = {
  level_scale: 0.67,
  maxLevel_scale: 1.0,
  level_offset_x: 777,
  level_offset_y: 340,
  viewer_x: -2846.0,
  viewer_y: -612
}

html = Nokogiri::HTML.parse edit_doc
puts html.search('textarea').map { |textarea|
  scale = scale_7

  x = (textarea.attr('x').to_i * scale[:level_scale] / scale[:maxLevel_scale]).floor + (scale[:level_offset_x] + scale[:viewer_x]).floor
  y = (textarea.attr('y').to_i * scale[:level_scale] / scale[:maxLevel_scale]).floor + (scale[:level_offset_y] + scale[:viewer_y]).floor
  width = (textarea.attr('ww').to_i * scale[:level_scale]).floor
  height = (textarea.attr('wh').to_i * scale[:level_scale]).floor

  # adjust fit

  bump_factor = 4

  x -= bump_factor
  y -= bump_factor
  width += bump_factor * 2
  height += bump_factor * 2

  {
    x: x,
    y: y,
    width: width,
    height: height
  }
}.to_a.to_json