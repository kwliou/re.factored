class GradesController < ApplicationController
  layout "scaffold"
  before_filter :get_current_user, :get_school, :get_course
  
  # GET /grades
  # GET /grades.xml
  def index
  @item_grades = @current_user.items_with_grades(@course)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grades }
    end
  end
  
  # GET /grades/1
  # GET /grades/1.xml
  def show
    @grade = Grade.find(params[:id])
    # Get histogram for THIS assignment
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @grade }
    end
  end

  # GET /grades/new
  # GET /grades/new.xml
  def new
    @item = Item.find(params[:item_id])
    @grade = Grade.new
    @grade.item = @item
      
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @grade }
    end
  end

  # GET /grades/1/edit
  def edit
    @grade = Grade.find(params[:id])
  end

  # POST /grades
  # POST /grades.xml
  def create
    @grade = Grade.new(params[:grade])
    @item = Item.find(params[:item][:id])
    @grade.user = @current_user
    @grade.item = @item
    respond_to do |format|
      if @grade.save
        # Redirect to course/:course_id/grades
        format.html { redirect_to(course_grades_path(:notification => "Grade successfully created")) }
        format.xml  { render :xml => @grade, :status => :created, :location => @grade }
      else
        format.html { redirect_to(course_grades_path) }
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /grades/1
  # PUT /grades/1.xml
  def update
    @grade = Grade.find(params[:id])
    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        format.html { redirect_to(@grade, :notice => 'Grade was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1
  # DELETE /grades/1.xml
  def destroy
    # Destroy all of the selected grades
    @grades = Grade.find(params[:grade_ids])
    count = @grades.length
    @grades.each { |g| g.destroy }
    respond_to do |format|
      format.html { redirect_to(course_grades_path(@course.to_param, :notification => "#{count} grade#{count == 1 ? '' : 's'} removed")) }
      format.xml  { head :ok }
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
  def get_course
    @course = Course.find_by_params(params)
  end
end
