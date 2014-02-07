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
  	user_vital = current_user.user_vital
		if !user_vital.nil?
			# Calculate BMI, BMR TDEE
			@gender = user_vital.gender
			@age = user_vital.age
			@height = user_vital.height
			@start_weight = user_vital.start_weight
			@target_weight = user_vital.target_weight

			@activity_level = user_vital.tdee_factor.level_name
			multiplier = user_vital.tdee_factor.multiplier.to_f
			@goal = user_vital.goal_type.goal

			bmi_bmr = UserVital.calcBMR(1, @gender, @height, @start_weight, @age, multiplier)
			@bmi = bmi_bmr['bmi']
			@bmr = bmi_bmr['rbmr']
			@tdee = bmi_bmr['tdee']
			
			#@adj_tdee = @tdee + user_vital.goal_type.calorie_adj.to_f

			# Determine how many pounds the user wants to lose or gain
			# and then calculate the completion date based on their weight goal
			@pound_diff = @start_weight - @target_weight
			if user_vital.goal_type.calorie_adj != 0
				days = (@pound_diff * 3500) / user_vital.goal_type.calorie_adj.abs
			else
				days = 0
			end
			@complete_date = (Date.today + days).to_time.strftime('%B %e, %Y')
			

			#@weights = current_user.weight_stats.where(:created_at => 30.days.ago.to_date..Date.today.end_of_day).select("weight_stats.created_at, weight_stats.weight")
			@weights = current_user.weight_stats.select("weight_stats.created_at, weight_stats.weight")
			if !@weights.empty?
				@weight = @weights.map { |date| [date.created_at.to_i * 1000, date.weight.to_f] }
				@current_weight = @weights.last.weight
			else
				@weight = [Date.today.to_time.to_i * 1000, @start_weight]
			end

			@chart = LazyHighCharts::HighChart.new('graph') do |f|
				f.type = 'area'
			  f.title({ :text=>"Weight Chart for " + current_user.first_name + ' ' + current_user.last_name})
			  f.options[:xAxis] = { :type => 'datetime', :tickInterval => 24*3600*1000, :dateTimeLabelFormats => { :day => '%b %e, %Y' }, :lineWidth => 1} 
			  f.yAxis [
			    {:title => {:text => "Weight", :margin => 10, :style => {:color => '#20a8d2'}},
			    	:min => @target_weight - 2},
			    {:title => {:text => "BMI"},  :margin => 10, :opposite => true},
			  ] 

				#  $leftYaxis->plotLines[] = array(
				#   "value" => $data['target_weight'],
				#   "color" => "#a7d573",
				#   "width" => 2,
				#   "label" => array("text" => "Target Weight"),
				#   "zIndex" => 10
				# );
    
			  f.options[:plotOptions] = {area: {dataLabels: {enabled: true, :style => {:font_weight => 'bold'}}, pointInterval: 1.day, pointStart: 10.days.ago}}
			  f.series(:type => 'area', :name=> 'Weight', :data=> @weight)
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
