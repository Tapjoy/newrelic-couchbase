module NewRelic
  module Agent
    module Instrumentation
      module Couchbase
        def get_set_callback(statement)
          Proc.new do |result, scoped_metric, elapsed|
            NewRelic::Agent::Datastores.notice_statement(statement, elapsed)
          end
        end

        def set_with_newrelic(*args, &blk)
          NewRelic::Agent::Datastores.wrap('Couchbase', 'set', name, get_set_callback(args.inspect)) do
            set_without_newrelic(*args, &blk)
          end
        end

        def get_with_newrelic(*args, &blk)
          NewRelic::Agent::Datastores.wrap('Couchbase', 'get', name, get_set_callback(args.inspect)) do
            get_without_newrelic(*args, &blk)
          end
        end
      end
    end
  end
end


::Couchbase::Bucket.class_eval do
  include NewRelic::Agent::Instrumentation::Couchbase
  alias_method :set_without_newrelic, :set
  alias_method :set, :set_with_newrelic
  alias_method :get_without_newrelic, :get
  alias_method :get, :get_with_newrelic

  [
    :cas,
    :compare_and_swap,
    :add,
    :replace,
    :delete,
    :incr,
    :increment,
    :decr,
    :decrement,
    :flush,
    :append,
    :prepend,
    :touch,
    :stats,
    :run,
    :design_docs,
    :save_design_doc,
    :delete_design_doc,
    :observe_and_wait,
    :create_timer,
    :create_periodic_timer
  ].each do |instruction|
    NewRelic::Agent::Datastores.trace self, instruction, "Couchbase"
  end
end