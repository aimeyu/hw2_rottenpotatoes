class Movie < ActiveRecord::Base

  attr_accessible :current_column, :checked
  def initialize
    @current_column = params[:sort]
    @checked = params[:ratings]
  end
end
