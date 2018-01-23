::Couchbase::Cluster.class_eval do

  [:create_bucket, :delete_bucket].each do |instruction|
    NewRelic::Agent::Datastores.trace self, instruction, "Couchbase"
  end
end
