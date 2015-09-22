require_relative '../test_helper'

class SequenceTest < Minitest::Test
  def setup
    @short_board = SudokuRuby::Board.new([1, 2, 3, 4] * 4, 4)
    @default_board = SudokuRuby::Board.new([1, 2, 3, 4, 5, 6, 7, 8, 9] * 9, 9)
    @long_board = SudokuRuby::Board.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16] * 16, 16)
  end

  def test_sequence_is_valid
    assert @default_board.valid_sequence?([1, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  def test_empty_sequence_is_valid
    assert @default_board.valid_sequence?([nil] * 9)
  end

  def test_sequence_is_invalid_with_same_number_twice
    refute @default_board.valid_sequence?([1, 2, 3, 4, 5, 6, 7, 8, 8])
  end

  def test_sequence_is_invalid_with_wrong_numbers
    refute @default_board.valid_sequence?([11, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  def test_rows
    expected = [[1, 2, 3, 4, 5, 6, 7, 8, 9]] * 9
    assert_equal expected, @default_board.rows
  end

  def test_columns
    expected = [[1, 1, 1, 1, 1, 1, 1, 1, 1], [2, 2, 2, 2, 2, 2, 2, 2, 2], [3, 3, 3, 3, 3, 3, 3, 3, 3], [4, 4, 4, 4, 4, 4, 4, 4, 4], [5, 5, 5, 5, 5, 5, 5, 5, 5], [6, 6, 6, 6, 6, 6, 6, 6, 6], [7, 7, 7, 7, 7, 7, 7, 7, 7], [8, 8, 8, 8, 8, 8, 8, 8, 8], [9, 9, 9, 9, 9, 9, 9, 9, 9]]
    assert_equal expected, @default_board.columns
  end

  def test_field_groups_for_default_length
    expected = [[1, 2, 3, 1, 2, 3, 1, 2, 3], [4, 5, 6, 4, 5, 6, 4, 5, 6], [7, 8, 9, 7, 8, 9, 7, 8, 9], [1, 2, 3, 1, 2, 3, 1, 2, 3], [4, 5, 6, 4, 5, 6, 4, 5, 6], [7, 8, 9, 7, 8, 9, 7, 8, 9], [1, 2, 3, 1, 2, 3, 1, 2, 3], [4, 5, 6, 4, 5, 6, 4, 5, 6], [7, 8, 9, 7, 8, 9, 7, 8, 9]]
    input = @default_board.field_groups
    assert_equal expected, input
  end

  def test_field_groups_for_short_length
    expected = [[1, 2, 1, 2], [3, 4, 3, 4], [1, 2, 1, 2], [3, 4, 3, 4]]
    input = @short_board.field_groups
    assert_equal expected, input
  end

  def test_field_group_indexes_for_default_length
    expected = [[0, 1, 2, 9, 10, 11, 18, 19, 20], [3, 4, 5, 12, 13, 14, 21, 22, 23], [6, 7, 8, 15, 16, 17, 24, 25, 26], [27, 28, 29, 36, 37, 38, 45, 46, 47], [30, 31, 32, 39, 40, 41, 48, 49, 50], [33, 34, 35, 42, 43, 44, 51, 52, 53], [54, 55, 56, 63, 64, 65, 72, 73, 74], [57, 58, 59, 66, 67, 68, 75, 76, 77], [60, 61, 62, 69, 70, 71, 78, 79, 80]]
    assert_equal expected, @default_board.field_group_indexes
  end

  def test_exact_field_group_indexes_for_default_length
    expected = [3, 4, 5, 12, 13, 14, 21, 22, 23]
    assert_equal expected, @default_board.field_group_indexes(1)
  end

  def test_exact_row_indexes_for_default_length
    expected = [60, 61, 62, 69, 70, 71, 78, 79, 80]
    assert_equal expected, @default_board.field_group_indexes(8)
  end

  def test_exact_column_indexes_for_default_length
    expected = [54, 55, 56, 63, 64, 65, 72, 73, 74]
    assert_equal expected, @default_board.field_group_indexes(6)
  end

  def test_field_group_indexes_for_short_length
    expected = [[0, 1, 4, 5], [2, 3, 6, 7], [8, 9, 12, 13], [10, 11, 14, 15]]
    assert_equal expected, @short_board.field_group_indexes
  end

  def test_field_group_indexes_for_long_length
    expected = [[0, 1, 2, 3, 16, 17, 18, 19, 32, 33, 34, 35, 48, 49, 50, 51], [4, 5, 6, 7, 20, 21, 22, 23, 36, 37, 38, 39, 52, 53, 54, 55], [8, 9, 10, 11, 24, 25, 26, 27, 40, 41, 42, 43, 56, 57, 58, 59], [12, 13, 14, 15, 28, 29, 30, 31, 44, 45, 46, 47, 60, 61, 62, 63], [64, 65, 66, 67, 80, 81, 82, 83, 96, 97, 98, 99, 112, 113, 114, 115], [68, 69, 70, 71, 84, 85, 86, 87, 100, 101, 102, 103, 116, 117, 118, 119], [72, 73, 74, 75, 88, 89, 90, 91, 104, 105, 106, 107, 120, 121, 122, 123], [76, 77, 78, 79, 92, 93, 94, 95, 108, 109, 110, 111, 124, 125, 126, 127], [128, 129, 130, 131, 144, 145, 146, 147, 160, 161, 162, 163, 176, 177, 178, 179], [132, 133, 134, 135, 148, 149, 150, 151, 164, 165, 166, 167, 180, 181, 182, 183], [136, 137, 138, 139, 152, 153, 154, 155, 168, 169, 170, 171, 184, 185, 186, 187], [140, 141, 142, 143, 156, 157, 158, 159, 172, 173, 174, 175, 188, 189, 190, 191], [192, 193, 194, 195, 208, 209, 210, 211, 224, 225, 226, 227, 240, 241, 242, 243], [196, 197, 198, 199, 212, 213, 214, 215, 228, 229, 230, 231, 244, 245, 246, 247], [200, 201, 202, 203, 216, 217, 218, 219, 232, 233, 234, 235, 248, 249, 250, 251], [204, 205, 206, 207, 220, 221, 222, 223, 236, 237, 238, 239, 252, 253, 254, 255]]
    assert_equal expected, @long_board.field_group_indexes
  end

  def test_column_indexes_for_default_length
    expected = [[0, 9, 18, 27, 36, 45, 54, 63, 72], [1, 10, 19, 28, 37, 46, 55, 64, 73], [2, 11, 20, 29, 38, 47, 56, 65, 74], [3, 12, 21, 30, 39, 48, 57, 66, 75], [4, 13, 22, 31, 40, 49, 58, 67, 76], [5, 14, 23, 32, 41, 50, 59, 68, 77], [6, 15, 24, 33, 42, 51, 60, 69, 78], [7, 16, 25, 34, 43, 52, 61, 70, 79], [8, 17, 26, 35, 44, 53, 62, 71, 80]]
    assert_equal expected, @default_board.column_indexes
  end

  def test_row_indexes_for_default_length
    expected = [[0, 1, 2, 3, 4, 5, 6, 7, 8], [9, 10, 11, 12, 13, 14, 15, 16, 17], [18, 19, 20, 21, 22, 23, 24, 25, 26], [27, 28, 29, 30, 31, 32, 33, 34, 35], [36, 37, 38, 39, 40, 41, 42, 43, 44], [45, 46, 47, 48, 49, 50, 51, 52, 53], [54, 55, 56, 57, 58, 59, 60, 61, 62], [63, 64, 65, 66, 67, 68, 69, 70, 71], [72, 73, 74, 75, 76, 77, 78, 79, 80]]
    assert_equal expected, @default_board.row_indexes
  end

  def test_validation_of_whole_board_with_default_code
    refute @default_board.valid?
  end

  def test_validation_of_whole_board_with_valid_code
    temp_test_board = SudokuRuby::Board.new([nil] * 80 << 1, 9)
    assert temp_test_board.valid?
  end

  def test_validation_of_whole_board_with_whole_valid_code
    temp_test_board = SudokuRuby::Board.new([5, 3, 4, 6, 7, 8, 9, 1, 2, 6, 7, 2, 1, 9, 5, 3, 4, 8, 1, 9, 8, 3, 4, 2, 5, 6, 7, 8, 5, 9, 7, 6, 1, 4, 2, 3, 4, 2, 6, 8, 5, 3, 7, 9, 1, 7, 1, 3, 9, 2, 4, 8, 5, 6, 9, 6, 1, 5, 3, 7, 2, 8, 4, 2, 8, 7, 4, 1, 9, 6, 3, 5, 3, 4, 5, 2, 8, 6, 1, 7, 9], 9)
    assert temp_test_board.valid?
  end

  def test_first_row_index
    assert_equal 0, @default_board.row_index_for_field_index(0)
  end

  def test_col_index_of_field_in_first_row
    assert_equal 4, @default_board.column_index_for_field_index(4)
  end

  def test_row_index_of_random_field
    assert_equal 4, @default_board.row_index_for_field_index(39)
  end

  def test_col_index_of_random_field
    assert_equal 7, @default_board.column_index_for_field_index(43)
  end

  def test_field_group_index_in_first_field_group
    assert_equal 1, @default_board.field_group_index_for_field_index(4)
  end

  def test_field_group_index_in_fourth_field_group
    assert_equal 4, @default_board.field_group_index_for_field_index(39)
  end

  def test_field_group_for_index
    assert_equal [1,2,3,1,2,3,1,2,3], @default_board.field_group_for_field_index(10)
  end

  def test_row_for_index
    assert_equal (1..9).to_a, @default_board.row_for_field_index(4)
  end

  def test_column_for_index
    assert_equal  [4] * 9, @default_board.column_for_field_index(3)
  end
end
