(function() {
  $(function() {
    $('#guess').submit(function() {
      $.ajax({
        url: 'http://localhost:9004/answer',
        type: 'post',
        dataType: 'json',
        success: function(result) {
          console.log(result)
        },
        data: {
          id: 'abc',
          text: $('#answer').val()
        }
      })
      return false
    })

  })
})()
