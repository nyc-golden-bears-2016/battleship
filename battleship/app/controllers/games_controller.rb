class GamesController < ApplicationController
  before_action :current_user
  before_action :current_game, only: [:show, :update, :hit, :hold]

  def new
  end

  def create
    @game = Game.create(player_1: @current_user)
    redirect_to "/games/#{@game.id}/hold"
  end

  def show
    if current_game.player_2 == nil
      @number = current_game.id
      @message = "Second player has not arrived."
      render 'hold'
    elsif game_over?
      render '/over'
    else
      if current_game.tiles.where(player_id: @current_user.id).empty?
        current_game.create_tiles(@current_user.id)
        current_game.create_opponent_tiles(opponent.id)
      end
    end
      @opponent_board = current_game.tiles.where(player_id: opponent.id)
      @your_board = current_game.tiles.where(player_id: @current_user.id)
  end

  def join
    game = Game.find(params[:game]["gamenum"].to_i)
    game.player_2 = @current_user
    game.save
    redirect_to "/games/#{game.id}"
  end


  def hit
    @ship = Ship.find(params[:id])
    if @ship.is_destroyed?
      redirect_to '/game/#{game.id}/destroy/#{@ship.id}'
    end
  end

  def destroy
    @destroyed_ship = Ship.find(params[:ship_id])
  end
  
  def hold
    if !@current_game.player_2_id.nil?
      redirect_to "/games/#{@current_game.id}"
    else
      @number = @current_game.id
    end
  end

  def over
    @current_user == User.find(@current_game.winner_id)
  end

  def update
    params.permit(:row)
    params.permit(:column)
    row = params[:row]
    col = params[:column]
    coord = row + ', ' + col
    tile = Tile.find_by(coordinates: coord, game_id: params[:id], player_id: @current_user.id)
    if tile
      tile.hit = true
      tile.save
      if ship_hit(tile)
        redirect_to '/hit'
      else
        redirect_to '/show'
      end
    else
      render 'show'
      @errors = tile.errors.full_messages
    end
  end

private

  # def fire_params
  #   binding.pry
  #   params.require(:fire).permit(:row, :column)
  # end

  def logged_in?
    session[:user_id]
  end

  def current_user
    if logged_in?
      @current_user = User.find(session[:user_id])
    end
  end

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  # def which_player
  #   game = Game.find(params[:id])
  #   if @current_user == game.player_1
  #     player_1 = @current_user
  #   elsif @current_user == game.player_2
  #     player_2 = @current_user
  #   end
  # end

  def opponent
    if @current_user == current_game.player_1
      current_game.player_2
    elsif @current_user == current_game.player_2
      current_game.player_1
    end
  end

  def ship_hit(tile)
    opp_tile = @opponent.tiles.find_by(coordinates: tile.coordinates)
    if opp_tile.ship_id == nil
      false
    else
      Ship.find(opp_tile.ship_id).type
    end
  end

  def game_over?
    p1_ships = current_game.ships.where(game_id: current_game.id)
    if !p1_ships.empty?
      p1_ships.each do |ship|
          p1_in_use = ship.tiles.take_while { |tile| tile.hit == true }
      end
      p2_ships = current_game.ships.where(player_id: @opponent)
      p2_ships.each do |ship|
          p2_in_use = ship.tiles.take_while { |tile| tile.hit == true }
      end
      if p1_in_use.empty? || p2_in_use.empty?
        true
      else
        false
      end
    else
      false
    end
  end


  def set_up_ships(game)
    aircraft = Ship.new(name: "Aircraft Carrier", length: 5, game: game)
    battle = Ship.new(name: "Battleship", length: 4, game: game)
    sub = Ship.new(name: "Submarine", length: 1, game: game)
    destroyer = Ship.new(name: "Destroyer", length: 2, game: game)
    tom = Ship.new(name: "Cruiser", length: 3, game: game)
    aircraft2 = Ship.new(name: "Aircraft Carrier", length: 5, game: game)
    battle2 = Ship.new(name: "Battleship", length: 4, game: game)
    sub2 = Ship.new(name: "Submarine", length: 1, game: game)
    destroyer2 = Ship.new(name: "Destroyer", length: 2, game: game)
    tom2 = Ship.new(name: "Cruiser", length: 3, game: game)

    place_ship_at("c, 7", "vertical", tom, game, game.player_1)
    place_ship_at("a, 1", "horizontal", sub, game, game.player_1)
    place_ship_at("i, 2", "horizontal", aircraft, game, game.player_1)
    place_ship_at("f, 5", "vertical", battle, game, game.player_1)
    place_ship_at("b, 10", "vertical", destroyer, game, game.player_1)

    place_ship_at("e, 4", "vertical", tom2, game, game.player_2)
    place_ship_at("j, 9", "horizontal", sub2, game, game.player_2)
    place_ship_at("d, 1", "horizontal", aircraft2, game, game.player_2)
    place_ship_at("g, 9", "vertical", battle2, game, game.player_2)
    place_ship_at("i, 3", "vertical", destroyer2, game, game.player_2)

    p1_tiles = game.player_1.tiles
  end


  def place_ship_at(coordinate, orientation, ship, game, player)
    valid_tiles = []
    if valid_coordinate?(coordinate)
      potential_tile = game.player_1.tiles.find_by(coordinate: coordinate)
      if !potential_tile.ship
        valid_tiles << potential_tile
      else
        return nil
      end
      letter = coordinate[0].ord
      number = coordinate[-1].to_i
      ship_tail = ship.length - 1
      ship_tail.times do
        if orientation == "horizontal"
          number += 1
          if !valid_coordinate("#{letter.chr}, #{number}")
            return nil
          else
            potential_tile = game.player.tiles.find_by(coordinate: "#{letter.chr}, #{number}")
            if !potential_tile.ship
              valid_tiles << potential_tile
            else
              return nil
            end
          end
        elsif orientation == "vertical"
          letter += 1
          if !valid_coordinate("#{letter.chr}, #{number}")
            return nil
          else
            potential_tile = game.player.tiles.find_by(coordinate: "#{letter.chr}, #{number}")
            if !potential_tile.ship
              valid_tiles << potential_tile
            else
              return nil
            end
          end
        end
      end
    end
    if valid_tiles.empty?
      return nil
    else
      ship.tiles << valid_tiles
    end
  end

  def valid_coordinate?(coordinate)
    letter = coordinate[0]
    number = coordinate[-1]
    if letter.ord > "j".ord
      return false
    elsif letter.ord < "a".ord
      return false
    elsif number > 10
      return false
    elsif letter.ord < 1
      return false
    end
    return true
  end

end
