class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      # User Info
      t.string :username
      t.string :email
      t.string :password

      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
