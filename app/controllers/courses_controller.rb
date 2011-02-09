class CoursesController < ApplicationController  
  before_filter :get_current_user, :get_school # :get_course doesn't work on Heroku

  layout 'scaffold'

  def auto_complete_for_department_name
    @depts = Department.find(:all, :conditions=> ['name LIKE ?', "%#{params[:department][:name]}%"])
    render :partial => 'department'
  end

  def subscribe
    @course = Course.find_by_params(params)
    @current_user.courses << @course if !@current_user.courses.include?(@course)
    redirect_to :action => 'show', :id => @course.to_param
  end
  
  def unsubscribe
    @course = Course.find_by_params(params)
    @current_user.courses.delete(@course)
    redirect_to root_url
	end
  
  # GET /courses
  # GET /courses.xml
  def index
#    if params[:semester]
#      term, year = params[:semester].split(" ")
#      @semester = params[:semester]
#      @courses = Course.find(:all, :conditions => {:term => term, :year => year})
#    else
#      @courses = Course.find(:all, :conditions => {:term => 'Fall', :year => 2010})
#    end
    @courses = Course.all
    @semesters = Course.all_semesters
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = Course.find_by_params(params)
    @items = @course.items.find(:all, :limit => 6, :conditions => ['due_date >= ?', Time.zone.now], :order => 'due_date')

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  def info
    @course = Course.find_by_params(params)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    @course = Course.new
    @departments = Department.find(:all, :order => 'name').map { |c| [c.name, c.id] }
    @years = Course.year_limits
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find_by_params(params)
    @departments = Department.find(:all, :order => 'name').map { |c| [c.name, c.id] }
    @years = Course.year_limits
    @days = @course.days.each_char.map { |c| c == c.upcase }
  end

  # POST /courses
  # POST /courses.xml
  def create
    #params[:course][:term] = params[:course][:term][0, 2]
    params[:course][:days] = ''
    'mtwrfsu'.each_char do |day|
      params[:course][:days] += params[day] || day
    end
#    if params[:department] # params[:course][:department_id].nil?
#      params[:course][:department_id] = params[:department][:name]
#    end
    @course = Course.new(params[:course])
    
    respond_to do |format|
      if @course.save
        @current_user.courses << @course
        format.html { redirect_to(course_url(@course.params), :notice => 'Course was successfully created.') }
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    params[:course][:days] = ''
    'mtwrfsu'.each_char do |day|
      params[:course][:days] += params[day] || day
    end
    @course = Course.find_by_params(params)
    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(course_info_url(@course.params), :notice => 'Course was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    @course = Course.find_by_params(params)
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(courses_url) }
      format.xml  { head :ok }
    end
  end
end

private
  def get_current_user
    @current_user = current_user
    redirect_to root_url if @current_user.nil?
  end
  def get_school
    @school = @current_user.schools.find_by_param(params[:school_id])
  end