class AddCalorieAdjToGoalTypes < ActiveRecord::Migration
  def change
  	add_column :goal_types, :calorie_adj, :integer
  end
end
