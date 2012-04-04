class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :activation_code
      t.boolean :lifetime_valid
      t.integer :group_id

      t.timestamps
    end
  end
end
