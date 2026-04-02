require_relative 'ui'
require_relative 'win_check'

class Game
  include UI::GameUI

  def initialize
    @board_state = Array.new(6) { COLUMNS.zip(Array.new(7, 'empty')).to_h }
    @turn_toggle = true
  end

  def play
    coords = game_loop
    final_render(coords)
  end

  private

  def game_loop
    coords = []
    until win?(coords) || board_full?
      coords = take_turn
    end
    coords
  end

  def take_turn
    clear
    print_banner
    current = @turn_toggle ? 'Red' : 'Blue'
    display_board(@board_state, status: "#{current} to move — choose a column (a–g)")
    input = get_column_input
    row = update_state(input)
    @turn_toggle = !@turn_toggle
    [row, input]
  end

  def get_column_input
    truth_eval = lambda { |input|
      input.match?(/\A[a-g]\z/) && @board_state[5][input] == 'empty'
    }
    validate_input(
      '  Column: ',
      truth_eval,
      'a single letter a–g for a column that is not full.'
    )
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

  def board_full?
    @board_state.all? { |row| row.values.none? { |cell| cell == 'empty' } }
  end

  def update_state(input)
    @board_state.each_with_index do |slot, idx|
      if slot[input] == 'empty'
        slot[input] = @turn_toggle ? 'red' : 'blue'
        return idx
      end
    end
  end

  def win?(coords)
    return false if coords[0].nil?
    WinCheck.new(@board_state, coords).iterate_through_deltas
  end
end
