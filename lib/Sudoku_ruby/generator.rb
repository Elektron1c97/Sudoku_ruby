module SudokuRuby
  # The generator represents a sudoku generator
  # Logic:
  # Place 1 to 9 (default) random in the board
  # Solve it
  # Remove elements to get the length you want
  module Generator

    # Function to generate a code
    # Returns a sudoku code (array)
    def self.generate_code(length = 9, code_length = 50)
      start = generate_start_point(length)
      solved = BacktrackBruteForceSolver.solve(start)
      if solved
        remove_items_from_code(solved, (length**2 - code_length))
      else
        generate_code(length, code_length)
      end
    end

    def self.remove_items_from_code(code, count, deleted_at = [])
      if count == 0
        code
      else
        temp_code = code.dup
        rand_index = Random.rand(temp_code.length)
        if deleted_at.include?(rand_index)
          remove_items_from_code(temp_code, count, deleted_at)
        else
          temp_code[rand_index] = nil
          deleted_at << rand_index
          remove_items_from_code(temp_code, count - 1, deleted_at)
        end
      end
    end

    def self.generate_start_point(length)
      fill_up_board((1..length).to_a, length).shuffle
    end

    def self.fill_up_board(items, length)
      items + ([nil] * (length**2 - items.length))
    end
  end
end
