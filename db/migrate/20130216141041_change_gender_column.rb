class ChangeGenderColumn < ActiveRecord::Migration
  def up
    change_column :users, :gender, :boolean, :default => false
  end

end
