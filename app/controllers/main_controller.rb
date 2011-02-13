class MainController < ApplicationController

  def index
    @current_user = current_user
    @user_session = UserSession.new
    if @current_user
      @single_school = (@current_user.schools.length == 1)
      @school_courses = @current_user.school_courses

      course_ids = @current_user.courses.map {|c| c.id}
      all_items = Item.all(:limit => 10, :conditions => ['course_id IN (?)', course_ids], :order => 'due_date DESC')
      item_ids = all_items.map {|i| i.id}
      @posts = Post.all(:limit => 2, :conditions => ['item_id IN (?)', item_ids], :order => 'created_at DESC')
      # calendar
      @items = Item.all(:limit => 10, :conditions => ['course_id IN (?) AND due_date >= ?', course_ids, Time.zone.now], :order => 'due_date')
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def about
    @current_user = current_user
    @user_session = UserSession.new
    respond_to do |format|
      format.html # about.html.erb
    end
  end

  def feedback
    @current_user = current_user
    @user_session = UserSession.new
    respond_to do |format|
      format.html # feedback.html.erb
    end
  end
  
  def send_feedback
    UserMailer.deliver_feedback(params[:body])
    #UserMailer.deliver_welcome(@current_user)
    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  def help
    @current_user = current_user
    @user_session = UserSession.new
    respond_to do |format|
      format.html # help.html.erb
    end
  end
  
  def mobile
    @current_user = current_user
    @courses = Course.all
    @user_session = UserSession.new
    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @courses }
    end
  end
end