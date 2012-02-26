class AddDefaultToConfiguration < ActiveRecord::Migration
  def change
    add_column :configurations, :default, :string
  end
end
