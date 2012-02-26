class CreateConfigurationValues < ActiveRecord::Migration
  def change
    create_table :configuration_values do |t|
      t.integer :configuration_id
      t.integer :user_id
      t.string :value

      t.timestamps
    end
  end
end
