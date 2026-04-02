
1, 1 diagonal 1
1, 0 sideways
1, -1 diagonal 2
0, 1 vertical
0, -1 vertical
-1, 1 diagonal 2
-1, 0 sideways
-1, -1 diagonal 1

matches = {
  d1: 0,
  h: 0, 
  d2: 0,
  v: 0
}


case delta
when [1, 1] || [-1, -1] # diagonal 1
  win_eval(matches[d1])
when [1, 0] || [-1, 0] # horizontal
  function(matches[h])
when [1, -1] || [-1, 1] # diagonal 2
  function(matches[d2])
when [0, 1] || [0, -1] # vertical
  function(matches[v])
end


return false if coords[0].nil?

row_delta
column_delta

# all this can potentially be reduced to one line if needed
current_row = @board_state[coords[0]]
starting_token = current_row[coords[1]]
row_idx =  COLUMNS.index(coords[1])
left_letter = COLUMNS[row_idx - 1]
next_item = current_row[COLUMNS[row_idx - 1]]

# left
matches = 0



until i > row_idx
  next_item = current_row[COLUMNS[row_idx - i]]
  if starting_token == left_item
    matches += 1
    return true if matches == 3
    i += 1
    next
  end
  return false
end





return false