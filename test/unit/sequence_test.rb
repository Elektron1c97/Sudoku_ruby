require_relative '../test_helper'

class SequenceTest < Minitest::Test

  def setup
    # 6, 7
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

  def test_block_indexes_for_default_length
    expected = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
    assert_equal expected, @default_board.generate_block_indexes
  end

  def test_block_indexes_for_short_length
    expected = [[0, 2], [1, 3]]
    assert_equal expected, @short_board.generate_block_indexes
  end

  def test_block_indexes_for_long_length
    expected = [[0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15]]
    assert_equal expected, @long_board.generate_block_indexes
  end

  def test_validation_of_whole_board_with_default_code
    refute @default_board.valid?
  end

  def test_validation_of_whole_board_with_valid_code
    temp_test_board = SudokuRuby::Board.new([nil] * 80 << 1, 9)
    assert temp_test_board.valid?
  end

  def test_validation_of_whole_board_with_whole_valid_code
    temp_test_board = SudokuRuby::Board.new([5,3,4,6,7,8,9,1,2,6,7,2,1,9,5,3,4,8,1,9,8,3,4,2,5,6,7,8,5,9,7,6,1,4,2,3,4,2,6,8,5,3,7,9,1,7,1,3,9,2,4,8,5,6,9,6,1,5,3,7,2,8,4,2,8,7,4,1,9,6,3,5,3,4,5,2,8,6,1,7,9], 9)
    assert temp_test_board.valid?
  end
end
