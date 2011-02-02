class Department < ActiveRecord::Base
  include ApplicationHelper
  
  validates_presence_of :name, :abbr
  validates_uniqueness_of :name
  validates_uniqueness_of :abbr

  belongs_to :school
  has_many :courses
  
  before_save { |d| d.name = d.name.titleizev2; d.abbr = d.abbr.upcase }

  def to_param
    abbr
  end

  def Department.find_by_param(param)
    Department.find_by_abbr(param)
  end
end