require_relative '../test_helper'

class GeneratorTest < Minitest::Test
  include SudokuRuby

  def test_generate_start_point
    assert_equal (1..9).to_a, Generator.generate_start_point(9).compact.sort
  end

  def test_fill_up_board
    expected = (1..5).to_a + [nil] * 76
    assert_equal expected, Generator.fill_up_board((1..5).to_a, 9)
  end

  def test_remove_items_from_code
    generated_code = BacktrackBruteForceSolver.solve(Generator.generate_start_point(9))
    code = Generator.remove_items_from_code(generated_code, 30)
    assert_equal code.compact.length, 51
  end

  def test_generator_default_length
    code = Generator.generate_code(9, 20)
    assert_equal 20, code.compact.length
  end

  def test_generator_short_length
    code = Generator.generate_code(4, 8)
    assert_equal 8, code.compact.length
  end

end
