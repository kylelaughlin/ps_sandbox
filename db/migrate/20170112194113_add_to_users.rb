class AddToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :customer_id, :string
    add_column :users, :plan_id, :string
    add_column :users, :active_until, :datetime
  end
end
