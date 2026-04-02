module UI
  COLUMNS = %w[a b c d e f g].freeze

  module GameUI
    include UI

    RESET = "\e[0m".freeze
    BOLD = "\e[1m".freeze
    DIM = "\e[2m".freeze

    # ANSI 31 = red, 34 = blue
    DISC_RED = "\e[31m●#{RESET}".freeze
    DISC_BLUE = "\e[34m●#{RESET}".freeze

    def get_input(prompt)
      print prompt
      gets.chomp
    end

    def validate_input(prompt, truth_eval, invalid_input)
      input = get_input(prompt)

      until truth_eval.(input)
        puts "#{DIM}Invalid: #{invalid_input}#{RESET}"
        input = get_input(prompt)
      end
      input
    end

    def clear
      system('clear')
    end

    def print_banner
      puts
      puts "  #{BOLD}╔═══════════════════════════╗#{RESET}"
      puts "  #{BOLD}║     CONNECT  FOUR         ║#{RESET}"
      puts "  #{BOLD}╚═══════════════════════════╝#{RESET}"
      puts
    end

    def display_board(board_state, status: nil)
      puts "  #{DIM}#{status}#{RESET}" if status
      puts
      puts "  ┌───┬───┬───┬───┬───┬───┬───┐"
      board_state.reverse_each.with_index do |row, i|
        cells = row.values.map do |v|
          case v
          when 'empty'
            ' '
          when 'red'
            DISC_RED
          when 'blue'
            DISC_BLUE
          end
        end.join(' ┃ ')
        puts "  ┃ #{cells} ┃"
        puts "  ├───┼───┼───┼───┼───┼───┼───┤" unless i == 5
      end
      puts "  └───┴───┴───┴───┴───┴───┴───┘"
      puts "    #{DIM}a   b   c   d   e   f   g#{RESET}"
      puts
    end

    def display_game_over(outcome)
      puts
      case outcome
      when :draw
        puts "  #{BOLD}Cat's game#{RESET} — #{DIM}board full, no winner.#{RESET}"
      when :red
        puts "  #{BOLD}#{DISC_RED} Red wins!#{RESET}"
      when :blue
        puts "  #{BOLD}#{DISC_BLUE} Blue wins!#{RESET}"
      end
      puts
    end
  end
end
