require 'minitest_helper'

class Gate::TestResult < Minitest::Test
  def test_valid
    assert valid_result.valid?
    assert_equal attributes, valid_result.attributes
  end

  def test_invalid
    refute invalid_result.valid?
    assert_equal errors, invalid_result.errors
  end

  def valid_result
    Gate::Result.new(attributes: attributes, errors: { message: {} })
  end

  def invalid_result
    Gate::Result.new(attributes: attributes, errors: { key: :missing, nested: { text: :missing, inner: {} }, other: {} })
  end

  def attributes
    { id: 1, nested: { key: 'Value' } }
  end

  def errors
    { key: :missing, nested: { text: :missing } }
  end
end
