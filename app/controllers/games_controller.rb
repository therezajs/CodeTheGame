class GamesController < ApplicationController

  # Calling all Games!
	def index
    @games = Game.all
	end

  # Calling a new Game
  # redirect to show
	def new
		@game = Game.new

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game }
        format.json { render json: @game }
      end
    end
	end

  # Showing the game
  # @params
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end


  # Play game using @params
  # Flash winner
  # Make it viewable in show!
  def update
    @game = Game.find(params[:id])

    @my_flash = @game.play(params[:game][:row].to_i,params[:game][:column].to_i)

    respond_to do |format|
      if @game
        if @my_flash != nil
          notice = {:success => @my_flash }
        end
        format.html { redirect_to @game, :flash => notice }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
end
