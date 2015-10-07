# Gate

[![Gem Version](https://badge.fury.io/rb/gate.svg)](http://badge.fury.io/rb/gate)
[![Circle CI](https://circleci.com/gh/monterail/gate.svg?style=shield)](https://circleci.com/gh/monterail/gate)
[![Dependency Status](https://gemnasium.com/monterail/gate.svg)](https://gemnasium.com/monterail/gate)
[![Code Climate](https://codeclimate.com/github/monterail/gate/badges/gpa.svg)](https://codeclimate.com/github/monterail/gate)
[![Test Coverage](https://codeclimate.com/github/monterail/gate/badges/coverage.svg)](https://codeclimate.com/github/monterail/gate/coverage)

Gate is a small library which allows you to define allowed structure for user input with required and optional parameters and to coerce them into defined types.

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

Define structure

```ruby
gate = Gate.rules do
  required :id, :Integer
  required :message do
    required :title # :String by default
    optional :value, :Decimal
  end
end
```

Verify it

```ruby
result = gate.verify(params)
result.valid? # => true / false
result.attributes # => hash with only allowed parameters
result.errors # => hash { key => error }
```

If you need to handle `nil` values you can use `allow_nil` flag:

```ruby
gate = Gate.rules do
  required :id, :Integer, allow_nil: true
  required :message, allow_nil: true do
    required :title
    optional :value, :Decimal
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
