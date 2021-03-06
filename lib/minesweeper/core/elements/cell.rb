require_relative 'cell_state'

module Minesweeper
  module Core
    module Elements
      class Cell
        # STATES
        # ---------------------------------------------------------
        # CURRENT	|	ACTION 	|	STATES			|	ACTION
        # ---------------------------------------------------------
        # hidden	|	reveal	|	revealed 		|	trigger
        # hidden	|	flag 	  |	flagged			|
        # flagged	|	reveal	|	revealed		|	trigger
        # flagged	|	unflag	|	hidden			|
        # ---------------------------------------------------------

        attr_accessor :current_state
        attr_accessor :mines_around

        def initialize(mine, mines_around = 0)
          @current_state = CellState::HIDDEN_STATE
          @mine = mine
          @mines_around = mines_around
        end

        def flag
          current_state.flag(self)
        end

        def reveal
          current_state.reveal(self)
        end

        def unflag
          current_state.unflag(self)
        end

        def to_s
          @current_state == CellState::REVEALED_STATE ? @mines_around.to_s : @current_state.to_s
        end

        def trigger
          @mine.trigger
        end

        def revealed?
          @current_state == CellState::REVEALED_STATE
        end

        def flagged?
          @current_state == CellState::FLAGGED_STATE
        end
      end
    end
  end
end

