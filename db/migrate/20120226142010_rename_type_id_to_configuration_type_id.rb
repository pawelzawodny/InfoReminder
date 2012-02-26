class RenameTypeIdToConfigurationTypeId < ActiveRecord::Migration
  def up
    rename_column :configurations, :type_id, :configuration_type_id
  end

  def down
    rename_column :configurations, :configuration_type_id, :type_id
  end
end
