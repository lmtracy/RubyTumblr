class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.datetime :birthday
      t.string :email
      t.string :password
      t.datetime :created_at
  end
end
end