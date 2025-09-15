class WrongNumberOfPlayersError < StandardError; end
class NoSuchStrategyError < StandardError; end

def rps_game_winner(game)
  # 1. Validação do número de jogadores (já fornecida)
  raise WrongNumberOfPlayersError unless game.length == 2

  player1 = game[0]
  player2 = game[1]
  
  move1 = player1[1].upcase
  move2 = player2[1].upcase

  # 2. Validação da estratégia
  valid_moves = ['R', 'P', 'S']
  unless valid_moves.include?(move1) && valid_moves.include?(move2)
    raise NoSuchStrategyError, "Strategy must be one of R, P, S"
  end

  # 3. Lógica do Jogo
  # Se as jogadas forem iguais, o jogador 1 vence por padrão
  return player1 if move1 == move2

  # Combinações onde o jogador 1 vence
  case move1
  when 'R'
    return player1 if move2 == 'S'
  when 'S'
    return player1 if move2 == 'P'
  when 'P'
    return player1 if move2 == 'R'
  end

  # Se o jogador 1 não venceu, o jogador 2 é o vencedor
  return player2
end

# Testes para verificar se as excecoes e o codigo estao funcionando adequadamente
game1 = [ [ "Kristen", "P" ], [ "Pam", "S" ] ]
puts "Vencedor do Jogo 1: #{rps_game_winner(game1).inspect}" # Deve ser ["Pam", "S"]

game2 = [ [ "Dave", "R" ], [ "Michael", "R" ] ]
puts "Vencedor do Jogo 2: #{rps_game_winner(game2).inspect}" # Deve ser ["Dave", "R"]

game3 = [ [ "Dave", "R" ], [ "Michael", "R" ] , ["Luiza", "S"]] # tirar o comentario para testar um de cada vez as excecoes
# puts "Vencedor do Jogo 3: #{rps_game_winner(game3).inspect}" # Deve ser WrongNumberOfPlayersError unless game.length == 2

game4 = [ [ "Dave", "R" ], [ "Michael", "K" ] ] # tirar o comentario para testar um de cada vez as excecoes
# puts "Vencedor do Jogo 3: #{rps_game_winner(game4).inspect}" # Deve ser NoSuchStrategyError, "Strategy must be one of R, P, S"