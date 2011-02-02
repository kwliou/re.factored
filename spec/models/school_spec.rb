require 'spec_helper'

describe School do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    School.create!(@valid_attributes)
  end
end
