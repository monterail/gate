# Gate

[![Gem Version](https://badge.fury.io/rb/gate.svg)](http://badge.fury.io/rb/gate)
[![Circle CI](https://circleci.com/gh/monterail/gate.svg?style=shield)](https://circleci.com/gh/monterail/gate)
[![Dependency Status](https://gemnasium.com/monterail/gate.svg)](https://gemnasium.com/monterail/gate)
[![Code Climate](https://codeclimate.com/github/monterail/gate/badges/gpa.svg)](https://codeclimate.com/github/monterail/gate)
[![Test Coverage](https://codeclimate.com/github/monterail/gate/badges/coverage.svg)](https://codeclimate.com/github/monterail/gate/coverage)

Gate is a small wrapper on [dry-validation](http://dry-rb.org/gems/dry-validation/) that might be used as Command in CQRS pattern or replace [Strong Params](http://api.rubyonrails.org/classes/ActionController/Parameters.html) in [Ruby on Rails](https://rubyonrails.org/) applications.

`Gate::Command` will raise `InvalidCommand` error for invalid input and provide simple struct with access to coerced input.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gate

## Command Usage

Define structure

```ruby
class DoSomethingCommand
  include Gate::Command

  schema do
    required(:id).filled
    required(:message).schema do
      required(:title).filled
      optional(:value).maybe(:decimal?)
    end
  end
end
```

Use it

```ruby
begin
  cmd = DoSomethingCommand.with(params)
  cmd.id
  cmd.message
rescue DoSomethingCommand::InvalidCommand => e
  e.errors # => hash { key => [errors] }
end
```

## Rails Usage

Define schemas per action

```ruby
class ExampleController < ActionController::Base
  include Gate::Rails

  before_action :validate_params, if: { |c| c.params_schema_registered? }

  # Define schema just before action method
  def_schema do
    required(:id).filled
    required(:message).schema do
      required(:title).filled
      optional(:value).maybe(:decimal?)
    end
  end

  def foo
    # you can access Dry::Validation result with:
    validated_params
  end

  # default handler for invalid params which you can override
  def handle_invalid_params(_errors)
    # errors is Dry::Validation messages hash

    head :bad_request
  end
end
```

## Configuration

Gate gives a possibility to create global, inherited configuration and separated setup in each one schema definition.

### Inheriting base setup

In order to configure the library according to the whole application, create a file under `config/initializers/gate.rb`. There is a possibility of creating a base configuration, defining shared, custom predicates and a lot more useful things. The full list of supported configuration options is consistent with available options in [dry-validation](https://dry-rb.org/gems/dry-validation/) gem.

```ruby
Gate::Rails.configure do
  configure do |config|
    config.messages_file = Rails.root.join("config", "locales" "en.yml")

    predicates(SharedPredicates)

    def foo?(value)
      value == "FOO"
    end
  end
end
```

### Separated setup

Sometimes there is a requirement to have a very specific configuration or behaviour in a one schema validation. The easiest way is to do it in a special `configure` block.

```ruby
class DoSomethingCommand
  include Gate::Command

  schema do
    configure do
      config.messages_file = Rails.root.join("config", "locales" "special_en.yml")
      predicates(SharedPredicates)
    end
    required(:id).filled
    required(:message).schema do
      required(:title).filled
      optional(:value).maybe(:decimal?)
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
