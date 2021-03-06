require_relative 'AI'

class MastermindGame

  PERMUTATIONS = [:r, :g, :o, :b, :p, :y].repeated_permutation(4).to_a

  attr_reader :guesses, :code, :ai

  def initialize
    @ai = AI.new
    reset
  end

  def reset
    @guesses   = Array.new(12).map! { |x| x=Array.new(4) {""} }
    @code      = new_code
    @hint_pegs = Array.new
    @ai.reset
  end

  def generate_mastermind_table
    table = "<div id=mastermind_table class=table>"
    @guesses.each do |guess|
      table += guess[0].empty? ? "<div class=row>" : "<div class=xrow>"
      guess.each do |square|
        table += square.empty? ? "<div class='cell game_cell'>&nbsp;</div>"
                               : "<div class='#{square}cell xcell game_cell'>&nbsp;</div>"
      end

      pegs = key_peg_generator(guess)
      table += "<div class=table><div class=row>"
      pegs[0..1].each { |peg| table += "<div class='#{peg}peg xcell peg'>&nbsp;</div>" }
      table += "</div><div class=row>"
      pegs[2..4].each { |peg| table += "<div class='#{peg}peg xcell peg'>&nbsp;</div>" }
      table += "</div></div></div>"
    end

    table += "</div>"
  end

  def key_peg_generator(_guess)
    return [""] * 4 if _guess[0].empty?
    guess = _guess.clone
    black_pegs = Array.new
    white_pegs = Array.new

    @code.zip(guess).select { |x, y| x == y }.length.times do
      black_pegs << :bl
    end

    @code.each do |char|
      if guess.include? char
        white_pegs << :w
        guess.slice!(guess.index(char))
      end
    end

    black_pegs.length.times { white_pegs.slice!(white_pegs.index(:w)) }

    result = black_pegs + white_pegs
    @hint_pegs = result + [""] * (4 - result.length)

    @hint_pegs
  end

  def get_ai_response
    @ai.invoke(@guesses, @hint_pegs)
  end

  def format_player_response(guess)
    return nil if guess.nil? || guess.empty?
    guess.split("").map { |c| c.downcase.to_sym }
  end

  def check_player_response(guess)
    PERMUTATIONS.include? guess
  end

  def register_player_response(response)
    @guesses.each_with_index do |guess, index|
      if guess[0].empty?
        @guesses[index] = response
        break
      end
    end
  end

  def check_game_status
    status = @hint_pegs.count(:bl) == 4 ? 1 : nil
    status = @guesses[-1][-1].empty? ? nil : 0 unless status

    status
  end

  def new_code
    PERMUTATIONS.sample
  end

  def code=(value)
    if (value.is_a? String) && value.length == 4
      value = format_player_response(value)

      if PERMUTATIONS.include? value
        @code = value
        return
      end
    end

    @code = new_code
  end
end
