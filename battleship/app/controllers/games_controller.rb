class GamesController < ActionController::Base
  # before_action :is_current_user, :which_player

  def new
  end

  def create
  end

  def show
  end

  def hit
  end

  def hold
  end

  def over
  end

private

  def fire_params
    params.require(:fire).permit(:coordinates)
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    if logged_in?
      @current_user = User.find(session[:user_id])
    end
  end

  def which_player
    game = Game.find(params[:id])
    if @current_user == game.player_1
      @current_user = @player_1
    elsif @current_user == game.player_2
      @current_user = @player_2
    end
  end
