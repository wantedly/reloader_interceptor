# ReloaderInterceptor

A gRPC interceptor for using [ActiveSupport::Reloader](https://guides.rubyonrails.org/threading_and_code_execution.html#reloader).

This gem enables hot-reloading feature when used with Ruby on Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reloader_interceptor'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install reloader_interceptor

## Usage

If you use this gem with Ruby on Rails, I recommend you to write the code like this. This code also uses [grpc_server](https://github.com/south37/grpc_server).

```ruby
# Initialization of rails here
APP_PATH = File.expand_path('./config/application', Dir.pwd)
require './config/boot'
require 'rails'
require './config/environment'

# Setup ReloaderInterceptor
require "reloader_interceptor"
ReloaderInterceptor.enabled = Rails.env.development?  # Enable only in development

# Setup gRPC server
require "grpc_server"
server = GrpcServer.new(
  port:         3000,
  threads:      30,
  interceptors: [
    ReloaderInterceptor::ServerInterceptor.new(
      reloader: Rails.application.reloader
    )  # Set interceptor here
  ]
)
server.set_handler(
  ReloaderInterceptor::Wrapper.wrap(XXX)  # Wrap gRPC service here
)
server.run
```

## Architecture
There are 2 components in `ReloaderInterceptor`.

### `ReloaderInterceptor::Wrapper`

`Reloaderinterceptor::Wrapper` is used to wrap the original gRPC server class. For using [ActiveSupport::Reloader](https://guides.rubyonrails.org/threading_and_code_execution.html#reloader), gRPC server classes must be accessed by its name. `Wrapper` enables this.

### `ReloaderInterceptor::ServerInterceptor`

`ReloaderInterceptor::ServerInterceptor` is used to intercept each gRPC request. If code is changed, then constants are automatically erased in each request. You should set up an autoload environment by using [Zeitwork](https://github.com/fxn/zeitwerk) or [Ruby on Rails](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/south37/reloader_interceptor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/south37/reloader_interceptor/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ReloaderInterceptor project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/south37/reloader_interceptor/blob/master/CODE_OF_CONDUCT.md).
