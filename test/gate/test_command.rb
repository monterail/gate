require "test_helper"

class ExampleCommand
  include Gate::Command

  schema do
    required(:number).filled(:int?)
    required(:string).filled
    optional(:null).maybe
  end
end

module Gate
  class TestCommand < Minitest::Test

    def test_full_command
      cmd = ExampleCommand.with(number: "5", string: "abc", "null" => "string")

      assert_equal cmd.number, 5
      assert_equal cmd.string, "abc"
      assert_equal cmd.null, "string"
      assert_equal cmd.to_h, number: 5, string: "abc", null: "string"
    end

    def test_incomplete_command
      cmd = ExampleCommand.with(number: "5", string: "abc")

      assert_equal cmd.number, 5
      assert_equal cmd.string, "abc"
      assert_nil cmd.null
      assert_equal cmd.to_h, number: 5, string: "abc"
    end

    def test_invalid_command
      ExampleCommand.with("foo": "bar", string: "abc")

      assert false, "InvalidCommand should be raised"
    rescue ExampleCommand::InvalidCommand => e
      assert_equal e.errors, { number: ["number is missing"] }
    end

    def test_invalid_full_message
      ExampleCommand.with("foo": "bar")

      assert false, "InvalidCommand should be raised"
    rescue ExampleCommand::InvalidCommand => e
      assert_equal e.full_message, "number is missing, string is missing"
    end
  end
end
