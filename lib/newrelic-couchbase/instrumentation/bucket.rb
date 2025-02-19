::Couchbase::Bucket.class_eval do
  [
    :collection,
    :collections,
    :default_collection,
    :default_scope,
    :ping,
    :scope,
    :view_indexes,
    :view_query
  ].each do |instruction|
    NewRelic::Agent::Datastores.trace self, instruction, "Couchbase"
  end
end
