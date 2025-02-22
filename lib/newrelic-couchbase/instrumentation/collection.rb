module NewRelic
  module Agent
    module Instrumentation
      module Couchbase
        def get_upsert_callback(statement)
          Proc.new do |result, scoped_metric, elapsed|
            NewRelic::Agent::Datastores.notice_statement(statement, elapsed)
          end
        end

        def upsert_with_newrelic(*args, &blk)
          NewRelic::Agent::Datastores.wrap('Couchbase', 'upsert', bucket_name, get_upsert_callback(args.inspect)) do
            upsert_without_newrelic(*args, &blk)
          end
        end

        def get_with_newrelic(*args, &blk)
          NewRelic::Agent::Datastores.wrap('Couchbase', 'get', bucket_name, get_upsert_callback(args.inspect)) do
            get_without_newrelic(*args, &blk)
          end
        end

        def get_and_touch_with_newrelic(*args, &blk)
          NewRelic::Agent::Datastores.wrap('Couchbase', 'get_and_touch', bucket_name, get_upsert_callback(args.inspect)) do
            get_and_touch_without_newrelic(*args, &blk)
          end
        end

        def get_multi_with_newrelic(*args, &blk)
          NewRelic::Agent::Datastores.wrap('Couchbase', 'get_multi', bucket_name, get_upsert_callback(args.inspect)) do
            get_multi_without_newrelic(*args, &blk)
          end
        end
      end
    end
  end
end


::Couchbase::Collection.class_eval do
  include NewRelic::Agent::Instrumentation::Couchbase
  alias_method :upsert_without_newrelic, :upsert
  alias_method :upsert, :upsert_with_newrelic
  alias_method :get_without_newrelic, :get
  alias_method :get, :get_with_newrelic
  alias_method :get_and_touch_without_newrelic, :get_and_touch
  alias_method :get_and_touch, :get_and_touch_with_newrelic
  alias_method :get_multi_without_newrelic, :get_multi
  alias_method :get_multi, :get_multi_with_newrelic

  [
    :binary,
    :exists,
    :get_all_replicas,
    :get_and_lock,
    :get_any_replica,
    :insert,
    :lookup_in,
    :lookup_in_all_replicas,
    :lookup_in_any_replica,
    :mutate_in,
    :query_indexes,
    :remove,
    :remove_multi,
    :replace,
    :scan,
    :unlock,
    :upsert_multi
  ].each do |instruction|
    NewRelic::Agent::Datastores.trace self, instruction, "Couchbase"
  end
end
