class AddDateToAcceptedNotification < ActiveRecord::Migration
  def change
    add_column :accepted_notifications, :date, :datetime
  end
end
