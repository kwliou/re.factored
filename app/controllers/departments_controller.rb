class DepartmentsController < ApplicationController
  before_filter :get_current_user, :get_school # :get_course doesn't work on Heroku
  auto_complete_for :department, :name

  layout "scaffold"

  # GET /departments
  # GET /departments.xml
  def index
    @departments = Department.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @departments }
    end
  end

  # GET /departments/1
  # GET /departments/1.xml
  def show
    @department = Department.find_by_param(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/new
  # GET /departments/new.xml
  def new
    @department = Department.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find_by_param(params[:id])
  end

  # POST /departments
  # POST /departments.xml
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        @school.departments << @department
        format.html { redirect_to([@school, @department], :notice => 'Department was successfully created.') }
        format.xml  { render :xml => @department, :status => :created, :location => @department }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @department = Department.find_by_param(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to(@department, :notice => 'Department was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def destroy
    @department = Department.find_by_param(params[:id])
    @department.destroy

    respond_to do |format|
      format.html { redirect_to(departments_url) }
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