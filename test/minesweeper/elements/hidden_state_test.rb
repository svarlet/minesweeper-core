require 'test/unit'
require 'minesweeper/elements/cell'
require 'minesweeper/elements/cell_state_error'
require 'minesweeper/elements/flagged_state'
require 'minesweeper/elements/revealed_state'
require_relative '../explosives/mine_spy'

module Minesweeper
  module Elements
    class HiddenStateTest < Test::Unit::TestCase
      def setup
        @mine_spy = Minesweeper::Explosives::MineSpy.new
        @cell = Cell.new(@mine_spy)
      end

      def test_unflag_should_raise_cell_state_error
        assert_raise(CellStateError) { @cell.unflag }
      end

      def test_flag_should_change_state_of_cell_to_flagged
        @cell.flag
        assert_instance_of(FlaggedState, @cell.current_state)
      end

      def test_reveal_should_change_state_of_cell_to_revealed
        @cell.reveal
        assert_instance_of(RevealedState, @cell.current_state)
      end

      def test_reveal_should_trigger_the_underlying_mine
        @cell.reveal
        assert(@mine_spy.trigger_called)
      end

      def test_to_s_should_return_H
        assert_equal("H", @cell.to_s)
      end
    end
  end
end