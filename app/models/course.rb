class Course < ActiveRecord::Base
  include ApplicationHelper
  has_many :items
  has_and_belongs_to_many :users
  has_many :ratings, :dependent=>:destroy
  belongs_to :department
  validates_presence_of :department_id, :name, :number
  #validates_uniqueness_of :name, :number, :scope => :department_id, :case_sensitive => false

  #before_save { |course| course.department = course.department.titleizev2 }

  @@terms = {
    "fa" => "Fall",
    "wi" => "Winter",
    "sp" => "Spring",
    "su" => "Summer"
  }

  def pretty_term
    return "#{@@terms[self.term]} #{self.year}"
  end
  
  def get_all_semesters
    courses = Department.find(self.department).courses
    other_sems = []
    courses.each { |c|
      if c.number == self.number
        other_sems << c
      end
    }
    return other_sems
  end
  
  def department_name
    self.department.name
  end
  
  def Course.find_by_params(params)
    dept, number = (params[:course_id] || params[:id]).split('_')
    term = params[:term]
    year = "20#{params[:year]}"
    school = School.find_by_param(params[:school_id])
    dept_id = school.departments.find_by_abbr(dept).id
    Course.find(:first, :conditions => ["department_id = ? AND number = ? AND term = ? AND year = ?", dept_id, number, term, year])
  end
  
  def Course.all_semesters
    semesters = []
    Course.year_limits.each { |year|
      ["Fall", "Winter", "Summer", "Spring"].each { |sem|
        semesters << "#{sem} #{year}"
      }
    }
    return semesters
  end
  
  def Course.year_limits
    2010.upto(2015)
  end

  def dept
    Department.find(department_id).abbr.upcase
  end

  def abbr
    "#{dept} #{number}"
  end

  def year_abbr
    year.to_s[2, 4]
  end
  
  def to_param
    #"#{dept}_#{number}_#{term.upcase[0, 2]}#{year.to_s[2, 4]}"
    "#{dept}_#{number}"
  end

  def params
    { :school_id => school.to_param,
      :id => to_param,
      :term => term, :year => year_abbr
    }
  end

  def nest_params
    { :school_id => school.to_param,
      :course_id => to_param,
      :term => term, :year => year_abbr
    }
  end
  def e_rating
    if (raters == 0)
      return "Someone needs to rate this course!"
    end
	  rating=Rating.total_e(self)/raters
    rating_s=rating.to_s
    return Rating.to_s_e(rating)
  end
  
  def raters
	 self.ratings.count
  end
  
  def i_rating
    if (raters==0)
      return "Someone needs to rate this course!"
    end
    rating=Rating.total_i(self)/raters
    rating_s=rating.to_s
    return Rating.to_s_i(rating)
  end
  
  def w_rating
    if (raters==0)
      return "Someone needs to rate this course!"
    end
    rating=Rating.total_w(self)/raters
    rating_s=rating.to_s
    return Rating.to_s_w(rating)
  end

  def school_id
    Department.find(department_id).school_id
  end
  def school
    Department.find(department_id).school
  end

  def full_name
    return self.department.name << "	" << self.number
  end
end
