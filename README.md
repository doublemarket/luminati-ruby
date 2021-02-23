# luminati-ruby

A Ruby interface to the [Luminati API](https://luminati.io/doc/api).

**Caution: This gem currently supports only selected endpoints of the existing API.** Those are missing:

- Some endpoints of [the Account management API](https://luminati.io/doc/api#account_api).
- [Proxy Manager API](https://luminati.io/doc/api#lpm_endpoints)

Check out the [documentation](https://luminati.io/doc/api) for which ones are supported.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'luminati-ruby'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install luminati-ruby
```

## Usage

Get `Luminati::Client` by calling `Luminati::Client.new` with an API token. You can get your API token via https://luminati.io/cp/setting.

```
client = Luminati::Client.new("your api token")
```

and call any methods you want to use:

```
client.active_zones
=> [{"name"=>"testzone01", "type"=>"dc"}]
```

Also refer to the documentation https://rubydoc.info/gems/luminati-ruby

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/doublemarket/luminati-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
