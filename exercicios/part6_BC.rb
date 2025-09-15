class String
  def palindrome?
    # 'self' aqui se refere à instância da string ("foo", por exemplo)
    clean_string = self.downcase.gsub(/\W/, '')
    clean_string == clean_string.reverse
  end
end

module Enumerable
  def palindrome?
    # self.to_a converte qualquer enumerável para um array.
    # Em seguida, comparamos o array com sua versão invertida.
    self.to_a == self.to_a.reverse
  end
end

# Testes realizados
# puts "[1,2,3,2,1].palindrome? #=> #{"[1,2,3,2,1]".palindrome?}" # String.palindrome?
puts [1,2,3,2,1].palindrome?      #=> true
puts [1,2,3,4,5].palindrome?      #=> false
puts (1..5).to_a.palindrome?     #=> false (Range convertido para Array)
puts ["a","b","a"].palindrome?    #=> true

# Testes realizados
puts "'A man, a plan, a canal -- Panama'.palindrome? #=> #{"A man, a plan, a canal -- Panama".palindrome?}"
puts "'Abracadabra'.palindrome? #=> #{"Abracadabra".palindrome?}"
