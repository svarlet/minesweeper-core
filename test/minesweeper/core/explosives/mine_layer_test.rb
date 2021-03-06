require_relative '../../../test_helper'
require 'minesweeper/core/explosives/mine_layer'
require 'minesweeper/core/minefield'
require 'minesweeper/core/explosives/mine_coordinates_factory'

module Minesweeper
  module Core
    module Explosives
      class MineLayerTest < Test::Unit::TestCase
        MINEFIELD_SIZE = 19

        def setup
          @minefield = MinefieldSpy.new(MINEFIELD_SIZE)
          @mine_generator = MineGeneratorSpy.new
          @sut = MineLayer.new(@minefield, @mine_generator)
        end

        def test_initialize_requires_a_minefield_and_a_mine_factory
          assert_raise(ArgumentError) { MineLayer.new(Object.new, nil)}
          assert_raise(ArgumentError) { MineLayer.new(nil, Object.new)}
          assert_raise(ArgumentError) { MineLayer.new(nil, nil)}
          assert_nothing_raised { MineLayer.new(@minefield, MineCoordinatesFactory.new(Random.new)) }
        end

        def test_lay_1_should_generate_1_mine_within_the_minefield_bounds
          @sut.lay 1
          assert_equal(MINEFIELD_SIZE, @mine_generator.create_call_params.pop)
        end

        def test_lay_2_should_generate_2_mines_within_the_minefield_bounds
          @sut.lay 2
          2.times { assert_equal(MINEFIELD_SIZE, @mine_generator.create_call_params.pop) }
        end

        def test_lay_1_should_lay_a_single_mine_at_random_coordinates
          @sut.lay 1
          assert_generated_mines_were_laid(1)
        end

        def assert_generated_mines_were_laid(quantity)
          assert_equal(quantity, @mine_generator.generated_mines.length)
          assert_equal(quantity, @minefield.mines_laid.length)
          quantity.times { assert_equal(@mine_generator.generated_mines.pop, @minefield.mines_laid.pop) }
        end

        def test_lay_2_mines_should_lay_exactly_2_mines_at_random_coordinates
          @sut.lay 2
          assert_generated_mines_were_laid(2)
        end

        def test_lay_should_never_lay_2_mine_at_the_same_coordinates
          a_mine = MineCoordinates.new(1, 1)
          same_mine = MineCoordinates.new(1, 1)
          different_mine = MineCoordinates.new(1, 2)
          dummy_mine_generator = DummyMineGenerator.new([a_mine, same_mine, different_mine])
          sut = MineLayer.new(@minefield, dummy_mine_generator)

          sut.lay(2)

          assert_equal(@minefield.mines_laid, [a_mine, different_mine])
        end
      end

      class MinefieldSpy
        attr_reader :mines_laid
        attr_reader :row_count

        def initialize(row_count)
          @mines_laid = []
          @row_count = row_count
        end

        def hide_mine_at(x, y)
          @mines_laid << MineCoordinates.new(x, y)
        end
      end

      class MineGeneratorSpy < MineCoordinatesFactory
        attr_reader :generated_mines
        attr_reader :create_call_params

        def initialize
          super Random.new
          @generated_mines = []
          @create_call_params = []
        end

        def create(max)
          @create_call_params << max
          a_mine = super(max)
          @generated_mines << a_mine
          a_mine
        end
      end

      class DummyMineGenerator < MineCoordinatesFactory
        def initialize(preconstructed_mines)
          @preconstructed_mines = preconstructed_mines
        end

        def create(max)
          @preconstructed_mines.shift
        end
      end
    end
  end

end

