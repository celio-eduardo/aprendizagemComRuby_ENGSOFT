class Numeric
  # O @@ indica uma variável de classe, compartilhada por todas as instâncias de Numeric.
  @@currencies = {'dollar' => 1.0, 'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019}

  # method_missing é chamado quando um método que não existe é invocado em um objeto.
  def method_missing(method_id)
    # Remove o 's' do final para lidar com singular e plural (ex: :dollars -> "dollar")
    singular_currency = method_id.to_s.gsub( /s$/, '')
    
    # Se a moeda existir no nosso hash, converte o número para dólares
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      # Se não for uma moeda, chama o comportamento padrão de method_missing (geralmente um erro)
      super
    end
  end

  # O método 'in' converte o valor (que já está em dólares) para a moeda de destino.
  def in(target_currency)
    singular_currency = target_currency.to_s.gsub( /s$/, '')
    # Para converter de dólares para outra moeda, dividimos pela taxa de conversão.
    self / @@currencies[singular_currency]
  end
end

# Testes realizados
puts "5 dollars in euros: #{5.dollars.in(:euros)}"   # => 3.870
puts "10 euros in rupees: #{10.euros.in(:rupees)}" # => 680.0

# Testando singular e plural
puts "1 dollar in rupees: #{1.dollar.in(:rupees)}" # => 52.63
