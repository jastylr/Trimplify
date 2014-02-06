class RemoveUserIdFromGoalTypes < ActiveRecord::Migration
  def change
  	remove_column :goal_types, :user_vital_id
  end
end
