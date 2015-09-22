require_relative '../test_helper'
require 'timeout'

class HumanSolverTest < Minitest::Test
  include SudokuRuby::HumanSolver

  RETARD_INPUT = [1, 2, 4, 3, 5, 9, 6, 7, 8,
                  3, 6, 5, 1, 7, 8, 2, nil, 9,
                  7, 9, 8, 4, 6, 2, 1, 3, 5,
                  2, 5, 3, 6, 4, 7, 8, 9, 1,
                  4, 7, 9, 8, 1, 5, 3, 2, 6,
                  nil, 8, 1, 2, 9, 3, 7, 5, 4,
                  5, 4, 2, 7, 8, 6, 9, 1, 3,
                  8, 1, 7, 9, 3, 4, 5, 6, 2,
                  9, 3, 6, 5, 2, 1, 4, 8, 7]

  EASY_INPUT = [1, 2, nil, 4, nil, 6, 7, 8, 9,
                nil, 5, 9, 3, 7, 8, 1, 6, nil,
                6, 7, 8, nil, 1, 2, nil, 5, 3,
                2, 1, nil, 6, 3, nil, 8, 9, 4,
                3, 8, 4, 2, 9, 1, 5, nil, 6,
                7, 9, 6, 5, 8, 4, nil, 2, 1,
                nil, 3, 2, nil, nil, 9, 6, 1, nil,
                9, 4, 7, nil, nil, 5, 2, nil, 8,
                8, 6, nil, 7, nil, nil, 9, nil, 5]

  HARD_INPUT = [nil, nil, nil, 4, 5, 7, nil, nil, nil,
                nil, 5, nil, nil, nil, 9, 1, nil, nil,
                6, 8, 9, 2, nil, nil, 4, 5, nil,
                3, 4, 1, 7, nil, 6, nil, nil, nil,
                5, nil, nil, 9, nil, 1, 3, 7, nil,
                7, 9, 2, nil, nil, nil, nil, 1, 6,
                2, nil, nil, 1, nil, 4, 7, 6, 8,
                nil, 7, nil, nil, nil, 2, nil, nil, 1,
                9, 1, nil, nil, nil, nil, 5, 3, nil]

  VERY_HARD_INPUT = [nil, 1, nil, nil, 2, 6, nil, nil, 3,
                     nil, nil, nil, nil, 5, nil, nil, 2, nil,
                     3, nil, nil, nil, nil, 4, 7, nil, nil,
                     nil, 6, 7, nil, 3, nil, nil, nil, 4,
                     nil, nil, 4, 6, nil, 2, 3, nil, nil,
                     8, nil, nil, nil, 7, nil, 6, 5, nil,
                     nil, nil, 8, 5, nil, nil, nil, nil, 2,
                     nil, 7, nil, nil, 4, nil, nil, nil, nil,
                     6, nil, nil, 2, 1, nil, nil, 9, nil]

  UNSOLVABLE_INPUT = [5, 1, 6, 8, 4, 9, 7, 3, 2,
                      3, nil, 7, 6, nil, 5, nil, nil, nil,
                      8, nil, 9, 7, nil, nil, nil, 6, 5,
                      1, 3, 5, nil, 6, nil, 9, nil, 7,
                      4, 7, 2, 5, 9, 1, nil, nil, 6,
                      9, 6, 8, 3, 7, nil, nil, 5, nil,
                      2, 5, 3, 1, 8, 6, nil, 7, 4,
                      6, 8, 4, 2, nil, 7, 5, nil, nil,
                      7, 9, 1, nil, 5, nil, 6, nil, 8]

  def test_first_row
    sol = PartialSolution.new(RETARD_INPUT, 5)
    assert_equal 0, sol.current_row
  end

  def test_col_of_field_in_first_row
    sol = PartialSolution.new(RETARD_INPUT, 4)
    assert_equal 4, sol.current_col
  end

  def test_row_of_random_field
    sol = PartialSolution.new(RETARD_INPUT, 39)
    assert_equal 4, sol.current_row
  end

  def test_col_of_random_field
    sol = PartialSolution.new(RETARD_INPUT, 43)
    assert_equal 7, sol.current_col
  end

  def test_field_group_in_first_field_group
    sol = PartialSolution.new(RETARD_INPUT, 4)
    assert_equal 1, sol.current_field_group
  end

  def test_field_group_in_fourth_field_group
    sol = PartialSolution.new(RETARD_INPUT, 39)
    assert_equal 4, sol.current_field_group
  end

  def test_empty_fields_for_input_indexes
    sol = PartialSolution.new(RETARD_INPUT, 39)
    assert_equal [16, 45], sol.empty_field_indexes
  end

  def test_free_nums_for_first_empty_field
    sol = PartialSolution.new(RETARD_INPUT)
    assert_equal [4], sol.free_nums_for_current_field
  end

  def test_insert_all_with_only_one_possibility
    expected_filled = [1, nil, 3, 4, 5, 7, nil, nil, nil,
                       4, 5, nil, nil, nil, 9, 1, nil, nil,
                       6, 8, 9, 2, nil, 3, 4, 5, nil,
                       3, 4, 1, 7, nil, 6, nil, nil, nil,
                       5, 6, nil, 9, nil, 1, 3, 7, nil,
                       7, 9, 2, nil, nil, nil, 8, 1, 6,
                       2, 3, nil, 1, nil, 4, 7, 6, 8,
                       nil, 7, nil, nil, nil, 2, 9, nil, 1,
                       9, 1, nil, nil, nil, 8, 5, 3, nil]
    sol = PartialSolution.new(HARD_INPUT)
    assert_equal expected_filled, sol.next.to_a
  end

  def test_ended_solution
    retard_input_solution = [1, 2, 4, 3, 5, 9, 6, 7, 8,
                             3, 6, 5, 1, 7, 8, 2, 4, 9,
                             7, 9, 8, 4, 6, 2, 1, 3, 5,
                             2, 5, 3, 6, 4, 7, 8, 9, 1,
                             4, 7, 9, 8, 1, 5, 3, 2, 6,
                             6, 8, 1, 2, 9, 3, 7, 5, 4,
                             5, 4, 2, 7, 8, 6, 9, 1, 3,
                             8, 1, 7, 9, 3, 4, 5, 6, 2,
                             9, 3, 6, 5, 2, 1, 4, 8, 7]
    sol = PartialSolution.new(RETARD_INPUT)
    sol = sol.next until sol.solution?
    assert_equal retard_input_solution, sol.to_a
  end

  def test_solving_empty_board
    sol = AdvancedPartialSolution.new([nil] * 81)
    sol = sol.next until sol.solution?
    assert SudokuRuby::Board.new(sol.to_a).valid?
  end

  def test_collection_is_created_if_only_two_or_more_possibilites_on_every_field
    sol = AdvancedPartialSolution.new(VERY_HARD_INPUT)
    assert sol.next.is_a?(PartialSolutionCollection), "Expected PartialSolutionCollection, got: #{sol.class}"
  end

  def test_unsolvable_solution_returns_unsolvable_symbol
    data = [1, 2, 3, 4, 5, 6, 7, 8, 9] * 9
    data.pop
    sol = AdvancedPartialSolution.new(data + [nil])
    assert_equal :unsolvable, sol.next
  end

  def test_whole_solution_for_very_hard_input
    sol = AdvancedPartialSolution.new(VERY_HARD_INPUT)
    sol = sol.next until sol.solution?
    assert SudokuRuby::Board.new(sol.to_a).valid?
  end

  def test_whole_unsolvable_solution
    sol = AdvancedPartialSolution.new(UNSOLVABLE_INPUT)
    Timeout.timeout(1) do
      sol = sol.next until sol == :unsolvable
    end
  end

  def test_solve_function_should_throw_error_because_of_too_hard_input
    assert_raises StandardError do
      SudokuRuby::HumanSolver.solve(VERY_HARD_INPUT)
    end
  end

  def test_solve_function_should_return_nil_because_of_unsolvable_input
    assert_equal nil, SudokuRuby::HumanSolver.solve_no_matter_what(UNSOLVABLE_INPUT)
  end

  def test_solve_function_should_return_solved_sudoku
    hard_input_solved = [1, 2, 3, 4, 5, 7, 6, 8, 9, 4, 5, 7, 8, 6, 9, 1, 2, 3, 6, 8, 9, 2, 1, 3, 4, 5, 7, 3, 4, 1, 7, 8, 6, 2, 9, 5, 5, 6, 8, 9, 2, 1, 3, 7, 4, 7, 9, 2, 3, 4, 5, 8, 1, 6, 2, 3, 5, 1, 9, 4, 7, 6, 8, 8, 7, 6, 5, 3, 2, 9, 4, 1, 9, 1, 4, 6, 7, 8, 5, 3, 2]
    assert_equal hard_input_solved, SudokuRuby::HumanSolver.solve(HARD_INPUT)
  end

  def test_solve_function_should_return_very_hard_solved_sudoku_used_with_solve_no_matter_what_function
    very_hard_input_solved = [5, 1, 9, 7, 2, 6, 8, 4, 3, 7, 4, 6, 3, 5, 8, 9, 2, 1, 3, 8, 2, 1, 9, 4, 7, 6, 5, 1, 6, 7, 9, 3, 5, 2, 8, 4, 9, 5, 4, 6, 8, 2, 3, 1, 7, 8, 2, 3, 4, 7, 1, 6, 5, 9, 4, 9, 8, 5, 6, 3, 1, 7, 2, 2, 7, 1, 8, 4, 9, 5, 3, 6, 6, 3, 5, 2, 1, 7, 4, 9, 8]
    assert_equal very_hard_input_solved, SudokuRuby::HumanSolver.solve_no_matter_what(VERY_HARD_INPUT)
  end

end



class PartialSolutionCollectionTest < Minitest::Test
  include SudokuRuby::HumanSolver

  def test_cant_create_without_any_solutions
    assert_raises ArgumentError do
      PartialSolutionCollection.new([])
    end
  end

  def test_cant_create_with_a_single_solution
    assert_raises ArgumentError do
      PartialSolutionCollection.new([Object.new])
    end
  end

  class DummyPartialSolution
    attr_reader :next_called
    def initialize(next_solution = nil)
      @next_solution = next_solution
      @next_called = 0
    end

    def next
      @next_called += 1
      @next_solution
    end
  end

  class UnsolvablePartialSolution < DummyPartialSolution
    def next
      super
      :unsolvable
    end
  end

  def test_keep_following_current_guess_while_possible
    solutions = [current_guess = DummyPartialSolution.new(followup_guess = DummyPartialSolution.new), other_guess = DummyPartialSolution.new]
    collection = PartialSolutionCollection.new(solutions)
    next_collection = collection.next
    assert_equal PartialSolutionCollection.new([followup_guess, other_guess]), next_collection
    assert_equal 1, current_guess.next_called
    assert_equal 0, other_guess.next_called
  end

  def test_resume_with_next_guess_when_first_didnt_work_out
    solutions = [current_guess = UnsolvablePartialSolution.new, other_guess = DummyPartialSolution.new, yet_another_guess = DummyPartialSolution.new]
    collection = PartialSolutionCollection.new(solutions)
    next_collection = collection.next
    assert_equal PartialSolutionCollection.new([other_guess, yet_another_guess]), next_collection
    assert_equal 1, current_guess.next_called
    assert_equal 0, other_guess.next_called
  end

  def test_unwrap_collection_when_only_a_single_solution_is_left
    solutions = [current_guess = UnsolvablePartialSolution.new, other_guess = DummyPartialSolution.new]
    collection = PartialSolutionCollection.new(solutions)
    assert_equal other_guess, collection.next
  end

end
