::Couchbase::Cluster.class_eval do

  [
    :analytics_indexes,
    :analytics_query,
    :bucket,
    :buckets,
    :diagnostics,
    :disconnect,
    :ping,
    :query,
    :query_indexes,
    :search,
    :search_indexes,
    :search_query,
    :users
  ].each do |instruction|
    NewRelic::Agent::Datastores.trace self, instruction, "Couchbase"
  end
end
