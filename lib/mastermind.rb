require_relative 'AI'

class MastermindGame

  PERMUTATIONS = [:r, :g, :o, :b, :p, :t].repeated_permutation(4).to_a

  def initialize
    @guesses   = Array.new(12).map! { |x| x=Array.new(4) {""} }
    @code      = new_code
    @hint_pegs = Array.new # Not nil because array method applied before first play
    @ai        = AI.new
  end

  def generate_mastermind_table
    table = "<div class=table>"
    @guesses.each do |guess|
      table += "<div class=row>"
      guess.each { |square| table += "<div class=#{square}cell></div>" }

      pegs = key_peg_generator(guess)
      table += "<div class=pegs_container>"
      pegs.each { |peg| table += "<div class=#{peg}peg></div>" }
      table += "</div></div>"
    end

    table += "</div>"
  end

  def title
    %Q{___  ___ ___  _____ _____ ______________  ________ _   _______
    |  \\/  |/ _ \\/  ___|_   _|  ___| ___ \\  \\/  |_   _| \\ | |  _  \\
    | .  . / /_\\ \\ `--.  | | | |__ | |_/ / .  . | | | |  \\| | | | |
    | |\\/| |  _  |`--. \\ | | |  __||    /| |\\/| | | | | . ` | | | |
    | |  | | | | /\\__/ / | | | |___| |\\ \\| |  | |_| |_| |\\  | |/ /
    \\_|  |_|_| |_|____/  \\_/ \\____/\\_| \\_\\_|  |_/\\___/\\_| \\_/___/}
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
end
