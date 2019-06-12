# Gate

[![Gem Version](https://badge.fury.io/rb/gate.svg)](http://badge.fury.io/rb/gate)
[![Circle CI](https://circleci.com/gh/monterail/gate.svg?style=shield)](https://circleci.com/gh/monterail/gate)
[![Code Climate](https://codeclimate.com/github/monterail/gate/badges/gpa.svg)](https://codeclimate.com/github/monterail/gate)
[![Test Coverage](https://codeclimate.com/github/monterail/gate/badges/coverage.svg)](https://codeclimate.com/github/monterail/gate/coverage)

**Gate** is a small wrapper on [dry-validation](http://dry-rb.org/gems/dry-validation/) that integrates it with [Ruby on Rails](https://rubyonrails.org/) and replaces [Strong Params](http://api.rubyonrails.org/classes/ActionController/Parameters.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gate

## Usage

Define [contract](https://dry-rb.org/gems/dry-validation) per action with controller DSL...

```ruby
class ExampleController < ActionController::Base
  include Gate::Rails

  before_action :verify_contract, if: { |c| c.contract_registered? }

  # Define contract just before action method
  contract do
    params do
      required(:id).filled
      required(:message).hash do
        required(:title).filled
        optional(:value).maybe(:decimal?)
      end
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

... or as a separate class:

```ruby
class ExampleFooContract < Dry::Validation::Contract
  params do
    required(:id).filled
    required(:message).hash do
      required(:title).filled
      optional(:value).maybe(:decimal?)
    end
  end
end

class ExampleController < ActionController::Base
  include Gate::Rails

  before_action :verify_contract, if: { |c| c.contract_registered? }

  contract(ExampleFooContract)
  def foo
    # you can access Dry::Validation result with:
    validated_params
  end
end
```

## Configuration

*TODO*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
