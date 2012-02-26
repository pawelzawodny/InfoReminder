class CreateConfigurationTypes < ActiveRecord::Migration
  def change
    create_table :configuration_types do |t|
      t.string :name
      t.string :default
      t.string :helper_method

      t.timestamps
    end
  end
end
