
module SudokuRuby

  # The backtrack brute force solver is an intelligent brute force solver which tries
  # each of the fields by inputting a value and if it's not possible to insert it, it inserts the next.
  # If there's no number to insert it will go back to the last one inserted and retries the next number
  module BacktrackBruteForceSolver

    # Function to solve an sudoku code (array)
    # returns the solved as an array of if there's no solution -> nil
    def self.solve(input)
      sol = PartialSolution.new(input)
      sol = sol.next until sol.solution? || sol.unsolvable?
      if sol.to_a.include?(nil)
        nil
      else
        sol.to_a
      end
    end
  end

  # The partial solution represents one step of the backtrackbruteforcesolver
  class PartialSolution
    def initialize(arr_to_solve, position = 0, inserted_at = {})
      @arr = arr_to_solve
      @position = position
      @inserted_at = inserted_at
      @length = Math.sqrt(arr_to_solve.length).to_i
      @numbers = (1..@length).to_a.freeze
    end

    # Function to call the next step when solving
    def next
      arr = @arr.dup
      if changable_field_at_current_position?
        number_index = if @inserted_at.key?(@position)
                         @inserted_at[@position] + 1
                       else
                         0
                    end
        if valid_number?(@numbers[number_index]) # if a number can be inserted
          arr[@position] = @numbers[number_index]
          inserted_at = @inserted_at.merge(@position => number_index)
          temp_test_board = SudokuRuby::Board.new(arr, @length)
          if temp_test_board.valid?
            return build_next_partial_solution arr, @position + 1, inserted_at
          else
            return build_next_partial_solution arr, @position, inserted_at
          end
        else
          # Backtracking
          arr[@position] = nil
          inserted_at = @inserted_at.reject { |k, _v| k == @inserted_at.keys.last }
          return build_next_partial_solution arr, inserted_at.keys.last, inserted_at
        end
      else
        return build_next_partial_solution arr, @position + 1, @inserted_at
      end
    end

    def build_next_partial_solution(arr, position, inserted_at)
      PartialSolution.new arr, position, inserted_at
    end

    # Function to detect if the current step is the solution
    def solution?
      @position == @length**2
    end

    # Function to derminate if the sudoku is unsolvable
    def unsolvable?
      @position.nil?
    end

    # Check if a number is valid, e.g. 9x9 sudoku -> 1-9
    def valid_number?(number)
      @numbers.include?(number)
    end

    # Function to check if current field is changeable
    def changable_field_at_current_position?
      @inserted_at.key?(@position) || @arr[@position].nil?
    end

    # Get the output (array) which is the solution
    def to_a
      @arr
    end

    def raw
      [@arr, @position, @inserted_at]
    end

    def ==(other)
      raw == other.raw
    end
  end
end
