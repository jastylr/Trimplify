class SessionsController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.find_by(email: params[:user][:email]).try(:authenticate, params[:user][:password])
  	if @user == false || @user.nil?
  		redirect_to :back, flash: {errors: ["Incorrect email address or password. Please try again."]}
  	else
  		sign_in(@user)
  		redirect_to user_path(@user.id)
  	end
  end

  def edit
    @user = User.find_by(email: current_user.email).try(:authenticate, current_user.password)
  end

  def destroy
  	sign_out
  	redirect_to root_path
  end
end
