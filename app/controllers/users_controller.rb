class UsersController < ApplicationController
  
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		sign_in(@user)
      redirect_to user_path(@user.id)
      #redirect_to root_path
  	else
  		render "welcome/index" 
  	end
  end

  def show
  	# if (current_user.id != params[:id])
  	# 	redirect_to login_path, flash: {errors: ["You don't have access to view this user profile."]}
  	# end
  	
  	@weight_stat = WeightStat.new

  	@profile_pic = current_user.pic_url if current_user.pic_url

  	# Get the user vital for the current user otherwise redirect them to fill
  	# out their user vitals information
  	@user_vital = current_user.user_vital
		if !@user_vital.nil?
			# Calculate BMI, BMR TDEE
			@gender = @user_vital.gender
			@age = @user_vital.age
			@height = @user_vital.height
			@start_weight = @user_vital.start_weight
			@target_weight = @user_vital.target_weight

			@activity_level = @user_vital.tdee_factor.level_name
			@multiplier = @user_vital.tdee_factor.multiplier.to_f
			@goal = @user_vital.goal_type.goal

      # @weights = current_user.weight_stats.select("weight_stats.created_at, weight_stats.weight")
      @weights = current_user.weight_stats.where('created_at > ? AND created_at < ?', Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)
      if !@weights.empty?
        @weight = @weights.map { |date| [date.created_at.to_i * 1000, date.weight.to_f] }
        @current_weight = @weights.last.weight
      else
        @weight = [Date.today.to_time.to_i * 1000, @start_weight]
      end

		else
			# The user has not entered his/her vitals yet so redirect them to do so
			redirect_to new_user_vital_path, flash: {errors: ["In order to view your weight profile, you must enter your user vitals information below."]}
		end
  end

  private
	  def user_params
	  	#params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	  	params.require(:user).permit( :first_name, :last_name, :email, :password, :password_confirmation, user_vital_attributes: [:gender, :age, :height, :start_weight, :target_weight] )
	  end

end
