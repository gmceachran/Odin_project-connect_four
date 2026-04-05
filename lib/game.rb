require_relative 'ui'
require_relative 'win_check'

class Game
  include UI::GameUI
  attr_reader :board_state

  def initialize
    @board_state = Array.new(6) { COLUMNS.zip(Array.new(7, 'empty')).to_h }
    @turn_toggle = true
  end

  def play # script: no tests
    coords = game_loop 
    final_render(coords)
  end

  def game_loop # looping script / query: assert conditional logic and return value
    coords = []
    until win?(coords) || board_full?
      coords = take_turn 
    end
    coords 
  end

  def take_turn # script / query: assert return value
    render_turn
    coords = place_token
    toggle_turn
    coords
  end

  def place_token # script / query: assert return value
    input = get_column_input
    row = update_state(input)
    [row, input]
  end

  def get_column_input # script / query: assert return value
    truth_eval = lambda { |input|
      input.match?(/\A[a-g]\z/) && @board_state[5][input] == 'empty'
    }
    validate_input(
      '  Column: ',
      truth_eval,
      'a single letter a–g for a column that is not full.'
    )
  end

  def board_full? # query: assert return value
    @board_state.all? { |row| row.values.none? { |cell| cell == 'empty' } }
  end

  def toggle_turn # command: assert direct public side effects
    @turn_toggle = !@turn_toggle
  end

  def update_state(input) # command: assert public side effects
    @board_state.each_with_index do |slot, idx|
      if slot[input] == 'empty'
        slot[input] = @turn_toggle ? 'red' : 'blue'
        return idx
      end
    end
  end

  def win?(coords) # outgoing query: no test
    return false if coords[0].nil?
    WinCheck.new(@board_state, coords).iterate_through_deltas 
  end

  private # no tests

  def render_turn
    clear 
    print_banner
    current = @turn_toggle ? 'Red' : 'Blue'
    display_board(@board_state, status: "#{current} to move — choose a column (a–g)")
  end

  def final_render(coords)
    clear
    print_banner
    display_board(@board_state)
    outcome = if win?(coords)
                  @turn_toggle ? :blue : :red
                else
                  :draw
                end
    display_game_over(outcome)
  end
end
