class Game < ActiveRecord::Base
  # Saves the board in the database as an object,
  # and allows you to retrieve as the same object
  serialize :board

  include GamesHelper
  include ActiveModel::Validations

  # This line tells Rails which attributes of the model are accessible, i.e.,
  # which attributes can be modified automatically by outside users
  # (such as users submitting requests with web browsers).
  attr_accessible :board

  validates :board, :presence => true

  # Initializes the object with a board, made up of a two dimensional array of
  # nils. Eg
  #   board = [ [nil, nil, nil],
  #             [nil, nil, nil],
  #             [nil, nil, nil]  ]
  #
  # This is called when you use `Game.new` or `Game.create!`.
  # NOTE ActiveRecord::Base does not have a #create method.
  def initialize
    super
    self.board = Array.new(3).map{[nil, nil, nil]}
  end

  # Updates the board based on player, row, and column
  #
  # @param player [String] either 'x' or 'o'
  # @param row [Integer] 0-2
  # @param column [Integer] 0-2
  # @return [Boolean] Save successful?
  # @return ArgumentError
  #
  # use helpers/games_helper to see board in the terminal
  def update_board(player, row, column)
    if (row < 3 && column < 3 ) && board[row][column] == nil && (player == "x" || player == "o")
      board[row][column] = player
      self.save
      return true
    else
      raise ArgumentError
    end
  end

  # Returns the current_player
  # @return [String] 'x' or 'o'
  def current_player
    count = 0
    for n in 0...board.length
      for m in 0...board[n].length
        if board[n][m] == nil
          count += 1
        end
      end
    end

    if count.odd?
      return 'x'
    else
      return 'o'
    end
  end

  # Plays the game
  #
  # @returns winner
  # updates the board
  # call #WINNER AFTER each move, not before
  def play(row, column)
    winner

    if @player == nil
      update_board(current_player, row, column)
    end

    if winner != nil
      @my_flash = "Player #{@player} is the winner!"
      return "Player #{@player} is the winner!"
    else
      return nil
    end
  end

  # Checks if there is a winner.
  # @return [Boolean] returns true if there is a winner, false otherwise
  # Calls on private methods below
  def winner
    if check_rows_for_winner || check_columns_for_winner || check_diagonals_for_winner
      return @player
    else
      return nil
    end
  end


  # The below methods can only be accessed by methods in this class
  # private

  # Establishes winner in row
  def check_rows_for_winner

    if board[0][0] == board[0][2] and board[0][1] == board[0][2] and not board[0][1] == nil
      @player = board[0][0]
    elsif board[1][0] == board[1][2] and board[1][1] == board[1][2] and not board[1][1] == nil
      @player = board[1][1]
    elsif board[2][0] == board[2][2] and board[2][1] == board[2][2] and not board[2][1] == nil
      @player = board[2][2]
    end
  end

  # Establishes winner in columns
  def check_columns_for_winner
    # @player = nil
    if board[0][0] == board[1][0] and board[1][0] == board[2][0] and not board[0][0] == nil
      @player = board[0][0]
    elsif board[0][1] == board[1][1] and board[1][1] == board[2][1] and not board[0][1] == nil
      @player = board[0][1]
    elsif board[0][2] == board[1][2] and board[1][2] == board[2][2] and not board[0][2] == nil
      @player = board[0][2]
    end
  end

  # Establishes winner diagonally
  def check_diagonals_for_winner
    # @player = nil
    if board[0][0] == board[1][1] and board[1][1] == board[2][2] and not board[1][1] == nil
      @player = board[1][1]
    elsif board[0][2] == board[1][1] and board[1][1] == board[2][0] and not board[1][1] == nil
      @player = board[1][1]
    end
  end

end
