class Class
  def attr_accessor_with_history(attr_name)
    attr_name = attr_name.to_s # Garante que o nome do atributo seja uma string

    # Cria o getter para o atributo (ex: def bar; @bar; end)
    attr_reader attr_name
    
    # Cria o getter para o histórico do atributo (ex: def bar_history; @bar_history; end)
    attr_reader attr_name + "_history"

    # Usa class_eval para definir o método setter dinamicamente.
    # %Q{...} é usado para criar uma string de múltiplas linhas que permite interpolação.
    class_eval %Q{
      def #{attr_name}=(value)
        # O nome da variável de instância que armazena o histórico
        history_var = "@#{attr_name}_history"

        # Inicializa a variável de histórico com [nil] se ela ainda não existir.
        # O operador ||= executa a atribuição apenas se a variável for nil ou false.
        instance_variable_set(history_var, [nil]) unless instance_variable_defined?(history_var)

        # Adiciona o novo valor ao final do array de histórico.
        instance_variable_get(history_var) << value

        # Define o valor atual na variável de instância principal.
        instance_variable_set("@#{attr_name}", value)
      end
    }
  end
end

# --- Exemplo de uso ---
class Foo
  attr_accessor_with_history :bar
end

# Testando com a primeira instância
f = Foo.new
puts "Histórico inicial de f: #{f.bar_history.inspect}" # => nil (porque o getter retorna o valor da variável de instância, que é nil)

f.bar = 3
f.bar = :wowzo
f.bar = 'boo!'
puts "Valor atual de f.bar: #{f.bar}"                     # => 'boo!'
puts "Histórico final de f: #{f.bar_history.inspect}"   # => [nil, 3, :wowzo, "boo!"]

puts "---"

# Testando com uma segunda instância para garantir que o histórico é separado
g = Foo.new
g.bar = 1
g.bar = 2
puts "Valor atual de g.bar: #{g.bar}"                     # => 2
puts "Histórico de g: #{g.bar_history.inspect}"           # => [nil, 1, 2]

# Verificando que o histórico de 'f' não foi alterado
puts "Histórico de f ainda é: #{f.bar_history.inspect}"   # => [nil, 3, :wowzo, "boo!"]
