class RemoveBirthdateFromUserVital < ActiveRecord::Migration
  def change
  	remove_column :user_vitals, :birthdate
  end
end
