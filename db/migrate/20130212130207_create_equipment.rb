class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :name
      t.text :desc
      t.string :ip

      t.timestamps
    end
  end
end
