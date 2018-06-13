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

Define structure

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


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
