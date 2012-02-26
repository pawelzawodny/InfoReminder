class AddDescriptionAndConfigurationTypeIdToConfiguration < ActiveRecord::Migration
  def change
    add_column :configurations, :description, :string
    add_column :configurations, :type_id, :integer
  end
end
