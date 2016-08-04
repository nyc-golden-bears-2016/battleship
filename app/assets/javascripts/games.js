$(document).ready(function() {
  $('.fire').submit(function(){
      $('.fire').hide()
  var turn = setInterval(function(){

    $.ajax({
      url: "/games/" + $('#game-id').val() + '/what_turn'
    })
    .done(function(response) {
      if(response.myTurn == true){
        $('.fire').show()
      }

    })
    // .fail(function(error){
    //   console.log(error);
    // })
  }, 5000);
  })
})
