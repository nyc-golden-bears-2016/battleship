$(document).ready(function() {

  setInterval(ajaxCall, 1000) ;

  function ajaxCall() {
    $.ajax({
      url: "/games/" + $('#game-id').val() + '/what_turn'
    })
    .done(function(response) {
      console.log('MONEY')
      if(response === true){
        $('.fire').show();
      }
      else if(response === false){
        $(".fire").hide();
      }
    })
    }
})
