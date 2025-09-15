def count_words(string)
  # Cria um novo Hash. Se uma chave for acessada e não existir,
  # seu valor inicial será 0. Assim elimina a verificacao da chave existir ou nao.
  counts = Hash.new(0)

  # Converte a string para minúsculas e usa scan com a regex \w+
  # para extrair todas as "palavras" em um array.
  words = string.downcase.scan(/\w+/)

  # Itera sem usar o for ou while sobre o array de palavras. Para cada palavra,
  # incrementa seu valor correspondente no hash, que é o que o exercício pede.
  words.each do |word|
    counts[word] += 1
  end

  # Retorno final do hash com as quantidades de cada palavra no array.
  return counts
end

# Testes para verificacao do funcionamento
puts count_words("A man, a plan, a canal -- Panama").inspect
# Deve retornar: {"a"=>3, "man"=>1, "plan"=>1, "canal"=>1, "panama"=>1}

puts count_words("Doo bee doo bee doo").inspect
# Deve retornar: {"doo"=>3, "bee"=>2}

puts count_words("Ipsis literis adverbium canaris literis Ipsis")
# Deve retornar: {"ipsis"=>2, "literis"=>2, "adverbium"=>1, "canaris"=>1}
