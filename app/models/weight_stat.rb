class WeightStat < ActiveRecord::Base
  belongs_to :user

  def self.weight_on(date)
  	where("date(created_at) = ?", date).sum(:weight)
  end

end
