require_relative './computer'

class Game

  RULES = { rock: [:scissors, :lizard],
          paper: [:rock, :spock],
          scissors: [:paper, :lizard],
          lizard: [:paper, :spock],
          spock: [:rock, :scissors] }

  def self.game
    @game
  end

  def self.start_game(player1, player2)
    @game = self.new(player1, player2)
  end

  attr_reader :score, :result

  def initialize(player1, player2)
    @player1 = player1.id.to_sym
    @player2 = player2.id.to_sym
    @players = { @player1 => player1, @player2 => player2 }
    @score = [0,0]
    @result = {winner: nil, result: nil}
  end

  def ready?
    @players.all? { |id, player| player.has_weapon? }
  end

  def add_weapon(player_id, weapon)
    raise "Player already has a weapon" if @players[player_id].has_weapon?
    @players[player_id].set_weapon(weapon.to_sym)
    set_computer_weapon if one_player?
  end

  def play
    if draw?
      draw
    else
      @result[:winner] = :result
      @players[@player1].weapon.beats?(@players[@player2].weapon) ? set_winner(@player1) : set_winner(@player2)
    end
  end

  private

  def one_player?
    @players.any? { |id, player| player.is_a?(Computer) }
  end

  def set_computer_weapon
    @players.each { |id, player| player.set_weapon if player.is_a?(Computer) }
  end

  def draw
    @result[:winner] = nil
    @result[:result] = :draw
  end

  def draw?
    @players[@player1].weapon == @players[@player2].weapon
  end

  def set_winner(player_id)
    @result[:winner] = @players[player_id].name
    player_id == @player1 ? @score[0] += 1 : @score[1] += 1
  end

end