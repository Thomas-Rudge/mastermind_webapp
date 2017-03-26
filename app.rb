require 'sinatra'
#require 'sinatra/reloader'
require_relative 'lib/mastermind'

configure :production do
  set :host, 'toms-mastermind.herokuapp.com'
  set :force_ssl, false # It's just a game
  #set :protection, :except => :frame_options
end

@@game = MastermindGame.new

def game_returnables
  a = @@game.generate_mastermind_table
  b = @@game.check_game_status
  c = b == 0 ? @@game.code.join : ""

  [a, b, c]
end

def register_guess(guess)
  unless guess.nil? || guess.empty?
    @@game.register_player_response(guess)
  end
end

def generate_css(resolution)
  resolution = resolution.split(":").map { |x| x.to_i }

  cellxy, pegxy, inputxy, table_width = get_css_dimensions(resolution)
  css = dynamic_css(cellxy, pegxy, inputxy, table_width)

  filename = File.expand_path('dynamic.css', settings.public_dir)
  File.open(filename, "w") { |file| file.write(css) }
end

def get_css_dimensions(resolution)
  cellxy  = resolution[1] / 15
  pegxy   = (cellxy -1) / 2
  inputxy = (cellxy / 1.16).round

  table_width = (cellxy * 4) + (pegxy * 2) + 12;

  cellxy      = cellxy.to_s + "px"
  pegxy       = pegxy.to_s + "px"
  inputxy     = inputxy.to_s + "px"
  table_width = table_width.to_s + "px"

  [cellxy, pegxy, inputxy, table_width]
end

def dynamic_css(cellxy, pegxy, inputxy, table_width)
  %Q{
#mastermind_container{width:#{table_width}}
.button_container{width:#{table_width}}
.game_cell{width:#{cellxy}; height: #{cellxy}}
.peg{width:#{pegxy};height: #{pegxy}}
.input_cell{width:#{inputxy};height: #{inputxy}}
  }
end

################

get "/" do
  response['Access-Control-Allow-Origin'] = 'http://www.thomasrudge.co.uk/html/software.html'
  erb :index
end

get "/play" do
  @@game.reset if params[:replay] == "true"

  res = params[:res]
  puts res.nil?
  generate_css(res) unless res.nil?

  guess = params[:guess]
  guess = @@game.format_player_response(guess)

  register_guess(guess)

  table, state, code = game_returnables

  erb :game, :locals=>{:table=>table, :state=>state, :ai=>false, :guess=>'', :code=>code}
end

get "/ai" do
  @@game.reset if params[:replay] == "true"

  res = params[:res]
  generate_css(res) unless res.nil?

  guess = params[:guess]
  guess = @@game.format_player_response(guess)

  user_code   = params[:usercode]
  @@game.code = user_code if !(['x', nil].include? user_code) && guess.nil?

  register_guess(guess)

  table, state, code = game_returnables

  guess = @@game.get_ai_response.join if state.nil?

  erb :game, :locals=>{:table=>table, :state=>state, :ai=>true, :guess=>guess, :code=>code}
end
