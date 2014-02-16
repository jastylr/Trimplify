class WeightStat < ActiveRecord::Base
  
  belongs_to :user
  validates :weight, numericality: { greater_than: 0 }

end
