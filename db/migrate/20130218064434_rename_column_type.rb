class RenameColumnType < ActiveRecord::Migration
  def up
  	rename_column :variables, :type, :var_type
  end

  def down
  	rename_column :variables, :var_type, :type
  end
end
