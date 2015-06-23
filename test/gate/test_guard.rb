require 'minitest_helper'

class Gate::TestGuard < Minitest::Test
  def configuration
    @configuration ||= Gate::Configuration.new do
      required :id, :Integer
      required :message do
        required :subject
        optional :value, :Decimal
      end
      optional :nested do
        required :value
      end
    end
  end

  def guard
    @guard ||= Gate::Guard.new(configuration)
  end

  def test_valid_full_input
    input = {
      id: '1',
      message: {
        subject: 'Title',
        value: '12.50'
      },
      nested: {
        value: 'ok'
      },
      additional: {
        ignore: 'true'
      }
    }
    expected = {
      id: 1,
      message: {
        subject: 'Title',
        value: BigDecimal.new('12.50')
      },
      nested: {
        value: 'ok'
      }
    }

    result = guard.verify(input)
    assert result.valid?, "Expected #{mu_pp(result)} to be valid"
    assert_equal expected, result.attributes
  end

  def test_valid_short_input
    input = {
      id: '1',
      message: {
        subject: 'Title'
      }
    }
    expected = {
      id: 1,
      message: {
        subject: 'Title'
      }
    }

    result = guard.verify(input)
    assert result.valid?, "Expected #{mu_pp(result)} to be valid"
    assert_equal expected, result.attributes
  end

  def test_missing_nested_required
    input = {
      id: '1',
      message: {
        subject: 'Title',
        value: '12.50'
      },
      nested: {
      }
    }
    expected = {
      nested: {
        value: :missing
      }
    }

    result = guard.verify(input)
    refute result.valid?, "Expected #{mu_pp(result)} to be invalid"
    assert_equal expected, result.errors
  end
end
