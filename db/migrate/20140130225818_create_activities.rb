class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :description
      t.decimal :mets, precision: 3, scale: 1

      t.timestamps
    end
  end
end
