var fs = require('fs'),
  webpage = require('webpage')

phantom.addCookie({
  'name':     'newspaperUser',
  'value':    'user:public:jagregory',
  'domain':   'trove.nla.gov.au',
  'path':     '/',
  'expires':  (new Date()).getTime() + (1000 * 60 * 60)
})

var waitFor = function(condition, callback) {
  setTimeout(function handler() {
    if (condition()) {
      callback()
    } else {
      setTimeout(handler, 1000)
    }
  }, 1000)
}

var page = webpage.create()
var url = 'http://trove.nla.gov.au/ndp/del/article/4256669/826890?zoomLevel=3#pstart826890'

console.log('Fetching url: ' + url)
page.onConsoleMessage = function(msg) {
  console.log('PAGE: ' + msg)
}
var hasReceivedEditPage = false
page.onResourceReceived = function(response) {
  if (response.url.indexOf('http://trove.nla.gov.au/ndp/del/articleForEdit') >= 0 && response.stage === 'end') {
    hasReceivedEditPage = true
  }
}
page.open(url, function() {
  page.evaluate(function() {
    $(window).load(function() {
      console.log('Authenticated: ', ndp.authenticated())

      if (!viewerBean) {
        console.log('Doesnt have viewerBean, creating it')
        createViewerBean(pageId, highlightAreaArray)
      }

      enterPowerEdit()
    })
  })

  waitFor(function() { return hasReceivedEditPage }, function() {
    console.log('Has textarea?', !!document.getElementsByTagName('textarea').length)

    var coordinatesForInput = function(input) {
      return {
        x: parseInt(input.getAttribute('x')),
        y: parseInt(input.getAttribute('y')),
        width: parseInt(input.getAttribute('ww')),
        height: parseInt(input.getAttribute('wh'))
      }
    }

    var worldToViewerCoordinates = function(bounds, viewer) {
      var level = viewer.levels[viewer.zoomLevel]
      var maxLevel = viewer.levels[viewer.maxZoomLevel]

      return {
        x: Math.floor(bounds.x * level.scale / maxLevel.scale) + Math.floor(level.offset.x + viewer.x),
        y: Math.floor(bounds.y * level.scale / maxLevel.scale) + Math.floor(level.offset.y + viewer.y),
        width: Math.floor(bounds.width * level.scale),
        height: Math.floor(bounds.height * level.scale)
      }
    }

    var textareas = document.getElementsByTagName('textarea')
    var all = []
    for (var i = 0; i < textareas.length; i++) {
      all.push(worldToViewerCoordinates(coordinatesForInput(textareas[i]), viewerBean))
    }
    console.log(all)
    return all
  })

  // var editPage = webpage.create()
  // editPage.onConsoleMessage = function(msg) {
  //   console.log('PAGE: ' + msg)
  // }
  // console.log('Fetching ' + editUrl)
  // editPage.open(editUrl, function() {
  //   var documentCoordinates = editPage.evaluate(function() {
  //     var coordinatesForInput = function(input) {
  //       return {
  //         x: parseInt(input.getAttribute('x')),
  //         y: parseInt(input.getAttribute('y')),
  //         width: parseInt(input.getAttribute('ww')),
  //         height: parseInt(input.getAttribute('wh'))
  //       }
  //     }

  //     var textareas = document.querySelectorAll('textarea')

  //     var all = []
  //     for (var i = 0; i < textareas.length; i++) {
  //       all.push(coordinatesForInput(textareas[i]))
  //     }
  //     return all
  //   })

  //   var translatedCoordinates = page.evaluate(function(documentCoordinates) {
  //     var worldToViewerCoordinates = function(bounds, viewer) {
  //       var level = viewer.levels[viewer.zoomLevel]
  //       var maxLevel = viewer.levels[viewer.maxZoomLevel]

  //       return {
  //         x: Math.floor(bounds.x * level.scale / maxLevel.scale) + Math.floor(level.offset.x + viewer.x),
  //         y: Math.floor(bounds.y * level.scale / maxLevel.scale) + Math.floor(level.offset.y + viewer.y),
  //         width: Math.floor(bounds.width * level.scale),
  //         height: Math.floor(bounds.height * level.scale)
  //       }
  //     }

  //     return documentCoordinates.map(function(coordinate) {
  //       gotoAtTopLeft(coordinate.x - 60, coordinate.y - 80)

  //       return worldToViewerCoordinates(coordinate, viewerBean)
  //     })
  //   }, documentCoordinates)

  //   fs.write('scraped.json', JSON.stringify(translatedCoordinates), 'w')
  //   phantom.exit()
  // })
})