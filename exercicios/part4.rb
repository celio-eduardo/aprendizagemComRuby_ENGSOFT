class Dessert
  # Cria os métodos getter e setter para :name e :calories
  attr_accessor :name, :calories

  def initialize(name, calories)
    # Atribui os parâmetros às variáveis de instância
    @name = name
    @calories = calories
  end

  def healthy?
    # Retorna true se as calorias forem menores que 200
    @calories < 200
  end

  def delicious?
    # Por padrão, todas as sobremesas são deliciosas
    true
  end
end

class JellyBean < Dessert
  # Adiciona getter e setter para :flavor
  attr_accessor :flavor

  def initialize(name, calories, flavor)
    # Chama o initialize da classe pai (Dessert) para definir name e calories
    super(name, calories)
    # Define o atributo específico de JellyBean
    @flavor = flavor
  end

  def delicious?
    # Sobrescreve o método da classe pai.
    # A menos que o sabor seja "black licorice", continua sendo delicioso.
    if @flavor.downcase == 'black licorice'
      return false
    else
      return true
    end
  end
end

# Criando uma sobremesa comum
pudim = Dessert.new("Pudim", 180)
puts "#{pudim.name} é delicioso? #{pudim.delicious?}" # => true
puts "#{pudim.name} é saudável? #{pudim.healthy?}"     # => true

# Criando um JellyBean de cereja
jb_cereja = JellyBean.new("JellyBean", 150, "Cereja")
puts "#{jb_cereja.name} de #{jb_cereja.flavor} é delicioso? #{jb_cereja.delicious?}" # => true

# Criando um JellyBean de alcaçuz preto
jb_licorice = JellyBean.new("JellyBean", 100, "black licorice")
puts "#{jb_licorice.name} de #{jb_licorice.flavor} é delicioso? #{jb_licorice.delicious?}" # => false
