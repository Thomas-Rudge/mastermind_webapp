$(document).ready(function() {
  // When a user clicks an input colour, update the board
  $('#select_red').click(function() { updateBoard('r') });
  $('#select_orange').click(function() { updateBoard('o') });
  $('#select_yellow').click(function() { updateBoard('y') });
  $('#select_blue').click(function() { updateBoard('b') });
  $('#select_green').click(function() { updateBoard('g') });
  $('#select_purple').click(function() { updateBoard('p') });
  $('#retry').click(function() {  window.location.href = '/play?replay=true' });
  $('#home').click(function() { window.location.href = '/' });

  var updateBoard = function(colour) {
    var cellColours = {r:'#CD3129',
                       o:'#CD7629',
                       y:'#CDCA29',
                       b:'#27458A',
                       p:'#60228A',
                       g:'#209F30'};

    var userGuess = $('input[name="guess"]').val();

    userGuess += colour[0]
    $('input[name="guess"]').val(userGuess);
    var next_cell = $('#mastermind_table').find('.cell').first();
    next_cell.addClass('xcell').removeClass('cell');
    next_cell.css('background-color', cellColours[colour]);

    if (userGuess.length === 4) { submitGuess(userGuess) };
  };

  var submitGuess = function(guess) {
    $('input[name="submit"]').click();
  };

  if (window.location.pathname === '/ai' && $('#guess_data') !== null) {
    aiGuess = $('#guess_data').text();
    console.log(aiGuess);


  };
});
