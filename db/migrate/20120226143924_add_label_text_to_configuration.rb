class AddLabelTextToConfiguration < ActiveRecord::Migration
  def change
    add_column :configurations, :label_text, :string
  end
end
