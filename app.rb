require 'sinatra'
require 'sinatra/reloader'
#require_relative 'lib/mastermind'
load '/home/thomas/GitHub/mastermind_webapp/lib/mastermind.rb'

@@game = MastermindGame.new

get "/" do
  erb :index
end

get "/play" do
  @@game.reset if params[:replay] == "true"

  guess = params[:guess]
  guess = @@game.format_player_response(guess)

  unless guess.nil? || guess.empty? || (@@game.guesses.include? guess)
    @@game.register_player_response(guess) if @@game.check_player_response(guess)
  end

  table = @@game.generate_mastermind_table
  state = @@game.check_game_status

  erb :game, :locals=>{:table=>table, :state=>state, :ai=>false}
end

get "/ai" do
  @@game.reset if params[:replay] == "true"

  guess = params[:guess]
  guess = @@game.format_player_response(guess)

  unless guess.nil? || guess.empty? || (@@game.guesses.include? guess)
    @@game.register_player_response(guess)
    sleep(1)
  end

  table = @@game.generate_mastermind_table
  state = @@game.check_game_status

  guess = @@game.get_ai_response

  erb :game, :locals=>{:table=>table, :state=>state, :ai=>true, :guess=>guess.join}
end
