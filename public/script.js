$(document).ready(function() {
  if (window.location.pathname == "/play") {
    $('.game_cell').click(function() { removeFromBoard($(this)); return false; });
  };

  $('#select_red').click(function() { updateBoard('r'); return false; });
  $('#select_orange').click(function() { updateBoard('o'); return false; });
  $('#select_yellow').click(function() { updateBoard('y'); return false; });
  $('#select_blue').click(function() { updateBoard('b'); return false; });
  $('#select_green').click(function() { updateBoard('g'); return false; });
  $('#select_purple').click(function() { updateBoard('p'); return false; });
  $('#retry').click(function() { retryGame(); return false; });
  $('#home').click(function() { window.location.href = '/' });
  $('#codemaker_button').click(function() { startCodemaker() });
  $('#codebreaker_button').click(function() { startCodebreaker() });
  $('#code_input').click(function() { showCodeTip(); return false; });

  var retryGame = function(user) {
    if (window.location.pathname == "/play") {
      console.log('play')
      window.location.href = '/play?replay=true';
    } else {
      console.log('ai')
      window.location.href = '/ai?replay=true';
    };
  };

  var showCodeTip = function() {
    console.log('Triggered');
    $('#code_tip').slideDown();
  };

  var getAvailableResolution = function() {
    return [$(window).width(), $(window).height()];
  };

  var setBoardSize = function() {
    var res = getAvailableResolution();

    var cellxy  = res[1] / 15;
    var pegxy   = Math.round((cellxy - 1) / 2);
    var inputxy = Math.round(cellxy / 1.16);
    cellxy  = Math.round(cellxy);

    var table_width = (cellxy * 4) + (pegxy * 2) + 12;

    cellxy      = cellxy.toString() + 'px';
    pegxy       = pegxy.toString() + 'px';
    inputxy     = inputxy.toString() + 'px';
    table_width = table_width.toString() + 'px';

    $('#mastermind_container').css('width', table_width);
    $('.button_container').css('width', table_width);
    $('.game_cell').css( {'width': cellxy, 'height': cellxy} );
    $('.peg').css( {'width': pegxy, 'height': pegxy} );
    $('.input_cell').css( {'width': inputxy, 'height': inputxy} );
  };

  var startCodebreaker = function() {
    user_uri = '/play?replay=true';
    window.location.href = user_uri;
  };

  var startCodemaker = function() {
    user_code = $('#code_input').val();
    if (user_code === '') { user_code = 'x' };
    ai_uri = '/ai?replay=true&usercode=' + user_code;
    window.location.href = ai_uri;
  };

  var removeFromBoard = function(cell) {
    if (!cell.hasClass('removable')) { return };
    colour = cell.attr('data-color');
    cell.addClass('cell').removeClass('xcell').removeClass('removable');
    cell.attr('data-color', 'x');
    cell.css('background-color', 'transparent');

    var userGuess = $('input[name="guess"]').val();
    userGuess = userGuess.replace(colour, '');
    $('input[name="guess"]').val(userGuess);
  };

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
    next_cell.addClass('xcell').addClass('removable').removeClass('cell');
    next_cell.attr('data-color', colour);
    next_cell.css('background-color', cellColours[colour]);

    if (userGuess.length === 4) { submitGuess(userGuess) };
  };

  var submitGuess = function(guess) {
    if (guess.length == 4) {
      $('input[name="submit"]').click();
    };
  };

  if (window.location.pathname === '/ai' && $('#guess_data') !== null) {
    setBoardSize();

    aiGuess = $('#guess_data').text();

    setTimeout(function(){
      for(var x = 0, c=''; c = aiGuess.charAt(x); x++){
        updateBoard(c);
      };
    }, 1200);
  } else if (window.location.pathname === '/play') {
    setBoardSize();
  };
});
