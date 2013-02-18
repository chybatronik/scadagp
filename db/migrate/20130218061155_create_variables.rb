class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :name
      t.text :desc
      t.string :address
      t.integer :equipment_id
      t.boolean :is_archive
      t.string :type
      t.float :last_value
      t.datetime :datetime_update_value

      t.timestamps
    end
  end
end
