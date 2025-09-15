

# Relatório de Estudo Dirigido: Como LLMs podem promover o aprendizado e o desenvolvimento de aplicações Ruby?

**Autor:** [Célio Júnio de Freitas Eduardo]
**Repositório GitHub:** [(https://github.com/celio-eduardo/aprendizagemComRuby_ENGSOFT)]

## Introdução

Este relatório apresenta uma análise sobre a utilização de Modelos de Linguagem de Grande Porte (LLMs) como ferramenta de apoio no processo de aprendizado da linguagem de programação Ruby e no desenvolvimento de soluções de software. Utilizando como base os exercícios propostos no "Homework 01: Ruby calisthenics", este estudo documenta não apenas as resoluções dos problemas, mas também explora as estruturas de dados e algoritmos empregados, propõe implementações alternativas e avalia o impacto do uso de um LLM no tempo e esforço de desenvolvimento. O objetivo é demonstrar, de forma prática, como a interação com uma IA pode acelerar a compreensão de novos conceitos, otimizar códigos e aprofundar o conhecimento sobre paradigmas e funcionalidades específicas do Ruby.

-----

## Parte 1: Resolução dos Exercícios (Homework 01)

A seguir, estão as soluções desenvolvidas para as Partes 01 a 06 do Homework 01.

### Exercício 1A: `palindrome?`

```ruby
def palindrome?(string)
  # 1 - Limpeza da string: vai converter cada caracter para minúsculo e remover os que são não-alfanuméricos.
  clean_string = string.downcase.gsub(/\W/, '') 
    # 2 - remover os "nonword characters" 
    # A expressão regular \W (W maiúsculo) corresponde a qualquer caractere que não seja uma letra, número ou underscore. Usaremos
    # gsub(/\W/, '') para substituir todas as ocorrências desses caracteres por uma string vazia, efetivamente removendo-os.

  # 3 - Para comparar a string limpa com sua versão invertida.
  # Resultado (true ou false) é retornado implicitamente.
  clean_string == clean_string.reverse
end
```

### Exercício 1B: `count_words`

```ruby
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
```

### Exercício 2: Rock-Paper-Scissors

```ruby
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
```

### Exercício 3: Anagrams

```ruby
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
```

### Exercício 4: Basic OOP

```ruby
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
```

### Exercício 5: Advanced OOP (Metaprogramming)

```ruby
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
```

### Exercício 6: Advanced OOP (Open Classes and Duck Typing)

**Parte 6A: Currency Conversion**

```ruby
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
```

**Partes 6B e 6C: Palindromes on `String` and `Enumerable`**

```ruby
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
```

-----

## Parte 2: Explicação das Estruturas e Algoritmos

Esta seção detalha a lógica por trás de cada solução.

  * **Exercício 1A (`palindrome?`):** O algoritmo foca em "limpar" a string de entrada para que a comparação seja justa. Primeiro, a string é convertida para minúsculas com `downcase`. Em seguida, o método `gsub` com a expressão regular `/\W/` remove todos os caracteres que não são letras ou números. Finalmente, a string limpa é comparada com sua versão invertida (`reverse`). A beleza desta solução está no encadeamento de métodos, um idioma comum em Ruby.

  * **Exercício 1B (`count_words`):** A estratégia aqui é usar um `Hash` para armazenar as palavras e suas contagens. `Hash.new(0)` é um truque útil que define 0 como o valor padrão para qualquer chave nova, evitando a necessidade de verificar se a chave já existe antes de incrementar. A string é padronizada para minúsculas e o método `scan(/\w+/)` extrai todas as sequências de caracteres de "palavra" para um array. O iterador `each` percorre este array, incrementando a contagem de cada palavra no hash.

  * **Exercício 2 (Rock-Paper-Scissors):** A função implementa a lógica do jogo e a validação de entradas. Primeiro, ela verifica se há exatamente dois jogadores, levantando um `WrongNumberOfPlayersError` caso contrário. Em seguida, valida se as jogadas são 'R', 'P' ou 'S' (insensível a maiúsculas/minúsculas), lançando um `NoSuchStrategyError` se uma jogada inválida for encontrada. A lógica de vitória é implementada com uma estrutura `case`, que é uma forma limpa de lidar com múltiplas condições. Se as jogadas são iguais, o primeiro jogador vence por regra.

  * **Exercício 3 (`combine_anagrams`):** Esta é uma solução elegante que explora o paradigma funcional. O método `group_by` do módulo `Enumerable` é a estrela aqui. Ele itera sobre a coleção de palavras e agrupa os elementos com base no valor retornado pelo bloco. A "chave canônica" para um grupo de anagramas é a string com suas letras ordenadas alfabeticamente e em minúsculas (ex: "cars" e "racs" ambos se tornam "acrs"). `group_by` retorna um hash onde as chaves são essas formas canônicas e os valores são arrays das palavras originais. Finalmente, `.values` extrai apenas os arrays de anagramas[cite: 94].

  * **Exercício 4 (OOP):** Este exercício introduz os conceitos de classes, herança e polimorfismo em Ruby. A classe `Dessert` usa `attr_accessor` para criar automaticamente os métodos *getter* e *setter* para os atributos `@name` e `@calories`. A classe `JellyBean` herda de `Dessert` usando `<` e chama o construtor da classe pai com `super`. O método `delicious?` é sobrescrito em `JellyBean` para adicionar uma lógica específica: ele retorna `false` apenas se o sabor for "black licorice", demonstrando o polimorfismo.

  * **Exercício 5 (Metaprogramming):** Aqui, exploramos a metaprogramação em Ruby, modificando o comportamento da própria classe `Class` (uma *open class*). O método `attr_accessor_with_history` define dinamicamente um *setter* para um atributo. Ele usa `class_eval` para injetar uma string de código como um método na classe que o chama. Este novo *setter* faz duas coisas: atualiza o valor da variável de instância (ex: `@bar`) e adiciona o novo valor a um array de histórico (ex: `@bar_history`). O uso de `instance_variable_set` e `instance_variable_get` permite manipular as variáveis de instância dinamicamente, com base em nomes de string.

  * **Exercício 6 (Open Classes & Duck Typing):**

      * **6A:** Demonstra o poder das *open classes* ao adicionar novos métodos à classe `Numeric` nativa do Ruby. `method_missing` é um método especial chamado quando se tenta invocar um método inexistente. Nós o interceptamos para criar uma sintaxe fluente (ex: `5.dollars`). Ele converte o valor para uma taxa base (dólares). O método `in` então usa essa base para converter para a moeda de destino.
      * **6B/6C:** A solução para 6B é trivial: o código de `palindrome?` do exercício 1A é movido para dentro da classe `String`. Para 6C, o conceito de *Duck Typing* é aplicado. Em vez de uma classe específica, modificamos o módulo `Enumerable`. Qualquer classe que inclua `Enumerable` (como `Array`, `Range`, `Hash`) e se comporte como uma coleção (ou seja, "quacks like a duck") ganhará o método `palindrome?`. O método `to_a` garante que estamos trabalhando com um array, que pode ser facilmente comparado com sua versão invertida.

-----

## Parte 3: Implementações Alternativas

### Exercício 1B: `count_words`

**Alternativa Funcional (mais idiomática):**

```ruby
def count_words_functional(string)
  words = string.downcase.scan(/\w+/)
  # O método `each_with_object` cria um objeto (um Hash vazio) e o passa para o bloco
  # a cada iteração. O valor de retorno do bloco é descartado, mas o objeto é retornado no final.
  words.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
end
```

  * **Vantagens:**
      * **Mais conciso e declarativo:** Descreve *o que* fazer (transformar uma lista de palavras em um hash de contagem) em vez de *como* fazer (inicialize um hash, itere, adicione).
      * **Evita mutação explícita:** A variável `counts` não é modificada fora do escopo do bloco, o que pode tornar o código mais fácil de raciocinar.
  * **Desvantagens:**
      * Pode ser menos intuitivo para iniciantes que estão mais acostumados com o paradigma imperativo (loops `for`/`each`).

### Exercício 3: `combine_anagrams`

**Alternativa Imperativa:**

```ruby
def combine_anagrams_imperative(words)
  anagram_groups = {} # Usando um hash como um mapa temporário

  words.each do |word|
    key = word.downcase.chars.sort.join
    # Inicializa a chave com um array vazio se ela não existir
    anagram_groups[key] ||= []
    anagram_groups[key] << word
  end

  return anagram_groups.values
end
```

  * **Vantagens:**
      * **Mais explícito:** O fluxo de controle é passo a passo e pode ser mais fácil de depurar para quem não está familiarizado com `group_by`.
  * **Desvantagens:**
      * **Mais verboso:** Requer mais linhas de código e gerenciamento manual do hash (`||=`).
      * **Menos idiomático em Ruby:** A comunidade Ruby prefere abordagens funcionais para operações em coleções, como `group_by`, `map`, `select`, etc.

### Exercício 6C: `palindrome?` em `Enumerable` (sem `to_a`)

**Alternativa usando `yield` (mais avançado, conceitual):**

Esta abordagem é mais teórica, pois `Enumerable` já nos dá `to_a`. Mas, para ilustrar, poderíamos criar nosso próprio iterador.

```ruby
# Esta implementação não seria em Enumerable, mas em uma classe própria
# para ilustrar como o yield poderia ser usado.

class MyCollection
  include Enumerable # Para ter acesso a .reverse_each

  def initialize(items)
    @items = items
  end
  
  # O método each é o contrato para o mixin Enumerable
  def each
    return enum_for(:each) unless block_given? # Permite chamar .each sem bloco
    @items.each { |item| yield item }
  end

  def palindrome?
    # Usando os iteradores que o Enumerable nos dá (baseados no nosso each)
    # self.to_a == self.reverse_each.to_a  (é quase a mesma coisa da solução original)
    
    # Uma abordagem manual sem converter tudo para array de uma vez:
    fwd_iterator = self.each
    rev_iterator = self.reverse_each
    
    loop do
      begin
        fwd_item = fwd_iterator.next
        rev_item = rev_iterator.next
        return false if fwd_item != rev_item
      rescue StopIteration
        # Chegamos ao fim de um dos iteradores (ou ambos)
        break
      end
    end
    true # Se o loop terminar, é um palíndromo
  end
end
```

  * **Vantagens:**
      * **Potencialmente mais eficiente em memória:** Para coleções *extremamente grandes*, esta abordagem não cria duas cópias completas da coleção em memória (`to_a` e `to_a.reverse`). Ela compara elemento por elemento.
  * **Desvantagens:**
      * **Complexidade:** O código é significativamente mais complexo e difícil de entender.
      * **Desnecessário na maioria dos casos:** A simplicidade e clareza da solução original (`self.to_a == self.to_a.reverse`) superam em muito os ganhos de performance para coleções de tamanho normal.

-----

## Parte 4: Análise de Tempo, Esforço e Feedback

Com o auxílio de uma IA, obtém-se um ganho no entendimento inicial, pois o objetivo geral do problema e as diversas estratégias de solução são apresentados mais rapidamente. Contudo, essa ajuda é parcial, pois parte do trabalho de raciocínio e resolução de problemas é perdido no processo de construção da solução. Torna-se necessário, então, ponderar quando essa assistência é relevante. Fiquei com a impressão de que precisarei revisitar este tipo de código para assimilar melhor a lógica, mesmo com a vantagem de ele já vir bem comentado desde o início.

Enfim, é algo que deve ser levado em conta durante o uso, pois o aprendizado geral fica definitivamente comprometido. A sensação é comparável a jogar um videogame com um guia nas fases mais importantes, enquanto exploramos um mapa livremente apenas nas partes que não exigem o uso dessas ferramentas. Posteriormente, podemos ficar com a impressão de que não aproveitamos o processo de construção da solução.

### Análise do Processo de Desenvolvimento

* **Entendimento do Problema:**
    A compreensão foi rápida, pois não eram problemas novos; a maioria já havia sido resolvida na disciplina de Algoritmos e Programação de Computadores (APC). O desafio foi mais um processo de construir uma solução usando outra linguagem, mas agora com acesso a uma versão muito superior do que era o Stack Overflow. Não precisei de tanta ajuda na elaboração da lógica, mas sim na sintaxe. Foi como usar um tradutor durante uma viagem a um país com uma língua diferente: você sabe o que quer dizer e solicita auxílio nas partes em que a confiança é menor.

* **Desenvolvimento da Solução Inicial:**
    Foi bastante simples. Eu tinha uma versão base em pseudocódigo e fui solicitando ajuda para encontrar os equivalentes em Ruby. Fiquei surpreso com o iterador `each`, que me pareceu muito prático de usar, embora um pouco confuso para entender a lógica implícita de como ele percorre os elementos de uma coleção. Não houve um processo de tentativa e erro, pois a primeira versão já contemplava os casos de falha pertinentes. Nesta fase do curso, acredito que problemas de lógica são menos comuns do que no início da graduação.

* **Análise Crítica e Refatoração:**
    A refatoração e a melhoria do código foram feitas, sim, com um auxílio mais presente de um LLM. Nesta etapa, eu já não estava tão confiante sobre como usar perfeitamente os diferentes paradigmas, pois nos acostumamos com o procedural e a orientação a objetos, tendo menos contato com o funcional — que geralmente leva mais tempo para ser implementado e testado. A IA teve uma presença marcante nas sugestões de métodos e abordagens que o Ruby oferece, mas que eu não conhecia. Mesmo com o livro fornecendo muitas dessas informações, precisei de ajuda com exemplos de implementação. A partir deles, eu podia adaptar o código para a solução que desejava. O livro serviu como um ótimo suporte, e o LLM ajudou a aplicar de forma prática o que já estava bem ensinado no material.

### Feedback Final sobre a Experiência

* A experiência se mostrou muito boa. Aprendi bastante e fui mais rápido do que em outras ocasiões, mas fica a ressalva de que provavelmente precisarei revisar o conteúdo mais vezes para garantir a retenção. Basicamente, ganhei tempo na entrega final, mas perdi na fixação que teria ao dedicar mais tempo à solução. Muitas vezes, o processo importa mais do que o resultado.
* As explicações rápidas e os exemplos variados também foram muito úteis para acelerar o projeto. A qualquer momento, eu podia pedir um novo exemplo e receber uma explicação diferente, à qual eu poderia me adaptar mais facilmente. Isso, definitivamente, é uma grande vantagem de usar um LLM.
* Com o auxílio de LLMs, sinto-me confiante para desenvolver soluções em praticamente qualquer linguagem. Eles se tornaram um "canivete suíço" que traduz diferentes contextos rapidamente. Isso fortalece quem já possui uma base em lógica e outros conceitos da computação, nos dando ainda mais suporte para desenvolver soluções pertinentes quando necessário.

-----

## Conclusão

Este estudo demonstrou que a utilização de um LLM pode ser um catalisador significativo no aprendizado e desenvolvimento em Ruby. Ao servir como uma fonte instantânea de consulta, um parceiro de refatoração e um proponente de soluções alternativas, o LLM permitiu não apenas a resolução eficiente dos problemas propostos, mas também um aprofundamento nos conceitos idiomáticos da linguagem, desde o paradigma funcional em coleções até tópicos avançados como metaprogramação e *duck typing*. Embora a necessidade de um olhar crítico por parte de quem está solicitando a ajuda permaneça fundamental, a experiência valida o LLM como uma ferramenta poderosa para reduzir a curva de aprendizado e aumentar a produtividade.
