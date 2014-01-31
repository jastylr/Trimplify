class UserVital < ActiveRecord::Base
  belongs_to :user
  belongs_to :goal_type
  belongs_to :tdee_factor
  
end
