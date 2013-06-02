h = 7272
w = 5632
s = 256.0

y_tiles = (h / s).ceil
x_tiles = (w / s).ceil

tiles = []

y_tiles.times do |y|
  x_tiles.times do |x|
    output = "tile_#{x + 1}_#{y + 1}.jpg"

    puts output
    `curl --silent 'http://trove.nla.gov.au/ndp/imageservice/nla.news-page20278/tile7-#{x + 1}-#{y + 1}' > #{output}`
    tiles << output
  end
end

`montage #{tiles.join(' ')} -geometry 256x256+0+0 -tile #{x_tiles}x#{y_tiles} montage.jpg`