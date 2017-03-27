class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    if @movie.save
      redirect_to movies_path
    else
      render :new
    end
  end

  def update

    if @movie.update(movie_params)
      redirect_to movies_path, notice: "Update Successful"
    else
      render :edit
    end
  end

  def destroy

    @movie.destroy
      redirect_to movies_path, alert: "Movie Deleted"
  end

  def join
    @movie = Movie.find(params[:id])

   if !current_user.is_favorite_of?(@movie)
     current_user.join!(@movie)
     flash[:notice] = " Added favorite"
   else
     flash[:warning] = "Already added favorite"
   end

    redirect_to movie_path(@movie)
  end

  def quit
    @movie = Movie.find(params[:id])

    if current_user.is_favorite_of?(@movie)
      current_user.quit!(@movie)
      flash[:alert] = "Removed favorite"
    else
      flash[:warning] = "Not in favorite list"
    end

      redirect_to movie_path(@movie)
  end



private

def movie_params
  params.require(:movie).permit(:title, :description)
end


def find_movie_and_check_permission
  @movie = Movie.find(params[:id])

  if current_user != @movie.user
    redirect_to root_path, alert: "you have no permission"
  end
end

end
