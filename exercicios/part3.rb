def combine_anagrams(words)
  # O método group_by itera sobre a lista de palavras.
  # Para cada palavra, ele executa o bloco e usa o resultado como uma chave de agrupamento.
  # A chave aqui é a versão da palavra em minúsculo, com suas letras ordenadas.
  # Ex: 'cars'.downcase.chars.sort.join => "acrs"
  # Ex: 'racs'.downcase.chars.sort.join => "acrs"
  # O resultado é um hash como: { "acrs" => ["cars", "racs", "scar"], ... }
  
  anagram_groups_hash = words.group_by do |word|
    word.downcase.chars.sort.join
  end

  # A tarefa pede um array de arrays, não um hash.
  # O método .values extrai apenas os valores do hash (que são os nossos grupos de anagramas).
  return anagram_groups_hash.values
end

# Testes realizados
input_words = ['cars', 'for', 'potatoes', 'racs', 'four', 'scar', 'creams', 'scream']
output_groups = combine_anagrams(input_words)

# A ordem dos grupos pode variar, mas o conteúdo estará correto.
puts output_groups.inspect
# => [["cars", "racs", "scar"], ["for"], ["potatoes"], ["four"], ["creams", "scream"]]