require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

def prompt(msg)
  puts "=> #{msg}"
end

def display_board(brd)
  system 'clear'
  puts "Best out of 5 wins player"
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "     |     |"
  puts " #{brd[1]}   |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts " #{brd[4]}   |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts " #{brd[7]}   |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select do |num|
    brd[num] == INITIAL_MARKER
  end
end

def joinor(arr, delimiter=', ', word='or')
  case arr.length
  when 0 then ''
  when 1 then arr.first.to_s
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice"
  end

  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  # detects if two player marks are next to each other
  if board.values_at(*line).count(marker) == 2
    board.select{ |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  else
    nil
  end
end

def computer_places_piece!(brd)
  square = nil
  # offense first
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end
  # defense
  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, brd, PLAYER_MARKER)
      break if square
    end
  end
  # pick sq 5
  if !square
    if brd[5].include?(INITIAL_MARKER)
      square = 5
    else
      nil
    end
  end
  #random
  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd) # forcibly turns whatever value is here into a boolean
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd[line[0]] == PLAYER_MARKER &&
       brd[line[1]] == PLAYER_MARKER &&
       brd[line[2]] == PLAYER_MARKER
      return 'Player'
    elsif brd[line[0]] == COMPUTER_MARKER &&
          brd[line[1]] == COMPUTER_MARKER &&
          brd[line[2]] == COMPUTER_MARKER
      return 'Computer'
    end
  end
  nil
end

def who_goes_first
  # ask the player who should play first
  # caputer the answer in a variable
  # build another method
  prompt "Who should begin the game? (p for player, c for computer "
  first_move = gets.chomp
end

loop do
  player_win_count = 0
  computer_win_count = 0
  tie = 0

  loop do
    board = initialize_board

    prompt "#{player_win_count}/5"
    prompt "#{computer_win_count}/5"
    prompt "#{tie}"

    loop do
      display_board(board)
      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)

      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won!"
    else
      prompt "It's a tie"
    end

    case detect_winner(board)
    when 'Player' then player_win_count += 1
    when 'Computer' then computer_win_count += 1
    else
      tie += 1
    end

    prompt "Player: #{player_win_count}/5"
    prompt "Computer: #{computer_win_count}/5"
    prompt "Ties: #{tie}"

    break if player_win_count == 5 || computer_win_count == 5
  end

  prompt '***** Player is the grand winner! *****' if player_win_count == 5
  prompt '***** Computer is the grand winner! *****' if computer_win_count == 5

  prompt 'Play again? (y or n)'
  answer = gets.chomp

  break if answer.downcase.include?('n')
end


prompt 'Goodbye'
