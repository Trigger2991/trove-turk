(function() {
  $(function() {
    $('#guess').submit(function() {
      $.ajax({
        url: 'http://localhost:9004/answers/new',
        type: 'post',
        contentType: 'application/json; charset=utf-8',
        success: function(result) {
          console.log(result)
        },
        data: JSON.stringify({
          id: $('#id').val(),
          text: $('#answer').val()
        })
      })
      $('#id').val($('#id').val() + '1')
      $('#answer').val('')
      return false
    })
  })
})()
