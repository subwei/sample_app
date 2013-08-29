class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      # Adds the created_at and updated_at columns.
      t.timestamps
    end
  end
end
