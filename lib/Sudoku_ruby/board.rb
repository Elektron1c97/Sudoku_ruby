module SudokuRuby
  # A board represents a Sudoku board (of any length)
  class Board
    attr_accessor :input, :length

    def initialize(input = Generator.generate_code, length = 9)
      @input = input
      @length = length.to_i
      @field_size = Math.sqrt(length).to_i
    end

    # Checks the board for its validation (Sudoku rules)
    def valid?
      (rows.all? &method(:valid_sequence?)) && (columns.all? &method(:valid_sequence?)) && (field_groups.all? &method(:valid_sequence?))
    end

    # Returns all rows of the board
    def rows
      @input.each_slice(@length).to_a
    end

    # Returns all rows of the board
    def columns
      rows.map.with_index do |_row, index|
        rows.map { |r| r[index] }
      end
    end

    # Returns all field groups of the board
    def field_groups
      slices = @input.each_slice(@field_size).each_slice(@length).to_a
      block_indexes = generate_block_indexes
      slices.flat_map do |e|
        block_indexes.map { |indexes| indexes.flat_map { |i| e[i] } }
      end
    end

    # Generates block indexes for the field groups
    def generate_block_indexes
      # [[0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15]] <- 16x16
      # [[0, 3, 6], [1, 4, 7], [2, 5, 8]] <- 9x9
      # [[0, 2], [1, 3]] <- 4x4
      base = @length / @field_size
      base.times.map { |count| base.times.map { |c| count + (base * c) } }
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
