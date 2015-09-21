module SudokuRuby
  # A board represents a Sudoku board (of any length)
  class Board
    @@field_group_indexes = {}
    @@column_indexes = {}
    @@row_indexes = {}
    attr_accessor :input, :length

    def initialize(input = Generator.generate_code, length = 9)
      @input = input
      @length = length.to_i
      @field_size = Math.sqrt(length).to_i
    end

    # Solve the board and get the solution
    def solve(type = BacktrackBruteForceSolver)
      type.solve(@input)
    end

    # Solve the board by setting the solution to the current code on the board
    def solve!(type = BacktrackBruteForceSolver)
      @input = type.solve(@input)
    end

    # Checks the board for its validation (Sudoku rules)
    def valid?
      (rows.all? &method(:valid_sequence?)) && (columns.all? &method(:valid_sequence?)) && (field_groups.all? &method(:valid_sequence?))
    end

    # Returns all rows of the board
    def rows
      @rows ||= begin
        row_indexes.map do |e|
          e.map do |e|
            @input[e]
          end
        end
      end
    end

    def row(index)
      row_indexes(index).map do |e|
        @input[e]
      end
    end

    # Returns all rows of the board
    def columns
      @columns ||= begin
        column_indexes.map do |e|
          e.map do |e|
            @input[e]
          end
        end
      end
    end

    def column(index)
      column_indexes(index).map do |e|
        @input[e]
      end
    end

    # Returns all field groups of the board
    def field_groups
      @field_groups ||= begin
        field_group_indexes.map do |e|
          e.map do |e|
            @input[e]
          end
        end
      end
    end

    def field_group(index)
      field_group_indexes(index).map do |e|
        @input[e]
      end
    end

    # Generates block indexes for the field groups
    def field_group_indexes(get_at = nil)
      # 9x9 -> [[0,1,2,9,10,11,18,19,20], [3,4,5,12,13,14,21,22,23], ..... ]
      @@field_group_indexes[@length] ||= begin
        base = @length / @field_size
        temp_indexes = base.times.map { |count| base.times.map { |c| count + (base * c) } }
        max_index = (length ** 2) - 1
        field_group_rows = (0..max_index).to_a.each_slice(@field_size).each_slice(@length).to_a
        indexes = field_group_rows.flat_map do |e|
          temp_indexes.map { |indexes| indexes.flat_map { |i| e[i]} }
        end
      end
      if get_at
        @@field_group_indexes[@length][get_at]
      else
        @@field_group_indexes[@length]
      end
    end

    def column_indexes(get_at = nil)
      @@column_indexes[@length] ||= begin
        @length.times.map do |count|
          @length.times.map do |inner_count|
            inner_count * @length + count
          end
        end
      end
      if get_at
        @@column_indexes[@length][get_at]
      else
        @@column_indexes[@length]
      end
    end

    def row_indexes(get_at = nil)
      @@row_indexes[@length] ||= begin
        @length.times.map do |count|
          @length.times.map do |inner_count|
            inner_count + (count * @length)
          end
        end
      end
      if get_at
        @@row_indexes[@length][get_at]
      else
        @@row_indexes[@length]
      end
    end

    # Check for a valid sequence, e.g. 9x9 sudoku a sequence can only contain one of each (1-9 uniqness) and only 1-9 is allowed
    def valid_sequence?(input)
      compacted_input = input.compact
      input_valid = compacted_input.all? &method(:valid_number?)
      input_valid && input.length == @length && compacted_input == compacted_input.uniq
    end

    def valid_number?(num)
      (1..@length).freeze.include? num
    end
  end
end
