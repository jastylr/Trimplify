class UsersController < ApplicationController
  
  def new
  	@user = User.new
  	@user.user_vital.build
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

  	user_vital = current_user.user_vital
		if !user_vital.nil?
			# Calculate BMI, BMR TDEE
			@gender = user_vital.gender
			@age = UserVital.calculate_age(user_vital.birthdate)
			@height = user_vital.height
			@start_weight = user_vital.start_weight
			@target_weight = user_vital.target_weight

			@activity_level = user_vital.tdee_factor.level_name
			@goal = user_vital.goal_type.goal

			multiplier = user_vital.tdee_factor.multiplier.to_f
			
			bmi_bmr = UserVital.calcBMR(1, 
														@gender, 
														@height, 
														@start_weight, 
														@age, 
														multiplier
													)
			@bmi = bmi_bmr['bmi']
			@bmr = bmi_bmr['rbmr']
			@tdee = bmi_bmr['tdee']

			@weights = current_user.weight_stats.where(:created_at => 30.days.ago.to_date..Date.today.end_of_day).select("weight_stats.created_at, weight_stats.weight")
			@weight = @weights.map { |date| [date.created_at.to_i * 1000, date.weight.to_f] }


			@chart = LazyHighCharts::HighChart.new('graph') do |f|
				f.type = 'area'
			  f.title({ :text=>"Weight Chart for " + current_user.first_name + ' ' + current_user.last_name})
			  f.options[:xAxis] = { :type => 'datetime', :tickInterval => 24*3600*1000, :dateTimeLabelFormats => { :day => '%b %e, %Y' }, :lineWidth => 1} 
			  f.yAxis [
			    {:title => {:text => "Weight", :margin => 70, :style => {:color => '#20a8d2'}},
			    	:min => @target_weight - 2},
			    {:title => {:text => "BMI"},  :opposite => true},
			  ] 
			  #f.labels(:items=>[:html=>"Total fruit consumption", :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ]) 
			  f.options[:plotOptions] = {line: {pointInterval: 1.day, pointStart: 10.days.ago}}
			  f.series(:type => 'area', :name=> 'Daily Weight', :data=> @weight)
			end

			# $leftYaxis->allowDecimals = false;
   #  $leftYaxis->tickInterval = 2;
   #  $leftYaxis->min = $data['target_weight'] - 2;

   #  $leftYaxis->labels->formatter = new HighchartJsExpr("function() {
   #      return this.value +' lbs.'; }");

   #  $leftYaxis->labels->style->color = "#20a8d2";
   #  $leftYaxis->title->text = "Weight";
   #  $leftYaxis->title->style->color = "#20a8d2";

			# // Plot the target weight line
   #  $leftYaxis->plotLines[] = array(
   #    "value" => $data['target_weight'],
   #    "color" => "#a7d573",
   #    "width" => 2,
   #    "label" => array("text" => "Target Weight"),
   #    "zIndex" => 10
   #  );


		else
			# The user has not entered his/her vitals yet so redirect them to do so
			#### USER HAS NOT ENTERED THEIR VITAL SO REDIRECT THEM TO DO SO. RIGHT NOW JUST GOING TO HOME PAGE
 			redirect_to root_path, flash: {errors: ["You must first enter your user vitals information."]}
		end
  end

  private
	  def user_params
	  	#params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	  	params.require(:user).permit( :first_name, :last_name, :email, :password, :password_confirmation, user_vital_attributes: [:gender, :age, :height, :start_weight, :target_weight] )
	  end

end
