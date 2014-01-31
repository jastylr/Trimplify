class ChangeTdeeFactorMultiplierColumnName < ActiveRecord::Migration
  def change
  	rename_column :tdee_factors, :mulitplier, :multiplier
  end
end
