class CreateFoodStats < ActiveRecord::Migration
  def change
    create_table :food_stats do |t|
      t.string :name
      t.string :description
      t.integer :calories
      t.references :user, index: true

      t.timestamps
    end
  end
end
