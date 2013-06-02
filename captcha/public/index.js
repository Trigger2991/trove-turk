(function() {
  $(function() {
    new_question(function(id, url) {
      $('.images').append('<img src="' + url + '" />')
    })

    new_question(function(id, url) {
      $('.images').append('<img src="' + url + '" />')
    })
  })

  function new_question(callback) {
    $.get(
      'http://localhost:9002/question?t=' + (+new Date()),
      function(data) {
        callback(data["id"], data["image"])
      }
    )
  }
})()
