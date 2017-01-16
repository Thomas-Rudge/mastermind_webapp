require 'sinatra'
require 'sinatra/reloader'
#require_relative 'lib/mastermind'
load '/home/thomas/GitHub/mastermind_webapp/lib/mastermind.rb'

@@game = MastermindGame.new

get "/" do
  erb :index
end

get "/play" do
  redirect "/" if params[:replay] == "true"

  guess = params[:guess]
  guess = @@game.format_player_response(guess)

  unless guess.nil? || guess.empty?
    @@game.register_player_response(guess) if @@game.check_player_response(guess)
  end

  state = @@game.check_game_status
  table = @@game.generate_mastermind_table
  puts "State #{state}"
  erb :game, :locals=>{:table=>table, :state=>state}
end

get "/robot" do
  redirect "/" if params[:replay] == "true"

  guess = @@game.get_ai_response
  @@game.register_player_response(guess)
  state = @@game.check_game_status
  table = @@game.generate_mastermind_table

  erb :game, :locals=>{:table=>table, :state=>state}
end
