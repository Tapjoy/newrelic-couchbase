::Couchbase.module_eval do
  class << self
    [
      :new,
      :connect,
      :thread_storage,
      :verify_connection!,
      :reset_thread_storage!,
      :bucket,
      :bucket=
    ].each do |instruction|
      NewRelic::Agent::Datastores.trace self, instruction, "Couchbase"
    end
  end
end
