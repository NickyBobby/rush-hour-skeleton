class AddHashColumnToPayloadRequests < ActiveRecord::Migration
  def change
    add_column :payload_requests, :payload_sha, :string
  end
end
