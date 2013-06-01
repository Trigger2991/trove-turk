(function() {
  $(function() {
    $('#guess').submit(function() {
      $.ajax({
        url: 'http://localhost:9004/answers/new',
        type: 'post',
        contentType: 'application/json; charset=utf-8',
        success: function(result) {
          console.log(result);
          new_question();
          $('#answer').focus();
        },
        data: JSON.stringify({
          id: $('#id').val(),
          text: $('#answer').val()
        })
      })
      $('#answer').val('')
      return false
    })

    new_question();
  })

  function new_question() {
    $.get(
      'http://localhost:9002/question',
      function(data) {
        id = data["id"];
        image_url = data["image"];
        render_question(id, image_url);
      }
    );
  }

  function render_question(id, image_url) {
    $('#id').val(id);
    $('#image > img').attr('src', image_url)
  }
  
})()
