class CreateExerciseStats < ActiveRecord::Migration
  def change
    create_table :exercise_stats do |t|
      t.integer :duration
      t.integer :calories_burned
      t.references :user, index: true

      t.timestamps
    end
  end
end
