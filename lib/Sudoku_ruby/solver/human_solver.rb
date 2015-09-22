module SudokuRuby

  module HumanSolver

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

    def self.solve_no_matter_what(input)
      sol = AdvancedPartialSolution.new(input)
      sol = sol.next until sol == :unsolvable || sol.solution?
      if sol == :unsolvable
        nil
      else
        sol.to_a
      end
    end

    class PartialSolution
      def initialize(arr_to_solve, position = 0)
        @position = position
        @arr = arr_to_solve
        @empty_fields = empty_field_indexes
        @start_point = best_move
      end

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

      def possibilities
        @possibilities ||= begin
          data = {}
          @empty_fields.each { |e| data[e] = free_nums_for_index_and_input(e, @arr) }
          data
        end
      end

      def best_move
        @best_move ||= possibilities.min_by { |_idx, nums| nums.length }
      end

      def free_nums_for_index_and_input(index, input)
        b = Board.new(input, 9)
        possibilities = (1..9).to_a
        possibilities -= b.row(row_for_index(index))
        possibilities -= b.column(col_for_index(index))
        possibilities -= b.field_group(field_group_for_index(index))
        possibilities
      end

      def free_nums_for_current_field
        free_nums_for_index_and_input(@empty_fields[@position], @arr)
      end

      def empty_field_indexes
        @arr.map.with_index { |e, i| [i, e] }.select { |e| e[1].nil? }.map { |e| e[0] }
      end

      def current_row
        row_for_index(@position)
      end

      def current_col
        col_for_index(@position)
      end

      def current_field_group
        field_group_for_index(@position)
      end

      def row_for_index(index)
        (index / 9).to_i
      end

      def col_for_index(index)
        index % 9
      end

      def field_group_for_index(index)
        r = (row_for_index(index) / 3).to_i * 3
        c = (col_for_index(index) / 3).to_i
        r + c
      end

      # Function to detect if the current step is the solution
      def solution?
        board = Board.new(@arr)
        @arr.all? && board.valid?
      end

      def count(obj)
        @arr.count(obj)
      end

      def to_a
        @arr
      end

      def ==(other)
        to_a == other.to_a if other.is_a?(self.class)
      end
    end

    class AdvancedPartialSolution < PartialSolution
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

    class PartialSolutionCollection
      def initialize(solutions)
        if solutions.size < 2
          raise ArgumentError, "Can not create collection without or with a single solution: #{solutions.inspect}"
        end
        @solutions = solutions
      end

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

      def solution?
        @solutions.first.solution?
      end

      def to_a
        @solutions.first.to_a
      end

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
