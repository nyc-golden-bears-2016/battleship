class BoardsController < ApplicationController
  def show
    game = Game.find_by(id: session[:current_game])
    @opponent_board = game.tiles.where(player_id: opponent.id)
    @your_board = game.tiles.where(player_id: session[:id])
    # # debug
    #   game = Game.new
    #   100.times do
    #     game.tiles << Tile.new
    #   end
    #   @opponent_board = game.tiles
    #   @your_board = game.tiles
    #   @your_board[0].hit = true;
    # # debug END
  end

end
