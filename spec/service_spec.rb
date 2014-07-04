require 'spec_helper'

describe Keymaker::Service  do

  context "with credentials provided" do
    let(:options) { { username: "jconnor", password: "easymoney" } }
    let(:config) do
      Keymaker::Configuration.new(options)
    end
    let(:service) { Keymaker::Service.new(config) }

    describe "#connection" do
      it "includes the username and password" do
        Faraday.should_receive(:new).with(url: config.connection_service_root_url)
        service.connection
      end
    end
  end

  context "with custom http client initializer provided" do
    let(:options) { { http_client_custom_initializer: ->(conn){ conn.headers['X-Stream'] = 'true' }} }
    let(:config) do
      Keymaker::Configuration.new(options)
    end

    let(:service) { Keymaker::Service.new(config) }

    describe "#connection" do
      it "must be configured" do
        service.connection.headers['X-Stream'].should == 'true'
      end
    end

  end

end
