(function() {
  (function fetch_initial_questions() {
    $.get(
      'http://localhost:9002/question?t=' + (+new Date()),
      function(data) {
        $('#id').val(data["id"]);
        $('#image1 > img').attr('src', data["image"])
      }
    );
    $.get(
      'http://localhost:9002/question?t=' + (+new Date()),
      function(data) {
        $('#image2 > img').attr('src', data["image"]);
        $('#idholder').text(data["id"]);
      }
    );
  })();


  $(function() {
    var image_data;

    $('#guess').submit(function() {
      $.ajax({
        url: 'http://localhost:9004/answers/new',
        type: 'post',
        contentType: 'application/json; charset=utf-8',
        success: function(result) {
          next_question();
        },
        error: function(result) {
          alert('Sending failed');
          console.log(result);
        },
        data: JSON.stringify({
          id: $('#id').val(),
          text: $('#answer').val()
        })
      });

      $.get(
        'http://localhost:9002/question',
        function(data) {
          set_data(data);
        }
      );

      return false
    });

    function set_data(data) {
      image_data = data;
    }

    function next_question() {
      $('#image1').attr('class', 'slide_1');
      $('#image2').attr('class', 'slide_2');
      $('#id').val($('#idholder').text());
      $('#answer').val('').focus();

      setTimeout(function() {
        $('#image1').attr("id", "image");
        $('#image2').attr("id", "image1");
        $('#image').attr("id", "image2");
        $('#image2 > img').attr('src', image_data["image"])
        $('#idholder').text(image_data["id"]);
              }, 1000);
    }
  });
})()
