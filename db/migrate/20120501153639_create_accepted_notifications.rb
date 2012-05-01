class CreateAcceptedNotifications < ActiveRecord::Migration
  def change
    create_table :accepted_notifications do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
  end
end
