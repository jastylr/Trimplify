class UserVitalsController < ApplicationController

	def new
		@user_vital = UserVital.new
	end

	def create
		@user_vital = UserVital.new(user_vital_params)
		@user_vital.user = current_user
		if @user_vital.save
  		redirect_to user_path(current_user.id)
  	else
  		#render "welcome/index" 
  		redirect_to :back, flash: {errors: [@user_vital.errors.full_messages]}
  	end

	end

	def edit
		@user_vital = current_user.user_vital
	end

	def update
		@user_vital = UserVital.find(params[:id])
    if @user_vital.update_attributes(user_vital_params)
    	redirect_to user_path(current_user.id)
    else
      redirect_to :back, flash: {errors: ["Could not update your user vitals profile"]}
    end
	end

	private
	  def user_vital_params
	  	params.require(:user_vital).permit( :gender, :age, :height_feet, :height_inches, :start_weight, :target_weight, :goal_type_id, :tdee_factor_id)
	  end

end
