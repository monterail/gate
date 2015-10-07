require "minitest_helper"

module Gate
  class TestGuard < Minitest::Test
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
        optional :zero, allow_nil: true
        optional :box, allow_nil: true do
          required :size
        end
      end
    end

    def guard
      @guard ||= Gate::Guard.new(configuration)
    end

    def full_input
      {
        id: "1",
        message: { subject: "Title", value: "12.50" },
        nested: { value: "ok" },
        additional: { ignore: "true" },
        zero: "0",
        box: { size: "10" }
      }
    end

    def short_input
      {
        id: "1",
        message: { subject: "Title" }
      }
    end

    def nil_input
      short_input.merge(zero: nil)
    end

    def nested_nil_input
      short_input.merge(box: nil)
    end

    def invalid_nil_input
      short_input.merge(id: nil)
    end

    def missing_required
      {
        id: "1",
        message: { subject: "Title", value: "12.50" },
        nested: {}
      }
    end

    def coercion_error
      {
        id: "Invalid",
        message: { subject: "Title" }
      }
    end

    def test_valid_full_input
      expected = {
        id: 1,
        message: { subject: "Title", value: BigDecimal.new("12.50") },
        nested: { value: "ok" },
        zero: "0",
        box: { size: "10" }
      }

      result = guard.verify(full_input)
      assert result.valid?, "Expected #{mu_pp(result)} to be valid"
      assert_equal expected, result.attributes
    end

    def test_valid_short_input
      expected = {
        id: 1,
        message: { subject: "Title" }
      }

      result = guard.verify(short_input)
      assert result.valid?, "Expected #{mu_pp(result)} to be valid"
      assert_equal expected, result.attributes
    end

    def test_valid_nil_input
      expected = {
        id: 1,
        message: { subject: "Title" },
        zero: nil
      }

      result = guard.verify(nil_input)
      assert result.valid?, "Expected #{mu_pp(result)} to be valid"
      assert_equal expected, result.attributes
    end

    def test_valid_nested_nil_input
      expected = {
        id: 1,
        message: { subject: "Title" },
        box: nil
      }

      result = guard.verify(nested_nil_input)
      assert result.valid?, "Expected #{mu_pp(result)} to be valid"
      assert_equal expected, result.attributes
    end

    def test_invalid_nil_input
      expected = {
        id: :nil_not_allowed
      }

      result = guard.verify(invalid_nil_input)
      refute result.valid?, "Expected #{mu_pp(result)} to be invalid"
      assert_equal expected, result.errors
    end

    def test_missing_nested_required
      expected = {
        nested: { value: :missing }
      }

      result = guard.verify(missing_required)
      refute result.valid?, "Expected #{mu_pp(result)} to be invalid"
      assert_equal expected, result.errors
    end

    def test_coercion_error
      expected = { id: :coercion_error }

      result = guard.verify(coercion_error)
      refute result.valid?, "Expected #{mu_pp(result)} to be invalid"
      assert_equal expected, result.errors
    end
  end
end
