class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, limit: 60
      t.string :last_name, limit: 60
      t.string :email
      t.string :password_digest
      t.string :pic_url

      t.timestamps
    end
  end
end
