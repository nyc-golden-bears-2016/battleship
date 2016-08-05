$(document).ready(function() {

  updatePreview();

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
    $('.preview_board tr td').css("background-color", "#ccffff");
    var row = $("#aircraft_row").val().charCodeAt(0) - 95;
    var num = Number($("#aircraft_column").val()) + 1;
    var valid = true;
    if ($("#aircraft_orientation").val() === "vertical"){
      if ((row + 5) > 12){
        valid = false;
      }
    } else if ($("#aircraft_orientation").val() === "horizontal"){
      if ((num + 5) > 12){
        valid = false;
      }
    }
    for (var i = 5; i > 0; i--) {
      if (valid === true) {
        $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "black");
      } else {
        $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
      }
      if ($("#aircraft_orientation").val() === "horizontal" ){
        num++;
      } else if ($("#aircraft_orientation").val() === "vertical" ){
        row++;
      }
    }
    var row = $("#battle_row").val().charCodeAt(0) - 95;
    var num = Number($("#battle_column").val()) + 1;
    var valid = true;
    if ($("#battle_orientation").val() === "vertical"){
      if ((row + 4) > 12){
        valid = false;
      }
    } else if ($("#battle_orientation").val() === "horizontal"){
      if ((num + 4) > 12){
        valid = false;
      }
    }
    for (var i = 4; i > 0; i--) {
      if (valid === true) {
        if ($('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(0, 0, 0)" || $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(255, 0, 0)"){
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
        } else {
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "black");
        }
      } else {
        $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
      }
      if ($("#battle_orientation").val() === "horizontal" ){
        num++;
      } else if ($("#battle_orientation").val() === "vertical" ){
        row++;
      }
    }
    var row = $("#sub_row").val().charCodeAt(0) - 95;
    var num = Number($("#sub_column").val()) + 1;
    var valid = true;
    if ($("#sub_orientation").val() === "vertical"){
      if ((row + 1) > 12){
        valid = false;
      }
    } else if ($("#sub_orientation").val() === "horizontal"){
      if ((num + 1) > 12){
        valid = false;
      }
    }
    for (var i = 1; i > 0; i--) {
      if (valid === true) {
        if ($('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(0, 0, 0)" || $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(255, 0, 0)"){
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
        } else {
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "black");
        }
      } else {
        $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
      }
      if ($("#sub_orientation").val() === "horizontal" ){
        num++;
      } else if ($("#sub_orientation").val() === "vertical" ){
        row++;
      }
    }
    var row = $("#destroyer_row").val().charCodeAt(0) - 95;
    var num = Number($("#destroyer_column").val()) + 1;
    var valid = true;
    if ($("#destroyer_orientation").val() === "vertical"){
      if ((row + 2) > 12){
        valid = false;
      }
    } else if ($("#destroyer_orientation").val() === "horizontal"){
      if ((num + 2) > 12){
        valid = false;
      }
    }
    for (var i = 2; i > 0; i--) {
      if (valid === true) {
        if ($('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(0, 0, 0)" || $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(255, 0, 0)"){
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
        } else {
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "black");
        }
      } else {
        $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
      }
      if ($("#destroyer_orientation").val() === "horizontal" ){
        num++;
      } else if ($("#destroyer_orientation").val() === "vertical" ){
        row++;
      }
    }
    var row = $("#tom_row").val().charCodeAt(0) - 95;
    var num = Number($("#tom_column").val()) + 1;
    var valid = true;
    if ($("#tom_orientation").val() === "vertical"){
      if ((row + 3) > 12){
        valid = false;
      }
    } else if ($("#tom_orientation").val() === "horizontal"){
      if ((num + 3) > 12){
        valid = false;
      }
    }
    for (var i = 3; i > 0; i--) {
      if (valid === true) {
        if ($('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(0, 0, 0)" || $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color") === "rgb(255, 0, 0)"){
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
        } else {
          $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "black");
        }
      } else {
        $('.preview_board tr:nth-child('+ row +') td:nth-child('+ num +')').css("background-color", "red");
      }
      if ($("#tom_orientation").val() === "horizontal" ){
        num++;
      } else if ($("#tom_orientation").val() === "vertical" ){
        row++;
      }
    }
  }

  setInterval(ajaxCall, 1000);
  function ajaxCall() {
    $.ajax({
      url: "/games/" + $('#game-id').val() + '/what_turn'
    })
    .done(function(data) {
      if(data.your_turn === true){
        if(data.first_turn === false){
          updateCoordinate(data.coordinates);
        }
        $('.fire').show();
      }
      else if(data.your_turn === false){
        $(".fire").hide();
      }
    });
  }

  $("#setup").change(function(){
    console.log("yo");
    updatePreview();
  });

});
