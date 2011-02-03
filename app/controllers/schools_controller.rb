class SchoolsController < ApplicationController
  before_filter :get_current_user
  
  layout 'scaffold'

  # GET /schools
  # GET /schools.xml
  def index
    @schools = School.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end

  def index_user
    @user = User.find_by_username(params[:user_id])
    @schools = @user.schools
    @profile = @current_user == @user
    respond_to do |format|
      format.html # index_user.html.erb
      format.xml  { render :xml => @schools }
    end
  end
  
  # GET /schools/1
  # GET /schools/1.xml
  def show
    @school = School.find_by_param(params[:id])
    url = URI.parse(@school.url)
    @pretty_url = url.host.gsub(/^www./, '') + url.path

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @new_school = School.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @new_school }
    end
  end

  # GET /schools/1/edit
  def edit
    @school = School.find_by_param(params[:id])
  end

  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])

    respond_to do |format|
      if @school.save
        format.html { redirect_to(@school, :notice => 'School was successfully created.') }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    @school = School.find_by_param(params[:id])
    
    respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to(@school, :notice => 'School was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find_by_param(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end

  def enroll
    @school = School.find_by_param(params[:id])
    @current_user.schools << @school
    #@current_user.update_attributes(:school_id => params[:id])
    respond_to do |format|
      format.html { redirect_to(root_url, :notice => 'School was successfully updated.') }
      format.xml  { head :ok }
    end
  end

  def unenroll
    @school = School.find_by_param(params[:id])
    @school.enrollments.find_by_user_id(@current_user.id).destroy
    respond_to do |format|
      format.html { redirect_to(root_url, :notice => 'School was successfully updated.') }
      format.xml  { head :ok }
    end
  end
end

private
  def get_current_user
    @current_user = current_user
    redirect_to root_url if @current_user.nil?
  end