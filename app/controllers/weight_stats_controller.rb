class WeightStatsController < ApplicationController
	def new
		@weight_stat = WeightStat.new
	end

	def create

		# See if the user has already recorded their weight for the day and if so, then updated the current weight record
		# otherwise simply add a new weight record
		@weight_stat = current_user.weight_stats.where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).first
		if @weight_stat.nil?
			@weight_stat = WeightStat.new(weight_stat_params)
			@weight_stat.user = current_user
			
			respond_to do |format|
				if @weight_stat.save
	      	format.html { redirect_to user_path, notice: "Today's weight was successfuly recorded" }
	      	format.js
	      end
	    end
    else
    	# Record exists so update the weight instead
    	respond_to do |format|
	    	if @weight_stat.update(weight_stat_params)
    			format.html { redirect_to user_path(current_user.id), notice: "Today's weight was successfuly updated" }
	      	format.js
	    	end
	    end
    end
	end

	private
	  def weight_stat_params
	  	params.require(:weight_stat).permit(:weight)
	  end
end
