class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.integer :auth_token_id
      t.string :status
      t.string :setup_path
      t.string :version
      t.datetime :build_started_at

      t.timestamps
    end
  end
end
