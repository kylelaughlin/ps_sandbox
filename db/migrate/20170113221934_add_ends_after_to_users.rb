class AddEndsAfterToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ends_after, :datetime
  end
end
