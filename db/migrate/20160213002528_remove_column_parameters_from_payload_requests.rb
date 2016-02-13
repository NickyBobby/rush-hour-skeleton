class RemoveColumnParametersFromPayloadRequests < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :parameters
  end
end
