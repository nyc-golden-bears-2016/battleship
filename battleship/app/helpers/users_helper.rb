module UsersHelper

  def opponent
    game = Game.find_by(id: session[:current_game])
    if game.player_1_id == session[:id]
      return game.player_1
    else
      return game.player_2
    end
  end

end
