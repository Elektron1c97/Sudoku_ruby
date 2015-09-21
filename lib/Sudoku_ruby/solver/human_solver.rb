module SudokuRuby

  module HumanSolver

    class PartialSolution

      def initialize(arr_to_solve, position = 0)
        @position = position
        @arr = arr_to_solve
        @empty_fields = empty_field_indexes
        @start_point = find_start_index
      end

      def next
        if find_start_index.values.first.length == 1
          a = @arr.map.with_index do |e, i|
            if @empty_fields.include?(i)
              free_nums = free_nums_for_index_and_input(i, @arr)
              free_nums.first if free_nums.length == 1
            else
              e
            end
          end
          return self.class.new a
        elsif find_start_index.values.first.length == 0
          return :unsolvable
        else
          return :too_hard
        end
      end

      def find_start_index
        @empty_fields.map { |e| { e => free_nums_for_index_and_input(e, @arr) } }.sort { |x, y| x.values.first.length <=> y.values.first.length}.first
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
        if other.is_a?(self.class)
          to_a == other.to_a
        end
      end

    end

    class AdvancedPartialSolution < PartialSolution
      def next
        case result = super
        when :too_hard
          a = find_start_index.flat_map do |index, available|
            available.map do |a|
              arr_cpy = @arr.dup
              arr_cpy[index] = a
              self.class.new arr_cpy
            end
          end
          PartialSolutionCollection.new a
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

      def ==(other)
        if other.is_a?(self.class)
          @solutions == other.instance_variable_get("@solutions")
        end
      end
    end

  end
end
