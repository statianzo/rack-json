require "rack/json/version"

module Rack
  class JSON

    APPLICATION_JSON = 'application/json'.freeze
    FORM_HASH = 'rack.request.form_hash'.freeze
    FORM_INPUT = 'rack.request.form_input'.freeze

    # Override to use a different parser
    def parse_json(json)
      ::JSON.parse(json, :create_additions => false)
    end

    # Override to use a different parser
    def json_parser_error_class
      ::JSON::ParserError
    end

    # Override for different error behavior
    def on_parse_error(e)
      [400, {'Content-Length' => 0}, []]
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new env

      if request.media_type == APPLICATION_JSON && !(body = request.body.read).empty?
        request.body.rewind
        parsed = parse_json body
        parsed = {'_json' => parsed} unless parsed.is_a? Hash

        env.update FORM_HASH  => parsed, FORM_INPUT => request.body
      end

      @app.call env

    rescue json_parser_error_class => e
      on_parse_error e
    end
  end
end
