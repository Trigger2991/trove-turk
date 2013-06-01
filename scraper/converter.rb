require 'json'

i = 0
JSON.parse(File.read 'scraped.json').each do |coord|
  geo = "#{coord['width']}x#{coord['height']}+#{coord['x']}+#{coord['y']}"
  `convert -crop #{geo} img.jpg #{i}_img.jpg`
  i += 1
end