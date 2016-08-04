class ShipsController < ApplicationController
  def new
    @current_game = Game.find_by(id: params[:id])
  end

  def create
    game = Game.find_by(id: params[:id])
    player = nil
    if session[:id] == game.player_1_id
      player = game.player_2
    elsif session[:id] == game.player_2_id
      player = game.player_1
    end
    place_aircraft(player, game)
    place_battle(player, game)
    place_tom(player, game)
    place_destroyer(player, game)
    place_sub(player, game)
    if player.id == game.player_1_id
      game.player_1_setup = true
      game.save
    else
      game.player_2_setup = true
      game.save
    end
    redirect_to "/games/#{game.id}"
  end

private

  def place_aircraft(player, game)
    params.permit(:aircraft_row)
    params.permit(:aircraft_column)
    params.permit(:aircraft_orientation)
    row = params[:aircraft_row]
    col = params[:aircraft_column]
    orientation = params[:aircraft_orientation]
    coord = row + ', ' + col
    aircraft = Ship.create(name: "aircraft", length: 5, game: game)
    place_ship_at(coord, orientation, aircraft, game, player)
  end

  def place_battle(player, game)
    params.permit(:battle_row)
    params.permit(:battle_column)
    params.permit(:battle_orientation)
    row = params[:battle_row]
    col = params[:battle_column]
    orientation = params[:battle_orientation]
    coord = row + ', ' + col
    battle = Ship.create(name: "Battleship", length: 4, game: game)
    place_ship_at(coord, orientation, battle, game, player)
  end

  def place_sub(player, game)
    params.permit(:sub_row)
    params.permit(:sub_column)
    params.permit(:sub_orientation)
    row = params[:sub_row]
    col = params[:sub_column]
    orientation = params[:sub_orientation]
    coord = row + ', ' + col
    sub = Ship.create(name: "Submarine", length: 1, game: game)
    place_ship_at(coord, orientation, sub, game, player)
  end

  def place_destroyer(player, game)
    params.permit(:destroyer_row)
    params.permit(:destroyer_column)
    params.permit(:destroyer_orientation)
    row = params[:destroyer_row]
    col = params[:destroyer_column]
    orientation = params[:destroyer_orientation]
    coord = row + ', ' + col
    destroyer = Ship.create(name: "Destroyer", length: 2, game: game)
    place_ship_at(coord, orientation, destroyer, game, player)
  end

  def place_tom(player, game)
    params.permit(:tom_row)
    params.permit(:tom_column)
    params.permit(:tom_orientation)
    row = params[:tom_row]
    col = params[:tom_column]
    orientation = params[:tom_orientation]
    coord = row + ', ' + col
    tom = Ship.create(name: "Cruiser", length: 3, game: game)
    place_ship_at(coord, orientation, tom, game, player)
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
