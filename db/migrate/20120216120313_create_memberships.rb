class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.boolean :write
      t.boolean :read
      t.boolean :manage
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
