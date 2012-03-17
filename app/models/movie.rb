class Movie < ActiveRecord::Base

  attr_accessible :current_column, :ratings, :checked

  def initialize
    @current_column = params[:sort]
    @ratings = params[:ratings]
  end

  def current_column
     @current_column = params[:sort]
  end

  def ratings
    @ratings = params[:ratings]
  end

  def keys
    params[:ratings].keys
  end

  def all_ratings
    @all_ratings = ['G','PG','PG-13','R']
  end

  def checked
    @checked = {}
    if params[:ratings]
      @selected = keys & @all_ratings
      @unselected = @all_ratings - @selected
      @selected.each do |selected|
        @checked[selected] = true
      end
      @unselected.each do |unselected|
      @checked[unselected] = false
      end
    else
      @all_ratings.each do |unselected|
      @checked[unselected] = false
      end
    end
  end

end

