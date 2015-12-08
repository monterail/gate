require "minitest_helper"

module Gate
  class TestCoercer < Minitest::Test
    def test_coerce_string
      assert_equal "o Hai", coercer_for(:String).coerce("o Hai")
    end

    def test_coerce_any
      assert_equal "o Hai", coercer_for(:Any).coerce("o Hai")
      assert_equal [1, 2, 3], coercer_for(:Any).coerce([1, 2, 3])
      assert_equal false, coercer_for(:Any).coerce(false)
      assert_equal true, coercer_for(:Any).coerce(true)
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

    def test_allowed_nil
      assert coercer_for(:String, true).allow_nil?
      refute coercer_for(:String, false).allow_nil?
      refute coercer_for(:String).allow_nil?
    end

    def coercer_for(type, allow_nil = false)
      Gate::Coercer.new(coerce_engine, type, allow_nil: allow_nil)
    end

    def coerce_engine
      Coercible::Coercer.new
    end
  end
end
