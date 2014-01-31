class User < ActiveRecord::Base

	has_one :user_vital
	has_many :weight_stats
	has_many :exercise_stats
	has_many :food_stats
	
	validates :first_name, :last_name, :email, :password, :password_confirmation, presence: true
	validates :email, uniqueness: true
	validates :password, length: { minimum:6 }, :on => :create
	# The :on => :create makes sure that this condition is checked when
	# a user is first created, so on User.create or User.new + .save
	# but NOT on update.

	has_secure_password
end
