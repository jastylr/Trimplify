class UserVital < ActiveRecord::Base

	attr_accessor :height_feet
	attr_accessor :height_inches

  belongs_to :user
  belongs_to :goal_type
  belongs_to :tdee_factor
  
  validates :gender, :age, :height_feet, :height_inches, :start_weight, :target_weight, :tdee_factor_id, :goal_type_id, presence: true
  accepts_nested_attributes_for :tdee_factor, :goal_type
  before_validation :heightToInches

  def height_feet
    height.floor/12 if height
  end

  def height_feet=(feet)
    @feet = feet
  end

  def height_inches
    if height && height%12 != 0
      height%12
    end
  end

  def height_inches=(inches) #on save?
    @inches = inches
  end

  def heightToInches
    self.height = @feet.to_d*12 + @inches.to_d #if @feet.present?
  end

	# def height_feet
 #    height.floor/12 if height
 #  end

 #  def height_inches
 #    height % 12 if height
 #  end

 #  def height_inches=(inches) #on save?
 #    @inches = inches
 #  end	

 #  # Perform conversion from Feet and Inches to just inches or cm
 #  def heightToInches
 #  	self.height = (height_feet.to_i * 12) + height_inches.to_i
 #  end

  # model method to calculate vital information
  def self.calcBMR(method, gender, height, weight, age, act_level)

    bmr = 0
    tdee = 0

    weight = weight.to_f
    height = height.to_f

    # Calculate the user's BMI
    # Metric 68 ÷ (1.65)2 = 24.98
    # US [150 ÷ (65)2] x 703 = 24.96
    bmi = (weight / (height * height)) * 703

    # Convert height and weight to centimeters and kilograms
    height = height * 2.54
    weight = weight / 2.20462

    if gender == 'F'
      if method == 0
        # Harris-Bendict BMR Equation for Women
        # BMR = 655.1 + ( 9.563 x weight in kg ) + ( 1.850 x height in cm ) - ( 4.676 x age in years )
      	bmr = 655 + (9.563 * weight) + (1.850 * height) - (4.676 * age)
      else
        # Mifflin-St Jeor
        # 9.99*Weight + 6.25*Height – 4.92*Age -161
        bmr = 9.99 * weight + 6.25 * height - 4.92 * age - 161
      end
    else
    	if method == 0
        # Harris-Bendict BMR Equation
        # BMR = 66.47 + ( 13.75 x weight in kg ) + ( 5.003 x height in cm ) - ( 6.755 x age in years )
        bmr = 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age)
      else
        # Mifflin-St Jeor
        # 9.99 × weight + 6.25 × height – 4.92 × age + 5
        bmr = 9.99 * weight + 6.25 * height - 4.92 * age + 5
      end
    end

    # TDEE value
    tdee = bmr * act_level
    
    ret = {"bmi" => bmi.round(1), "rbmr" => bmr.round(1), "tdee" => tdee.round(1)}
    
  end

  def self.calculate_age(birthday)
  	now = Time.now.utc.to_date
  	age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
	end
end
