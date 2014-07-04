require 'spec_helper'
require 'keymaker'

describe Keymaker::BatchCypherRequest do

  describe "#build_opts_collection" do

    context "with simple queries" do

      let(:queries) { ['MATCH (n) RETURN COUNT(n)', 'MATCH (n) RETURN n LIMIT 1'] }
      let(:batch_cypher_request) do
        Keymaker::BatchCypherRequest.new(Keymaker.service, queries)
      end

      it "builds the job descriptions collection" do
        batch_cypher_request.opts.should == [
          {id: 0, to: "/cypher", method: "POST", body: { query: 'MATCH (n) RETURN COUNT(n)'}},
          {id: 1, to: "/cypher", method: "POST", body: { query: 'MATCH (n) RETURN n LIMIT 1'}},
        ]
      end

    end

    context "with parametrized query" do

      let(:queries) { [{query: 'MATCH (n { property: {property} }) RETURN n', :params => { property: 3 }}] }
      let(:batch_cypher_request) do
        Keymaker::BatchCypherRequest.new(Keymaker.service, queries)
      end

      it "builds the job descriptions collection" do
        batch_cypher_request.opts.should == [
          {id: 0, to: "/cypher", method: "POST", body: {query: 'MATCH (n { property: {property} }) RETURN n', :params => { property: 3 } }}
        ]
      end

    end
  end
end
