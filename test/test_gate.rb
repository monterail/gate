require "minitest_helper"

class TestGate < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Gate::VERSION
  end

  def test_rules
    rules = Gate.rules do
      required :example
    end

    assert_kind_of Gate::Guard, rules
  end
end
