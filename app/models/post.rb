class Post < ActiveRecord::Base
  belongs_to :user #, :foreign_key => "user_username"
  belongs_to :item
  has_and_belongs_to_many :tags
  has_many :replies, :class_name => 'Post', :foreign_key => 'parent_id'
  belongs_to :parent, :class_name => 'Post'

  validates_presence_of :title, :body

  def Post.html_attributes
    'abbr alt cite class datetime height href name src title width rowspan colspan rel'
  end

  def course
    item.course
  end
  def params
    item.nest_params.merge(:id => to_param)
  end
  def nest_params
    item.nest_params.merge(:post_id => to_param)
  end
  def replies_s
    replies.count.to_s + (replies.count == 1 ? " Reply" : " Replies")
  end
  def created_at_day_s
    created_at.getlocal.strftime("%b %d, %Y")
  end
  def created_at_time_s
    #For some reason %l instead of %I doesn't work
    time = created_at.getlocal.strftime("%I:%M %p")
    time.first == '0' ? time[1..-1] : time
  end

  def sanitize # for views
    ActionController::Base.helpers.sanitize(body.gsub("\n", "<br />"), :attributes => Post.html_attributes)
  end

  def tags_s
    (tags.map {|t| t.value }).sort.join(', ')
  end

  def add_tags(post_tags)
    post_tags = post_tags.downcase.split(', ')
    post_tags.each do |tag|
      tags << Tag.find_or_initialize_by_value(tag) if tags.find_by_value(tag).nil?
    end
  end

end