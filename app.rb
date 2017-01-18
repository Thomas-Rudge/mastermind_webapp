require 'sinatra'
#require 'sinatra/reloader'
require_relative 'lib/mastermind'

@@game = MastermindGame.new

def game_returnables
  a = @@game.generate_mastermind_table
  b = @@game.check_game_status
  c = b == 0 ? @@game.code : ""

  [a, b, c]
end

def register_guess(guess)
  unless guess.nil? || guess.empty?
    @@game.register_player_response(guess)
  end
end

################

get "/" do
  erb :index
end

get "/play" do
  @@game.reset if params[:replay] == "true"

  guess = params[:guess]
  guess = @@game.format_player_response(guess)

  register_guess(guess)

  table, state, code = game_returnables

  erb :game, :locals=>{:table=>table, :state=>state, :ai=>false, :guess=>'', :code=>code}
end

get "/ai" do
  @@game.reset if params[:replay] == "true"

  guess = params[:guess]
  guess = @@game.format_player_response(guess)

  user_code   = params[:usercode]
  @@game.code = user_code if !(['x', nil].include? user_code) && guess.nil?

  register_guess(guess)

  table, state, code = game_returnables

  guess = @@game.get_ai_response.join if state.nil?

  erb :game, :locals=>{:table=>table, :state=>state, :ai=>true, :guess=>guess, :code=>code}
end
