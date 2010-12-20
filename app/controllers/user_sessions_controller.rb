class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      #flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      redirect_to root_url(:errors => "Invalid username or password")
      #render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    #flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end