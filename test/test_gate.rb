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

  def test_all_features
    rules = Gate.rules do
      required :id, :Integer
      required :number, :Integer
      required :enabled, :Boolean
      required :default
      optional :value, allow_nil: true
      required :complex, allow_nil: true do
        optional :blank, :Boolean, allow_nil: true
      end
      required :data, :Any
      optional :address, :Any
      optional :child, :Any, allow_nil: true
    end

    input = {
      id: "1",
      number: 2,
      enabled: true,
      default: "text",
      value: nil,
      complex: nil,
      data: 'text',
      address: { street: 'Abc', city: 'Cba' },
      child: true
    }

    expected = {
      id: 1,
      number: 2,
      enabled: true,
      default: "text",
      value: nil,
      complex: nil,
      data: 'text',
      address: { street: 'Abc', city: 'Cba' },
      child: true
    }

    result = rules.verify(input)

    assert result.valid?, "Expected to be valid"
    assert_equal expected, result.attributes
  end
end
