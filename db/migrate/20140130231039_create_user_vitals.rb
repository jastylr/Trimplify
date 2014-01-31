class CreateUserVitals < ActiveRecord::Migration
  def change
    create_table :user_vitals do |t|
      t.string :gender, limit: 1
      t.date :birthdate
      t.integer :height
      t.integer :start_weight
      t.integer :target_weight
      t.integer :bmi
      t.integer :bmr
      t.references :user, index: true
      t.references :goal_type, index: true
      t.references :tdee_factor, index: true

      t.timestamps
    end
  end
end
