::Couchbase::View.class_eval do

  [
    :each,
    :first,
    :take,
    :on_error,
    :fetch,
    :fetch_all
  ].each do |instruction|
    NewRelic::Agent::Datastores.trace self, instruction, "Couchbase"
  end
end
