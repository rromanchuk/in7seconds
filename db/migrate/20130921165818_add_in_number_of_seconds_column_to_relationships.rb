class AddInNumberOfSecondsColumnToRelationships < ActiveRecord::Migration
  def change
  	add_column :relationships, :requested_in_num_seconds, :integer, :length => 1
  end
end
