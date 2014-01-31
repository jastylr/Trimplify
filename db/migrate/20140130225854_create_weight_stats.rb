class CreateWeightStats < ActiveRecord::Migration
  def change
    create_table :weight_stats do |t|
      t.integer :weight
      t.references :user, index: true

      t.timestamps
    end
  end
end
