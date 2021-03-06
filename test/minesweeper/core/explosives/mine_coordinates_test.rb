require 'minesweeper/core/explosives/mine_coordinates'
require_relative '../../../test_helper'

module Minesweeper
  module Core
    module Explosives
      class MineCoordinatesTest < Test::Unit::TestCase
        def test_is_initializable
          assert_nothing_raised { MineCoordinates.new(0,0) }
        end

        def test_properties_are_initialized_by_the_constructor
          mc = MineCoordinates.new(12, 17)
          assert_equal(12, mc.row_index)
          assert_equal(17, mc.col_index)
        end

        def test_immutability
          mc = MineCoordinates.new(0, 0)
          assert_raise(NoMethodError) { mc.row_index = 1 }
          assert_equal(0, mc.row_index)
          assert_raise(NoMethodError) { mc.col_index = 1 }
          assert_equal(0, mc.col_index)
        end

        def test_2_different_objects_with_same_properties_are_equal
          a = MineCoordinates.new(0, 0)
          b = MineCoordinates.new(0, 0)
          assert_equal(a, b)
          assert_true(a == b)
        end
      end
    end
  end

end

