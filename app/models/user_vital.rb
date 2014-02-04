class UserVital < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :goal_type
  belongs_to :tdee_factor


  def self.calcBMR(method, gender, height, weight, age, act_level)

    bmr = 0
    tdee = 0

    weight = weight.to_f
    height = height.to_f
    
    # Calculate the user's BMI
    # Metric 68 ÷ (1.65)2 = 24.98
    # US [150 ÷ (65)2] x 703 = 24.96
    bmi = (weight / (height * height)) * 703

    height = height * 2.54
    weight = weight / 2.20462

    if gender == 'F'
      if method == 0
        # Harris-Bendict BMR Equation for Women
        # BMR = 655.1 + ( 9.563 x weight in kg ) + ( 1.850 x height in cm ) - ( 4.676 x age in years )
      	bmr = 655 + (9.6 * weight) + (1.8 * height) - (4.7 * age)
      else
        # Mifflin-St Jeor
        # 9.99*Weight + 6.25*Height – 4.92*Age -161
        bmr = 10 * weight + 6.25 * height * age - 161
      end
    else
    	if method == 0
        # Harris-Bendict BMR Equation
        # BMR = 66.47 + ( 13.75 x weight in kg ) + ( 5.003 x height in cm ) - ( 6.755 x age in years )
        bmr = 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age)
      else
        # Mifflin-St Jeor
        # 9.99 × weight + 6.25 × height – 4.92 × age + 5
        bmr = 10 * weight + 6.25 * height - 5 * age + 5
      end
    end

    tdee = bmr * act_level
    
    ret = {"bmi" => bmi.round(1), "rbmr" => bmr.round(1), "tdee" => tdee.round(1)}
    
  end

  def self.calculate_age(birthday)
	  age = (Date.today - birthday).to_i / 365
	end
end
