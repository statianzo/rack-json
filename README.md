# Rack::JSON

Rack middleware for parsing JSON requests.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-json'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-json

## Usage

Add it to your config.ru

```ruby
use Rack::JSON
```

### Using a different JSON parser

rack-json supports other json parsers (Oj, yajl, etc.) by providing the
`parse_json` and `json_parser_error_class` methods that can be overridden.

```ruby
class Rack::JSON
  def parse_json(json)
    Oj.load(json)
  end

  def json_parser_error_class
    Oj::ParseError
  end
end
```

### Handling parse errors

If you'd prefer a different behavior than responding to parse errors with a 400
status code, then you can override `on_parse_error` with a different strategy.

```ruby
class Rack::JSON
  def on_parse_error(e)
    # Handle as you please
    [200, {}, []] # The return value is sent to the client
  end
end
```
