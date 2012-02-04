class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :date
      t.references :group

      t.timestamps
    end
    add_index :events, :group_id
  end
end
