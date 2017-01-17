$(document).ready(function() {
  // When a user clicks an input colour, update the board
  $('#select_red').click(function() { updateBoard('red') });
  $('#select_orange').click(function() { updateBoard('orange') });
  $('#select_yellow').click(function() { updateBoard('yellow') });
  $('#select_blue').click(function() { updateBoard('blue') });
  $('#select_green').click(function() { updateBoard('green') });
  $('#select_purple').click(function() { updateBoard('purple') });
  $('#retry').click(function() {  window.location.href = '/play?replay=true' });
  $('#home').click(function() { window.location.href = '/' });

  var updateBoard = function(colour) {
    var cellColours = {red:'#CD3129',
                       orange:'#CD7629',
                       yellow:'#CDCA29',
                       blue:'#27458A',
                       purple:'#60228A',
                       green:'#209F30'};

    var userGuess = $('input[name="guess"]').val();
    userGuess += colour[0]
    $('input[name="guess"]').val(userGuess);
    //$('#mastermind_table').find('.cell').first().css('background-color', 'white');
    var next_cell = $('#mastermind_table').find('.cell').first();
    console.log(cellColours[colour]);
    next_cell.addClass('xcell').removeClass('cell');
    next_cell.css('background-color', cellColours[colour]);

    if (userGuess.length === 4) { submitGuess(userGuess) };
  };

  var submitGuess = function(guess) {
    $('input[name="submit"]').click();
  };
});
