# MonotonicTickCount

Implements a PORO that can be used for monotonic timestamping. It wraps a count of fractional seconds (or ticks) that can be initialized to the system monotonic clock via the `.now` method or to any float you supply. It implements the comparable interface and arithmetic operators for calculating offsets and differences.

For an explanation as to why this is preferrable to using the wall clock for timing calculations, see [this blog post](https://www.softwariness.com/articles/monotonic-clocks-windows-and-posix/).

## Usage
Comparing two monotonic timestamps
```
tick_count_a = MonotonicTickCount.now
tick_count_b = MonotonicTickCount.now + 15.minutes
tick_count_a < tick_count_b == true
tick_count_b - tick_count_a == 900.0
```

Finding the elapsed tick count of a block
```
return_val, elapsed_ticks = MonotonicTickCount.timer do
  sleep(10)
  1
end
[return_val, elapsed_ticks] == [1, 10.0]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monotonic_tick_count'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install monotonic_tick_count

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/monotonic_tick_count.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
