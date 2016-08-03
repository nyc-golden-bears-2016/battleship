
class GamesController < ActionController::Base
  before_action :current_user
  # before_action :which_player

  def new
  end

  def create

  end

   def show
    # borrowing from show
    p_1 = User.create(username: "Ben", password: "test")
    p_2 = User.create(username: "Kudler", password: "test")
    @game = Game.create(player_1_id: p_1.id, player_2_id: p_2.id)
    @game.create_tiles

    # game = Game.find(params[:id])
    @opponent_board = @game.tiles.where(player_id: opponent(params[:id]).id)
    binding.pry
    if @opponent_board.empty?
      @opponent_board = Game.create_opponent_tiles
    end
    @your_board = @game.tiles.where(player_id: session[:id])
  end

  def hit
  end

  def hold
    # @number =
  end

  def over
  end

  def update
    row = params[:coord_row]
    col = params[:coord_row]
    coord = col + ', ' + row
    tile = Tile.find_by(coordinates: coord)
    if tile
      tile.hit = true
      tile.save
    else
      @errors = tile.errors.full_messages
    end
  end

private

  def fire_params
    params.require(:fire).permit(:coordinates)
  end

  def logged_in?
    session[:user_id]
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

  def opponent(game_id)
    game = Game.find_by(id: game_id)
    # current user?
    if game.player_1_id == session[:id]
      return game.player_2
    else
      return game.player_1
    end
  end

end
