require "minitest_helper"

module Gate
  class TestCoercer < Minitest::Test
    def test_coerce_string
      assert_equal "o Hai", coercer_for(:String).coerce("o Hai")
    end

    def test_coerce_boolean_true
      assert coercer_for(:Boolean).coerce("yes")
      assert coercer_for(:Boolean).coerce(true)
    end

    def test_coerce_boolean_false
      refute coercer_for(:Boolean).coerce("no")
      refute coercer_for(:Boolean).coerce(false)
    end

    def test_coerce_array
      assert_equal [1, 2, 3] ,coercer_for(:Array).coerce([1, 2, 3])
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
