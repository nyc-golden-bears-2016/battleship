require 'json'

class GamesController < ApplicationController
  before_action :redirect, except: [:new, :create, :join]
  before_action :current_user
  before_action :current_game, :opponent, only: [:turn, :show, :update, :hit, :hold, :destroy]

  def create
    game = Game.create(player_1: @current_user)
    redirect_to "/games/#{game.id}/hold"
  end

  def show
    @opponent = opponent
    if current_game.player_2 == nil
      @number = current_game.id
      @message = "Second player has not arrived."
      render 'hold'
    elsif !(current_game.tiles.where(player_id: @current_user.id).empty?) && (current_game.player_2_setup == false || current_game.player_1_setup == false)
      render :set_up
    elsif user_game_over?
      @current_game.winner_id = opponent.id
      @current_game.save
      render :over
    elsif opponent_game_over?
      @current_game.winner_id = current_user.id
      @current_game.save
      render :over
    else
      if current_game.tiles.where(player_id: @current_user.id).empty?
        current_game.create_tiles(@current_user.id)
        current_game.create_opponent_tiles(opponent.id)
        render :set_up
      end
    end
    @player_turn = player_turn
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

  def update
    params.permit(:row)
    params.permit(:column)
    row = params[:row]
    col = params[:column]
    coord = row + ', ' + col
    tile = Tile.find_by(coordinates: coord, game_id: params[:id], player_id: opponent.id)
    if tile && tile.hit == false
      tile.hit = true
      tile.save
      if tile.ship_id
        redirect_to "/games/#{@current_game.id}/hit?ship_id=#{tile.ship_id}"
      else
        redirect_to "/games/#{@current_game.id}"
      end
    elsif tile.hit == true
      redirect_to "/games/#{@current_game.id}?play_again=true"
    else
      @errors = tile.errors.full_messages
      render 'show'
    end
  end

  def turn
    first_turn = current_game.tiles.where(hit: true).empty?
    struck_coordinates = current_game.tiles.order(updated_at: :desc).first.coordinates
    render json: {first_turn: first_turn, your_turn: player_turn, coordinates: struck_coordinates}.to_json
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

  def redirect
    p1 = Game.find(params[:id]).player_1
    p2 = Game.find(params[:id]).player_2
    if !logged_in? || (logged_in? && current_user != p1 && current_user != p2)
      redirect_to '/'
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

  def player_turn
    total_tiles = Tile.all.where(game_id: current_game.id, hit: true).count
    if total_tiles.even? && @current_game.player_1.id == current_user.id
      true
    elsif total_tiles.odd? && @current_game.player_2.id == current_user.id
      true
    else
      false
    end
  end


  def user_game_over?
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


  def opponent_game_over?
    if !@current_game.tiles.empty?
      opponent_tiles = @current_game.tiles.where(player_id: opponent.id)
      opponent_tiles.each do |tile|
        if tile.ship && ( tile.hit == false )
          return false
        end
      end
      return true
    end
    return false
  end


end
