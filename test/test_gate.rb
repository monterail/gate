require "test_helper"

class TestGate < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Gate::VERSION
  end
end
