class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_movies = Movie.all
    @all_ratings = ['G','PG','PG-13','R']
    @movie = display_selected(@all_movies)
  end

  def sort_movies(movies)
    if params[:sort] == "title"
      movies.sort_by{|movie| movie.title}
    elsif params[:sort] == "release_date"
      movies.sort_by{|movie| movie.release_date}
    end
  end

  def only_include(movies)
    #Movie.find(:all, :conditions => {:rating=> keys})
    #{"utf8"=>"✓", "ratings"=>{"G"=>"1", "PG"=>"1", "R"=>"1"}, "commit"=>"Refresh", "action"=>"index", "controller"=>"movies"}

    @keys = params[:ratings].keys
    @keys.each do |key|
      if @included_movies.nil?
        @included_movies = movies.find_all{|movie| movie.rating == key}
      else
        @included_movies.concat(movies.find_all{|movie| movie.rating == key})
      end
    end
    @included_movies
  end

  def display_selected(movies)
    @ratings = params[:ratings]
    @current_column = params[:sort]
    checked

    if @ratings.present? && @current_column.nil?
      only_include(movies)
    elsif @ratings.present? && @current_column.present?
      sort_movies(only_include(movies))
    elsif @ratings.nil? && @current_column.present?
      sort_movies(movies)
    else
      movies
    end
  end

  def checked
    @checked = {}
    #if @checked = {}
    #  ?utf8=✓&ratings[G]=1&commit=Refresh
    #end
    if params[:ratings]
      @selected = params[:ratings].keys & @all_ratings
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

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end


end
