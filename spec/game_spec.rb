# frozen_string_literal: true

require_relative 'spec_helper'

describe Game do
  describe '#board_full?' do
    context 'when at least one cell is empty' do
      it 'returns false' do
        game = described_class.new
        expect(game.board_full?).to be false
      end
    end

    context 'when every cell is occupied' do
      it 'returns true' do
        game = described_class.new
        game.board_state.each do |row|
          row.each_key { |k| row[k] = 'red' }
        end
        expect(game.board_full?).to be true
      end
    end
  end

  describe '#toggle_turn' do
    context 'when red is to move' do
      it 'flips to blue' do
        game = described_class.new
        expect { game.toggle_turn }.to change { game.instance_variable_get(:@turn_toggle) }.from(true).to(false)
      end
    end

    context 'when blue is to move' do
      it 'flips to red' do
        game = described_class.new
        game.toggle_turn
        expect { game.toggle_turn }.to change { game.instance_variable_get(:@turn_toggle) }.from(false).to(true)
      end
    end
  end

  describe '#update_state' do
    context "when it is red's turn" do
      it 'places red in the lowest empty row for the column' do
        game = described_class.new
        row = game.update_state('d')
        expect(row).to eq(0)
        expect(game.board_state[0]['d']).to eq('red')
      end
    end

    context "when it is blue's turn" do
      it 'places blue in the lowest empty row for the column' do
        game = described_class.new
        game.toggle_turn
        game.update_state('a')
        expect(game.board_state[0]['a']).to eq('blue')
      end
    end

    context 'when the same column receives a second disc' do
      it 'stacks the new disc above the first' do
        game = described_class.new
        game.update_state('c')
        game.toggle_turn
        game.update_state('c')
        expect(game.board_state[0]['c']).to eq('red')
        expect(game.board_state[1]['c']).to eq('blue')
      end
    end
  end

  describe '#get_column_input' do
    before { allow($stdout).to receive(:puts) }

    context 'when the first input is a valid column' do
      it 'returns that column letter' do
        game = described_class.new
        allow(game).to receive(:get_input).and_return('e')
        expect(game.get_column_input).to eq('e')
      end
    end

    context 'when invalid letters are entered before a valid one' do
      it 're-prompts until a letter in a–g is given' do
        game = described_class.new
        allow(game).to receive(:get_input).and_return('z', 'x', 'b')
        expect(game.get_column_input).to eq('b')
      end
    end

    context 'when the first choice is a full column' do
      it 're-prompts until a non-full column is chosen' do
        game = described_class.new
        game.board_state.each { |row| row['f'] = 'red' }
        allow(game).to receive(:get_input).and_return('f', 'g')
        expect(game.get_column_input).to eq('g')
      end
    end
  end

  describe '#place_token' do
    context 'when a column is selected' do
      it 'returns the row index and column letter' do
        game = described_class.new
        allow(game).to receive(:get_column_input).and_return('b')
        expect(game.place_token).to eq([0, 'b'])
      end
    end
  end

  describe '#take_turn' do
    context 'when a token is placed' do
      it 'returns the placement coordinates' do
        game = described_class.new
        allow(game).to receive(:render_turn)
        allow(game).to receive(:get_column_input).and_return('a')
        expect(game.take_turn).to eq([0, 'a'])
      end
    end

    context 'after the token is placed' do
      it 'toggles to the other player' do
        game = described_class.new
        allow(game).to receive(:render_turn)
        allow(game).to receive(:get_column_input).and_return('a')
        expect { game.take_turn }.to change { game.instance_variable_get(:@turn_toggle) }.from(true).to(false)
      end
    end
  end

  describe '#game_loop' do
    context 'when the first completed turn is a winning position' do
      it 'returns those coords' do
        game = described_class.new
        coords = [5, 'd']
        allow(game).to receive(:take_turn).and_return(coords)
        allow(game).to receive(:win?).with([]).and_return(false)
        allow(game).to receive(:win?).with(coords).and_return(true)
        allow(game).to receive(:board_full?).and_return(false)
        expect(game.game_loop).to eq(coords)
      end
    end

    context 'when the board becomes full without a win' do
      it 'returns the coords from the last turn' do
        game = described_class.new
        last = [0, 'a']
        allow(game).to receive(:take_turn).and_return(last)
        allow(game).to receive(:win?).with([]).and_return(false)
        allow(game).to receive(:win?).with(last).and_return(false)
        allow(game).to receive(:board_full?).and_return(false, true)
        expect(game.game_loop).to eq(last)
      end
    end

    context 'when several turns pass before a win' do
      it 'returns the winning turn coords' do
        game = described_class.new
        allow(game).to receive(:take_turn).and_return([0, 'a'], [1, 'b'])
        allow(game).to receive(:win?).with([]).and_return(false)
        allow(game).to receive(:win?).with([0, 'a']).and_return(false)
        allow(game).to receive(:win?).with([1, 'b']).and_return(true)
        allow(game).to receive(:board_full?).and_return(false)
        expect(game.game_loop).to eq([1, 'b'])
      end
    end
  end
end
