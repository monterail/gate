require "minitest_helper"

module Gate
  class TestConfiguration < Minitest::Test
    def test_empty_configuration
      gate = Gate::Configuration.new do
      end

      assert_kind_of Gate::Configuration, gate
      assert_empty gate.required_set
      assert_empty gate.optional_set
      assert_empty gate.nested_set
      assert_empty gate.rules
      refute gate.allow_nil?
    end

    def test_nil_configuration
      gate = Gate::Configuration.new(allow_nil: true) do
        optional :nested, allow_nil: true do
          required :test
        end
      end

      assert_kind_of Gate::Configuration, gate
      assert gate.allow_nil?
      assert_allow_nested_nil gate, :nested
    end

    def test_setup_with_block
      gate = Gate::Configuration.new do
        required :req
        optional :opt

        required :nested do
          required :test
        end
      end

      assert_required gate, :req
      assert_optional gate, :opt

      assert_required gate, :nested
      assert_nested gate, :nested

      assert_required gate.rules[:nested], :test
    end

    def assert_required(gate, obj, msg = nil)
      msg = message(msg) do
        "Expected #{mu_pp(gate)} to register required #{mu_pp(obj)}"
      end
      assert_registered_param(gate, obj)
      assert gate.required_set.include?(obj), msg
    end

    def assert_optional(gate, obj, msg = nil)
      msg = message(msg) do
        "Expected #{mu_pp(gate)} to register optional #{mu_pp(obj)}"
      end
      assert_registered_param(gate, obj)
      assert gate.optional_set.include?(obj), msg
    end

    def assert_nested(gate, obj, msg = nil)
      msg = message(msg) do
        "Expected #{mu_pp(gate)} to register nested #{mu_pp(obj)}"
      end
      assert_registered_param(gate, obj)
      assert gate.nested_set.include?(obj), msg
    end

    def assert_registered_param(gate, obj, msg = nil)
      msg = message(msg) do
        "Expected #{mu_pp(gate)} to register #{mu_pp(obj)}"
      end
      assert_kind_of Gate::Configuration, gate
      assert gate.rules.include?(obj), msg
    end

    def assert_allow_nested_nil(gate, obj, msg = nil)
      msg = message(msg) do
        "Expected #{mu_pp(gate)} to allow nil for #{mu_pp(obj)}"
      end
      assert_nested gate, obj
      assert gate.rules[obj].allow_nil?, msg
    end
  end
end
