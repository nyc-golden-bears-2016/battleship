$(document).ready(function() {

  function updateCoordinate(coord){
    coord = coord.split(", ");
    var row = coord[0].charCodeAt(0) - 95;
    var num = Number(coord[1]) + 1;
    var tile_status = $('.your_board tr:nth-child('+ row +') td:nth-child('+ num +')').html();
    if (tile_status === "🚨" || tile_status === "◈") {
      $('.your_board tr:nth-child('+ row +') td:nth-child('+ num +')').html("&#128680;");
    } else {
      $('.your_board tr:nth-child('+ row +') td:nth-child('+ num +')').html("&#x25CE;");
    }
  }

  function updatePreview(){

  }

  setInterval(ajaxCall, 1000);
  function ajaxCall() {
    $.ajax({
      url: "/games/" + $('#game-id').val() + '/what_turn'
    })
    .done(function(data) {
      if(data.your_turn === true){
        updateCoordinate(data.coordinates);
        $('.fire').show();
      }
      else if(data.your_turn === false){
        $(".fire").hide();
      }
    });
  }

});
