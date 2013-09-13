require 'rack'
require 'spec_helper'

describe Rack::JSON do
  let(:app) { MiniTest::Mock.new }
  let(:input) { "foo=bar" }
  let(:content_type) { "application/x-www-form-url-encoded" }
  let(:env) { Rack::MockRequest.env_for "/", :method => 'POST', :input => input, 'CONTENT_TYPE' => content_type }

  before do
    app.expect :call, [200, {}, []], [env]
  end

  subject { Rack::JSON.new app }

  it 'calls app' do
    subject.call env
    app.verify
  end

  it 'doesnt read body by default' do
    env['rack.input'] = MiniTest::Mock.new
    subject.call env
  end

  describe 'application/json requests' do
    let(:content_type) { 'application/json; charset=utf-8' }
    let(:params) { Rack::Request.new(env).POST }

    it 'rewinds input' do
      subject.call env
      Rack::Request.new(env).body.read.must_equal input
    end

    describe 'when input is a hash' do
      let(:input) { '{"qux": "bin"}' }

      it 'adds a parsed hash to POST params' do
        subject.call env
        params['qux'].must_equal 'bin'
      end
    end

    describe 'when input is an array' do
      let(:input) { '["a", "b", "c"]' }

      it 'adds a parsed array to POST params as _json' do
        subject.call env
        params['_json'].must_equal ['a', 'b', 'c']
      end
    end

    describe 'when input has a json_class' do
      let(:input) { '{"json_class": "JSON::GenericObject", "key": "val" }' }

      it 'does not create additions' do
        subject.call env
        params['json_class'].must_equal 'JSON::GenericObject'
      end
    end

    describe 'when input is invalid' do
      let(:input) { '{"json_class": ' }

      it 'responds with a bad request message' do
        result = subject.call env
        response = Rack::MockResponse.new(*result)
        response.must_be :bad_request?
      end
    end

    describe 'when input is empty' do
      let(:input) { '' }

      it 'calls app' do
        subject.call env
        app.verify
      end
    end
  end
end
