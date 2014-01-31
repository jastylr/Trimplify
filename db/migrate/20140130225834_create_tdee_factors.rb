class CreateTdeeFactors < ActiveRecord::Migration
  def change
    create_table :tdee_factors do |t|
      t.string :level_name
      t.string :description
      t.decimal :mulitplier, precision: 4, scale: 3

      t.timestamps
    end
  end
end
