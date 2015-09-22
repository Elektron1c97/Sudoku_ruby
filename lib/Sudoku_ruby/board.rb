module SudokuRuby
  # A board represents a Sudoku board (of any length)
  # The input is stored as a onedimensional array
  class Board
    @@field_group_indexes = {}
    @@column_indexes = {}
    @@row_indexes = {}

    def initialize(input = Generator.generate_code, length = 9)
      @input = input
      @length = length.to_i
      @field_size = Math.sqrt(length).to_i
    end

    # Solve the board and get the solution
    def solve(type = HumanSolver)
      type.solve(@input)
    end

    # Solve the board by setting the solution to the current code on the board
    def solve!(type = HumanSolver)
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

    # Get a specific row
    def row(index)
      row_indexes(index).map do |e|
        @input[e]
      end
    end

    # Get the row index for a field index
    def row_index_for_field_index(index)
      (index / @length).to_i
    end

    # Get a row for a field index
    def row_for_field_index(index)
      row(row_index_for_field_index(index))
    end

    # Returns all columns of the board
    def columns
      @columns ||= begin
        column_indexes.map do |e|
          e.map do |e|
            @input[e]
          end
        end
      end
    end

    # Get a specific column
    def column(index)
      column_indexes(index).map do |e|
        @input[e]
      end
    end

    # Get the column index for a field index
    def column_index_for_field_index(index)
      index % @length
    end

    # Get a column for a field index
    def column_for_field_index(index)
      column(column_index_for_field_index(index))
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

    # Get a specific column
    def field_group(index)
      field_group_indexes(index).map do |e|
        @input[e]
      end
    end

    # Get the field group index for a field index
    # eg. 80 is passed -> you will get 8
    def field_group_index_for_field_index(index)
      r = (row_index_for_field_index(index) / @field_size).to_i * @field_size
      c = (column_index_for_field_index(index) / @field_size).to_i
      r + c
    end

    # Get a column for a field index
    def field_group_for_field_index(index)
      field_group(field_group_index_for_field_index(index))
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

    # Generates block indexes for the columns
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

    # Generates block indexes for the rows
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

    # Function to test if a number is valid (eg. in a 9x9 sudoku: 1-9)
    def valid_number?(num)
      (1..@length).freeze.include? num
    end

    # Function to get the length of the sides of the board
    def length
      @length
    end
  end
end
