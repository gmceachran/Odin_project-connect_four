require_relative 'ui'

class WinCheck
  include UI
  DIRECTIONS = {
    [1, 1] => :d1, [-1, -1] => :d1,
    [1, 0] => :h, [-1, 0] => :h,
    [1, -1] => :d2, [-1, 1] => :d2,
    [0, 1] => :v, [0, -1] => :v
  }.freeze

  def initialize(board_state, coords)
    @board_state = board_state
    @row = @board_state[coords[0]]
    @starting_token = @row[coords[1]]
    @row_idx = coords[0]
    @column_idx = COLUMNS.index(coords[1])
    @matches = { d1: 0, h: 0, d2: 0, v: 0 }
  end

  def iterate_through_deltas
    [1, 0, -1].product([1, 0, -1]).reject { |delta| delta == [0, 0] }.any? { |delta| win_eval(DIRECTIONS[delta], delta) }
  end

  private 

  def win_eval(key, delta)
    local_row = @row_idx
    local_column = @column_idx
    row_delta = delta[0]
    column_delta = delta[1]

    loop do
      next_row = local_row + row_delta
      next_col_idx = local_column + column_delta
      break if next_row < 0 || next_row > 5 || next_col_idx < 0 || next_col_idx > 6

      next_column = COLUMNS[next_col_idx]
      next_item = @board_state[next_row][next_column]

      if @starting_token == next_item
        local_row += row_delta
        local_column += column_delta
        @matches[DIRECTIONS[delta]] += 1
        return true if @matches[key] == 3
        next
      end
      return true if @matches[key] == 3
      break
    end
    false
  end
end
