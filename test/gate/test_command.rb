require "test_helper"

class ExampleCommand
  include Gate::Command

  schema do
    required(:number).filled(:int?)
    optional(:null).maybe
  end
end

module Gate
  class TestCommand < Minitest::Test

    def test_full_command
      cmd = ExampleCommand.with(number: "5", "null" => "string")

      assert_equal cmd.number, 5
      assert_equal cmd.null, "string"
    end

    def test_incomplete_command
      cmd = ExampleCommand.with(number: "5")

      assert_equal cmd.number, 5
      assert_nil cmd.null
    end

    def test_invalid_command
      ExampleCommand.with("foo": "bar")

      assert false, "InvalidCommand should be raised"
    rescue ExampleCommand::InvalidCommand => e
      assert_equal e.errors, { number: ["is missing"] }
    end
  end
end
