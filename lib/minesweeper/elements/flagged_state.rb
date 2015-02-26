require_relative 'cell_state'

module Minesweeper
  module Elements
    class FlaggedState < CellState
      def reveal
        @cell.current_state = @cell.revealed_state
        @cell.trigger
      end

      def unflag
        @cell.current_state = @cell.hidden_state
      end

      def to_s
        "F"
      end
    end
  end
end