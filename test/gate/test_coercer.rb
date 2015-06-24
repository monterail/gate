require "minitest_helper"

module Gate
  class TestCoercer < Minitest::Test
    def test_coerce_string
      assert_equal "o Hai", coercer_for(:String).coerce("o Hai")
    end

    def test_coerce_boolean_true
      assert coercer_for(:Boolean).coerce("yes")
    end

    def test_coerce_boolean_false
      refute coercer_for(:Boolean).coerce("no")
    end

    def test_unknown_type
      error = assert_raises(Gate::CoercionError) { coercer_for(:Unknown) }
      assert_equal "Doesn't know how to coerce into Unknown", error.message
    end

    def test_unsupported
      message = "Doesn't know how to coerce NoSense into Boolean"
      error = assert_raises(Gate::CoercionError) do
        coercer_for(:Boolean).coerce("NoSense")
      end

      assert_equal message, error.message
    end

    def coercer_for(type)
      Gate::Coercer.new(coerce_engine, type)
    end

    def coerce_engine
      Coercible::Coercer.new
    end
  end
end
