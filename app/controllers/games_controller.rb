class GamesController < ApplicationController
  before_action :current_user
  before_action :current_game, only: [:show, :update, :hit, :hold, :destroy]

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
      render :over
    else
      if current_game.tiles.where(player_id: @current_user.id).empty?
        current_game.create_tiles(@current_user.id)
        current_game.create_opponent_tiles(opponent.id)
        set_up_ships(@current_game)
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
    @hit_ship = Ship.find(params[:ship_id])
    if @hit_ship.is_destroyed?
      redirect_to "/games/#{@current_game.id}/destroy/#{@hit_ship.id}"
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
    tile = Tile.find_by(coordinates: coord, game_id: params[:id], player_id: opponent.id)
    if tile
      tile.hit = true
      tile.save
      if tile.ship_id
        redirect_to "/games/#{@current_game.id}/hit?ship_id=#{tile.ship_id}"
      else
        redirect_to "/games/#{@current_game.id}"
      end
    else
      render 'show'
      @errors = tile.errors.full_messages
    end
  end

private

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


  def opponent
    if @current_user == current_game.player_1
      current_game.player_2
    elsif @current_user == current_game.player_2
      current_game.player_1
    end
  end


  def game_over?
    if !@current_game.tiles.empty?
      your_tiles = @current_game.tiles.where(player_id: @current_user.id)
      your_tiles.each do |tile|
        if tile.ship && ( tile.hit == false )
          return false
        end
      end
      return true
    end
    return false
  end


  def set_up_ships(game)
    # aircraft = Ship.create(name: "Aircraft Carrier", length: 5, game: game)
    # battle = Ship.create(name: "Battleship", length: 4, game: game)
    sub = Ship.create(name: "Submarine", length: 1, game: game)
    # destroyer = Ship.create(name: "Destroyer", length: 2, game: game)
    # tom = Ship.create(name: "Cruiser", length: 3, game: game)
    # aircraft2 = Ship.create(name: "Aircraft Carrier", length: 5, game: game)
    # battle2 = Ship.create(name: "Battleship", length: 4, game: game)
    # destroyer2 = Ship.create(name: "Destroyer", length: 2, game: game)
    # tom2 = Ship.create(name: "Cruiser", length: 3, game: game)
    sub2 = Ship.create(name: "Submarine", length: 1, game: game)

    # place_ship_at("c, 7", "vertical", tom, game, game.player_1)
    place_ship_at("a, 1", "horizontal", sub, game, game.player_1)
    # place_ship_at("i, 2", "horizontal", aircraft, game, game.player_1)
    # place_ship_at("e, 5", "vertical", battle, game, game.player_1)
    # place_ship_at("b, 10", "vertical", destroyer, game, game.player_1)

    # place_ship_at("e, 4", "vertical", tom2, game, game.player_2)
    place_ship_at("j, 9", "horizontal", sub2, game, game.player_2)
    # place_ship_at("d, 1", "horizontal", aircraft2, game, game.player_2)
    # place_ship_at("f, 8", "vertical", battle2, game, game.player_2)
    # place_ship_at("i, 3", "vertical", destroyer2, game, game.player_2)
  end


  def place_ship_at(coordinate, orientation, ship, game, player)
    valid_tiles = []
    if valid_coordinate?(coordinate)
      potential_tile = game.tiles.find_by(coordinates: coordinate, player_id: player.id)
      if !potential_tile.ship
        valid_tiles << potential_tile
      else
        return nil
      end
      letter_num = coordinate.split(", ")
      letter = letter_num[0].ord
      number = letter_num[1].to_i
      ship_tail = ship.length - 1
      ship_tail.times do
        if orientation == "horizontal"
          number += 1
          if !valid_coordinate?("#{letter.chr}, #{number}")
            return nil
          else
            potential_tile = game.tiles.find_by(coordinates: "#{letter.chr}, #{number}", player_id: player.id)
            if !potential_tile.ship
              valid_tiles << potential_tile
            else
              return nil
            end
          end
        elsif orientation == "vertical"
          letter += 1
          if !valid_coordinate?("#{letter.chr}, #{number}")
            return nil
          else
            potential_tile = game.tiles.find_by(coordinates: "#{letter.chr}, #{number}", player_id: player.id)
            if potential_tile.ship.nil?
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
    letter_num = coordinate.split(", ")
    letter = letter_num[0].ord
    number = letter_num[1].to_i
    if letter.ord > "j".ord
      return false
    elsif letter.ord < "a".ord
      return false
    elsif number > 10
      return false
    elsif number < 1
      return false
    end
    return true
  end

end
