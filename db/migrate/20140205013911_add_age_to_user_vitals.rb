class AddAgeToUserVitals < ActiveRecord::Migration
  def change
  	add_column :user_vitals, :age, :integer
  end
end
