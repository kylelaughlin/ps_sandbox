class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :payment_spring_id
      t.string :name
      t.integer :amount
      t.string :frequency

      t.timestamps
    end
  end
end
