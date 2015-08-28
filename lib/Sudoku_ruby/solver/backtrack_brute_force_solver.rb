
module BacktrackBruteForceSolver

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

class PartialSolution

  def initialize(arr_to_solve, position = 0, inserted_at = {})
    @arr = arr_to_solve
    @position = position
    @inserted_at = inserted_at
    @length = Math.sqrt(arr_to_solve.length)
    @numbers = (1..@length).to_a.freeze
  end

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
    PartialSolution.new arr, position , inserted_at
  end

  def solution?
    @position == 81
  end

  def unsolvable?
    @position.nil?
  end

  def valid_number?(number)
    @numbers.include?(number)
  end

  def changable_field_at_current_position?
    @inserted_at.key?(@position) || @arr[@position].nil?
  end

  def to_a
    @arr
  end

  def raw
    [@arr, @position, @inserted_at]
  end

  def ==(other)
    self.raw == other.raw
  end

end
