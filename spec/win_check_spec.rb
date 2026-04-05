# frozen_string_literal: true

require_relative 'spec_helper'

describe WinCheck do
  def row(chars)
    UI::COLUMNS.zip(chars.chars.map { |ch| cell_token(ch) }).to_h
  end

  def cell_token(ch)
    case ch
    when 'e' then 'empty'
    when 'r' then 'red'
    when 'b' then 'blue'
    else
      raise ArgumentError, "unknown cell char: #{ch.inspect}"
    end
  end

  # rows listed bottom row first (row index 0)
  def board(*rows_bottom_to_top)
    rows_bottom_to_top.map { |s| row(s) }
  end

  describe '#iterate_through_deltas' do
    context 'when the placed cell is empty' do
      it 'returns false' do
        b = board(
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [0, 'd']).iterate_through_deltas).to be false
      end
    end

    context 'when a single disc is on the board and is not four in a row' do
      it 'returns false' do
        b = board(
          'eeereee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [0, 'd']).iterate_through_deltas).to be false
      end
    end

    context 'when there are four in a row horizontally' do
      it 'returns true' do
        b = board(
          'rrrreee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [0, 'd']).iterate_through_deltas).to be true
      end
    end

    context 'when there are four stacked in a column' do
      it 'returns true' do
        b = board(
          'reeeeee',
          'reeeeee',
          'reeeeee',
          'reeeeee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [3, 'a']).iterate_through_deltas).to be true
      end
    end

    context 'when there are four on a / diagonal' do
      it 'returns true' do
        b = board(
          'reeeeee',
          'ereeeee',
          'eereeee',
          'eeereee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [3, 'd']).iterate_through_deltas).to be true
      end
    end

    context 'when there are four on a \\ diagonal' do
      it 'returns true' do
        b = board(
          'eeeeeer',
          'eeeeere',
          'eeeeree',
          'eeereee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [3, 'd']).iterate_through_deltas).to be true
      end
    end

    context 'when there are only three in a row horizontally' do
      it 'returns false' do
        b = board(
          'rrreeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [0, 'c']).iterate_through_deltas).to be false
      end
    end

    context 'when there are only three on a diagonal' do
      it 'returns false' do
        b = board(
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eereeee',
          'ereeeee',
          'reeeeee'
        )
        expect(described_class.new(b, [2, 'c']).iterate_through_deltas).to be false
      end
    end

    context 'when the longest run is broken by the opposite color' do
      it 'returns false' do
        b = board(
          'rrrbrrr',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee',
          'eeeeeee'
        )
        expect(described_class.new(b, [0, 'c']).iterate_through_deltas).to be false
      end
    end
  end
end
