require "test_helper"


class Transbank::SdkTest < Minitest::Test
  def test_that_it_has_a_version_number
    assert_equal ::Transbank::Sdk::VERSION, "0.1.0"
  end

  def test_it_does_something_useful
    assert true
  end
end
