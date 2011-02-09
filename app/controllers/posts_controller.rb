include ActionView::Helpers::PrototypeHelper

class PostsController < ApplicationController
  # :get_post also probably doesn't work on Heroku
  before_filter :get_current_user, :get_school, :get_course, :get_item
  
  layout 'scaffold', :except => [:update_results]

  def update_results
    sel_tags = params[:tags]
    @include_all = params[:include_all]
    if sel_tags.nil?
      @posts = @item.posts.find_all_by_parent_id(nil)
    else
      tags = Tag.find_all_by_value(sel_tags)
      @posts = @include_all ?  @item.posts.select {|p| (tags - p.tags).empty? }  : @posts = @item.posts.reject {|p| (p.tags & tags).empty? }
    end
    render 'filter'
  end
  
  # GET /posts
  # GET /posts.xml
  def index
    @all_tags = @item.tags
    @sel_tags = params[:tags] || [params[:tag]] # selected tags
    @include_all = params[:include_all]
    if params[:tags]
      tags = Tag.find_by_value(@sel_tags)
      @posts = @include_all ? @item.posts.select {|p| (tags - p.tags).empty? } : @item.posts.reject {|p| (p.tags & tags).empty? }
    elsif params[:tag]
      tag = Tag.find_by_value(params[:tag])
      @posts = @item.posts.select {|p| p.tags.include?(tag)}
    else
      @posts = @item.posts.find_all_by_parent_id(nil)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = @item.posts.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = @current_user.posts.build # Post.new
    @parent = @item.posts.find(params[:post_id]) if params[:post_id]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  def new_post_reply
    @post = @current_user.posts.build # Post.new
    @post.parent = @parent = @item.posts.find(params[:post_id])
    respond_to do |format|
      format.html  { render :reply } # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = @current_user.posts.find(params[:id])
    @tags = @post.tags_s
  end

  # POST /posts
  # POST /posts.xml
  def create
    # maybe should separated into def create_post_reply
    params[:post][:body] = ActionController::Base.helpers.sanitize(params[:post][:body], :attributes => Post.html_attributes.sub('class ', ''))
    #regex = Regexp.new '((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)'
    #params[:post][:body].gsub!(regex, '<a href="\1" rel="nofollow">\1</a>')
    @post = @item.posts.build(params[:post])
    respond_to do |format|
      if @post.save
        @post.add_tags(params[:tags])
        @current_user.posts << @post
        format.html { redirect_to(course_item_post_path(@post.params), :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = @current_user.posts.find(params[:id])
    append = ActionController::Base.helpers.sanitize(params[:append], :attributes => Post.html_attributes.sub('class ', ''))
    unless append.blank?
      new_body = "#{@post.body}<br /><br /><span class='post_edit'>Edit (#{DateTime.now.strftime("%x")}, #{DateTime.now.strftime("%l:%M %p")}): </span><br />#{append}"
    end
    respond_to do |format|
      if @post.update_attributes(:body => new_body)
        @post.add_tags(params[:tags])
        format.html { redirect_to(course_item_post_path(@post.params), :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = @current_user.posts.find(params[:id]) #Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(course_item_posts_url(@course, @item)) }
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
  def get_course
    @course = Course.find_by_params(params)
  end
  def get_item
    @item = Item.find_by_params(params)
  end
