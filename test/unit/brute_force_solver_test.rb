require_relative '../test_helper'

class BruteForceSolverTest < Minitest::Test
  include SudokuRuby

  def make_board(*items)
    items + ([nil] * (81 - items.length))
  end

  def test_solve_full_board
    assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9,
                  4, 5, 6, 7, 8, 9, 1, 2, 3,
                  7, 8, 9, 1, 2, 3, 4, 5, 6,
                  2, 1, 4, 3, 6, 5, 8, 9, 7,
                  3, 6, 5, 8, 9, 7, 2, 1, 4,
                  8, 9, 7, 2, 1, 4, 3, 6, 5,
                  5, 3, 1, 6, 4, 2, 9, 7, 8,
                  6, 4, 2, 9, 7, 8, 5, 3, 1,
                  9, 7, 8, 5, 3, 1, 6, 4, 2], BacktrackBruteForceSolver.solve(make_board)
  end

  def test_solve_unsolvable_input
    input = [5, 1, 6, 8, 4, 9, 7, 3, 2,
             3, nil, 7, 6, nil, 5, nil, nil, nil,
             8, nil, 9, 7, nil, nil, nil, 6, 5,
             1, 3, 5, nil, 6, nil, 9, nil, 7,
             4, 7, 2, 5, 9, 1, nil, nil, 6,
             9, 6, 8, 3, 7, nil, nil, 5, nil,
             2, 5, 3, 1, 8, 6, nil, 7, 4,
             6, 8, 4, 2, nil, 7, 5, nil, nil,
             7, 9, 1, nil, 5, nil, 6, nil, 8]
    refute BacktrackBruteForceSolver.solve(input)
  end

  def test_solve_with_empty
    sol = PartialSolution.new make_board, 0
    assert_equal [make_board(1), 1, { 0 => 0 }], sol.next.raw
  end

  def test_solve_only_increases_position_when_current_field_is_filled
    sol = PartialSolution.new make_board(1, 2), 0
    assert_equal [make_board(1, 2), 1, {}], sol.next.raw
  end

  def test_solve_with_non_empty_leading_fields
    sol = PartialSolution.new make_board(1, 2, 3), 3
    assert_equal [make_board(1, 2, 3, 1), 3, { 3 => 0 }], sol.next.raw
  end

  def test_solve_increase_digit_while_board_is_invalid
    sol = PartialSolution.new make_board(1, 2, 3, 3), 3, { 3 => 2 }
    assert_equal [make_board(1, 2, 3, 4), 4, { 3 => 3 }], sol.next.raw
  end

  def test_solve_backtrack_when_no_solution_is_possible
    input_board = make_board(1, 2, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 1, 2, 3, 9)
    output_board = make_board(1, 2, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 1, 2, 3)
    sol = PartialSolution.new make_board(1, 2, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 1, 2, 3), 15, 14 => 2, 15 => 8
    assert_equal [output_board, 14, { 14 => 2 }], sol.next.raw
  end

  def test_solve_next_is_not_mutated
    sol = PartialSolution.new make_board
    origin_sol = sol.dup
    next_solution = sol.next
    assert_equal next_solution, sol.next
    assert_equal origin_sol, sol
  end

  def test_solve_next_method_chaining
    expected = [[1, 2, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil, nil], 2, {0=>0, 1=>1}]
    sol = PartialSolution.new make_board
    assert_equal expected, sol.next.next.next.raw
  end

end
