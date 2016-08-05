class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      render 'new'
    end
  end

  def destroy
    redirect_to '/'
  end

  def show
    @user = User.find(params[:id])
    @total_games = Game.where(player_1_id: @user.id) + Game.where(player_2_id: @user.id)
    @games_won = Game.where(winner_id: @user.id).length

    @ships_lost = 0
    @ships_sunk = 0
    @total_games.each do |game|
      game.ships.each do |ship|
        if ship.is_destroyed?
          if ship.tiles.first.player_id == @user.id
            @ships_lost += 1
          else
            @ships_sunk += 1
          end
        end
      end
    end
  end

  def index
    #__Most Wins
    users = User.all
    @user_wins_records = []
    users.each do |user|
      @user_wins_records << {user_id: user.id, games_won: Game.where(winner_id: user.id)}
    end
    @user_wins_records.sort_by! { |record| record[:games_won].count }.reverse!

    #__Most Sinks
    ships = {}
    @user_ships_record = []

    users.each do |user|
      total_games = Game.where(player_1_id: user.id) + Game.where(player_2_id: user.id)
      ships_lost = []
      ships_sunk = []
      total_games.each do |game|
        game.ships.each do |ship|
          if ship.is_destroyed?
            if ship.tiles.first.player_id == user.id
              ships_lost << ship
            else
              ships_sunk << ship
            end
          end
        end
      end
      @user_ships_record << {user_id: user.id, ships: {sunk: ships_sunk, lost: ships_lost}}
    end
    # @user_ships_record.sort_by! { |record| record[:ships][:sunk].count }.reverse!
  end

private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
