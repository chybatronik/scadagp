class CreateTableValues < ActiveRecord::Migration
  def change
    create_table :table_values do |t|
      t.integer :variable_id
      t.float :value
      t.datetime :datetime

      t.timestamps
    end
  end
end
