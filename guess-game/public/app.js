(function() {
  $(function() {
    $('#guess').submit(function() {
      $.ajax({
        url: 'http://localhost:9004/answers/new',
        type: 'post',
        contentType: 'application/json; charset=utf-8',
        success: function(result) {
          console.log(result);
          //fetch_new_answer();
        },
        data: JSON.stringify({
          id: 'abc',
          text: $('#answer').val()
        })
      })
      return false
    })

    //fetch_new_answer();
  })

  function fetch_new_answer() {
    $.get(
      'http://localhost:9002/question.json',
      function(data) {
        question = JSON.parse(data);
        console.log(question);
      }
    );
  }
  
})()
