class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    redNeed = false
    @all_ratings = []
    for m in Movie.all do
      rating = m.rating
      if (@all_ratings.include?(rating) == false)
        @all_ratings.push(rating)
      end
    end
    @all_ratings = @all_ratings.sort
    if($prevChecked.nil? == true)
      $prevChecked = @all_ratings
    end
   
    if(params[:sort].nil? == false)
      @sortCol = params[:sort]
      $prevChecked = @all_ratings
    elsif(session[:current_checked].nil? == false)
      @sortCol = session[:current_sort]
      redNeed = true
    else
      @sortCol = "title"
    end
    if(@sortCol.nil? == false)
      @movies = Movie.order(@sortCol)
    else
      @movies = Movie.all
    end
    
    
    
    
    if(params[:ratings].nil? == false)
      @checked = params[:ratings]
    elsif(session[:current_checked].nil? == false)
      @checked = session[:current_checked]
      redNeed = true
    else
      @checked = @all_ratings
      redNeed = true
    end
    
    if(redNeed == true)
      redirect_to movies_path(:sort => @sortCol, :ratings => @checked)
    end
    
    if(@checked.nil? == false)
      $prevChecked = @checked
      @moviesSort = @movies
      @movies = []
      for m in @moviesSort do
        movieRating = m.rating
        if(@checked.include?(movieRating) == true)
          @movies.push(m)
        end
      end
    end
    
    session[:current_checked] = @checked
    session[:current_sort] = @sortCol
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
