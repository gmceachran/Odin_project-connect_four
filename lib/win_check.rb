require_relative 'ui'

class WinCheck
  include UI

  # One vector per line family (horizontal, vertical, two diagonals).
  LINE_DIRECTIONS = [[0, 1], [1, 0], [1, 1], [1, -1]].freeze

  def initialize(board_state, coords)
    @board_state = board_state
    @row_idx = coords[0]
    @column_idx = COLUMNS.index(coords[1])
    @starting_token = @board_state[@row_idx][coords[1]]
  end

  def iterate_through_deltas
    return false if @starting_token == 'empty'

    LINE_DIRECTIONS.any? { |row_delta, col_delta| line_length(row_delta, col_delta) >= 4 }
  end

  private

  def line_length(row_delta, col_delta)
    1 +
      count_in_direction(row_delta, col_delta) +
      count_in_direction(-row_delta, -col_delta)
  end

  def count_in_direction(row_delta, col_delta)
    n = 0
    r = @row_idx + row_delta
    c = @column_idx + col_delta
    while r.between?(0, 5) && c.between?(0, 6) && cell(r, c) == @starting_token
      n += 1
      r += row_delta
      c += col_delta
    end
    n
  end

  def cell(row, col)
    @board_state[row][COLUMNS[col]]
  end
end
