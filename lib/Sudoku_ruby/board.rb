module SudokuRuby
  class Board

    attr_accessor :input, :length

    def initialize(input, length)
      @input = input
      @length = length.to_i
      @field_size = Math.sqrt(length).to_i
    end

    def valid?
        (rows.all? &method(:valid_sequence?)) && (columns.all? &method(:valid_sequence?)) && (field_groups.all? &method(:valid_sequence?))
    end

    def rows
      @input.each_slice(@length).to_a
    end

    def columns
      rows.map.with_index do |_row, index|
        rows.map { |r| r[index] }
      end
    end

    def field_groups
      slices = @input.each_slice(@field_size).each_slice(@length).to_a
      block_indexes = generate_block_indexes
      slices.flat_map do |e|
        block_indexes.map { |indexes| indexes.flat_map { |i| e[i] } }
      end
    end

    def generate_block_indexes
      # [[0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15]] <- 16x16
      # [[0, 3, 6], [1, 4, 7], [2, 5, 8]] <- 9x9
      # [[0, 2], [1, 3]] <- 4x4
      base = @length / @field_size
      base.times.map { |count| base.times.map { |c| count + (base * c) } }
    end

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
