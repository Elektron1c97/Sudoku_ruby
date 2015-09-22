module SudokuRuby

  # The Human Solver represents a human solving a sudoku
  # The technique: Find all fields which have only one possibilty and insert them -> do this until finished
  # If there's not one field with one possibilty, start with the field which has the fewest numbers available to enter and try with all these nums to solve it.
  module HumanSolver

    # Function to solve an input with the human technique (must be an ONE-DIMENSIONAL array)
    # Can raise an error if the input is too hard (explained in the Human solver desc.)
    # If unsolvable -> nil
    def self.solve(input)
      sol = PartialSolution.new(input)
      sol = sol.next until sol == :unsolvable || sol == :too_hard || sol.solution?
      case sol
      when :too_hard
        raise StandardError.new "Please use solve_no_matter_what to solve such a hard input"
      when :unsolvable
        nil
      else
        sol.to_a
      end
    end

    # Function to solve and input with the human technique
    # No matter how hard, the solver will solve the sudoku without asking
    # If unsolvable -> nil
    def self.solve_no_matter_what(input)
      sol = AdvancedPartialSolution.new(input)
      sol = sol.next until sol == :unsolvable || sol.solution?
      if sol == :unsolvable
        nil
      else
        sol.to_a
      end
    end

    # A Partial Solution represents a step in the solving process
    class PartialSolution
      def initialize(arr_to_solve, position = 0)
        @position = position
        @arr = arr_to_solve
        @board = Board.new(arr_to_solve, 9)
        @empty_fields = empty_field_indexes
        @start_point = best_move
      end

      # Function to trigger the next step, will return a new instance, old instance is not mutated
      def next
        move = best_move
        case move.last.length
        when 1
          a = @arr.map.with_index do |e, i|
            if @empty_fields.include?(i)
              free_nums = possibilities[i]
              free_nums.first if free_nums.length == 1
            else
              e
            end
          end
          return self.class.new a
        when 0
          return :unsolvable
        else
          return :too_hard
        end
      end

      # Function to find all possibilities at indexes
      def possibilities
        @possibilities ||= begin
          data = {}
          @empty_fields.each { |e| data[e] = free_nums_for_index(e) }
          data
        end
      end

      # The best move finds the field with the fewest nums to insert
      def best_move
        @best_move ||= possibilities.min_by { |_idx, nums| nums.length }
      end

      # Function to get all free nums at an index
      def free_nums_for_index(index)
        possibilities = (1..9).to_a
        possibilities -= @board.row_for_field_index(index)
        possibilities -= @board.column_for_field_index(index)
        possibilities -= @board.field_group_for_field_index(index)
        possibilities
      end

      # Function to get all indexes where nil is (every field the solver can enter something)
      def empty_field_indexes
        @arr.map.with_index { |e, i| [i, e] }.select { |e| e[1].nil? }.map { |e| e[0] }
      end

      # Function to detect if the current step is the solution
      def solution?
        board = Board.new(@arr)
        @arr.all? && board.valid?
      end

      # Function to get the solution as a plain array
      def to_a
        @arr
      end

      def ==(other)
        to_a == other.to_a if other.is_a?(self.class)
      end
    end

    # The AdvancedPartialSolution represents a smarter solution which can handle no simple start points (if there are no fields which have a clearly number to set)
    class AdvancedPartialSolution < PartialSolution

      # The next method is overwritten because the Parital Solution would say it's too hard
      def next
        case result = super
        when :too_hard
          index, available = *best_move
          a = available.map { |a| arr_cpy = @arr.dup; arr_cpy[index] = a; self.class.new(arr_cpy); } ; PartialSolutionCollection.new a
        else
          result
        end
      end
    end

    # The PartialSolutionCollection represents a list of all possibilities when the start index could not be found
    class PartialSolutionCollection
      def initialize(solutions)
        if solutions.size < 2
          raise ArgumentError, "Can not create collection without or with a single solution: #{solutions.inspect}"
        end
        @solutions = solutions
      end

      # The next method invokes a next on the current try
      # eg. you have a sudoku which is incredibly hard.
      # There's no start point which is clear (a field with just one possibility)
      # but for instance you have a field where only 2 nums are possible
      # the next method invokes next on the partial solution until it's the solution or until it's unsolvable
      # if it's unsolvable it will try the next one until it's finished
      def next
        other_guesses = @solutions[1..-1]
        case result = @solutions.first.next
        when :unsolvable
          if other_guesses.size == 1
            other_guesses.first
          else
            self.class.new other_guesses
          end
        else
          self.class.new [result] + other_guesses
        end
      end

      # Detects if the current try is the solution
      def solution?
        @solutions.first.solution?
      end

      # Get the raw output array which is the solved puzzle
      def to_a
        @solutions.first.to_a
      end

      # Function to unwrap all nested collections and get the final solution as an object
      def unwrap
        sol = @solutions.first
        if self.class === sol
          sol.unwrap
        else
          sol
        end
      end

      def ==(other)
        if other.is_a?(self.class)
          @solutions == other.instance_variable_get('@solutions')
        end
      end
    end
  end
end
