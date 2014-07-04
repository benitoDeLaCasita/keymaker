module Keymaker

  class BatchCypherRequest < BatchRequest

    attr_accessor :queries

    def initialize(service, queries)
      self.config = service.config
      self.queries = clean_queries(queries)
      self.service = service
      self.opts = build_job_descriptions_collection
    end

    def build_job_descriptions_collection
      [].tap do |batch_jobs|
        queries.each_with_index do |query, job_id|
          batch_jobs << {id: job_id, to: '/cypher', method: "POST", body: query}
        end
      end
    end

    protected
    def clean_queries(queries)
      queries.map{ |query|
        if query.is_a? String
          { query: query}
        else
          query
        end
      }
    end

  end

end
