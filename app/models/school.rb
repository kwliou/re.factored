class School < ActiveRecord::Base
  has_many :departments
  has_many :enrollments
  has_many :users, :through => :enrollments

  def to_param
    abbr
  end
  def School.find_by_param(param)
    School.find_by_abbr(param)
  end
end
