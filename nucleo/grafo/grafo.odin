package grafo

import ferr "ferramentas:matrizes"

/*
 Grafo que representa o labirinto a ser solucionado
 O campo inicio representa o ponto de partida dentro do labirinto,
 e o campo fim representa o ponto de chegada do labirinto.
 O campo nos é a lista de nós do grafo, excluindo os nós de início e de fim.
 O campo aresta é a lista de arestas existentes no grafo.
 Pode ser um pouco redundante, mas informação nunca é demais
 */
Grafo :: struct {
    inicio,fim: ^No, //importante explicar que os nós de início e de fim não estão inclusos na lista de nós
    nos: [dynamic]^No,
    arestas: [dynamic]^Aresta
}


/*
 Retorna o nó do grafo especificado que possui o valor especificado.
 Caso o nó não seja encontrado, retorna nil.
 */
pegar_no::proc(grafo:^Grafo, valor:int) -> ^No {
    if grafo.inicio.valor == valor {
        return grafo.inicio
    }

    if grafo.fim.valor == valor {
        return grafo.fim
    }

    for no in grafo.nos {
        if no.valor == valor {
            return no
        }
    }

    return nil
}

/*
 Retorna a aresta do grafo especificado que possui o valor especificado.
 Caso a aresta não seja encontrada, retorna nil.
 */
pegar_aresta::proc(grafo:^Grafo, valor:int) -> ^Aresta {
    for aresta in grafo.arestas {
        if aresta.valor == valor {
            return aresta
        }
    }

    return nil
}

/*
  Cria uma matriz de adjacencia para o grafo passado como parametro.
  Retorna a matriz de adjancencia, onde as linhas e as colunas são os valores dos nós do grafo
  caso o valor de uma celula seja 1, significa que há uma aresta que conecta aqueles pontos
 */
criar_matriz_adjacencia::proc(grafo: ^Grafo) -> [][]i8 {
    tamanho := len(grafo.nos)+2
    matriz_adjacencia := ferr.create_matrix(i8,tamanho,tamanho) //crio a matriz de adjacencia com o tamanho do grafo

    for i in 0..<tamanho {
        for j in 0..<tamanho{
            matriz_adjacencia[i][j] = 0 //preencho todos os valores com false
        }
    }

    for aresta in grafo.arestas {
        matriz_adjacencia[aresta.no1.valor][aresta.no2.valor] = 1
        matriz_adjacencia[aresta.no2.valor][aresta.no1.valor] = 1
    }
    
    return matriz_adjacencia
}

/*
 Cria uma matriz de incidencia a partir do grafo passado como parametro
 As linhas são os pontos e as colunas são as arestas. Caso o valor da celula correspondente a linha e a aresta seja 1, quer dizer que aquela aresta incide naquele ponto
 */
criar_matriz_incidencia::proc(grafo: ^Grafo) -> [][]i8 {
    n := len(grafo.nos)+2
    m := len(grafo.arestas)

    matriz_incidencia := ferr.create_matrix(i8,n,m)

    for i in 0..<n {
        for j in 0..<m {
            matriz_incidencia[i][j] = 0
        }
    }

    for aresta in grafo.arestas {
        no1 := aresta.no1
        no2 := aresta.no2

        matriz_incidencia[no1.valor][aresta.valor] = 1
        matriz_incidencia[no2.valor][aresta.valor] = 1
    }

    return matriz_incidencia
}

/*
  Construtor de um grafo. Os nós de início e de fim são definidor de antemão,
  afinal de contas, pro grafo ser montado, primeiro é importante definir os nós e conectar eles
 */
create_grafo::proc(inicio,fim:^No, nos:[dynamic]^No, arestas:[dynamic]^Aresta) -> ^Grafo {
    novo_grafo := new(Grafo)
    novo_grafo.nos = nos
    novo_grafo.arestas = arestas
    novo_grafo.inicio = inicio
    novo_grafo.fim = fim

    return novo_grafo
}

// Pense bem antes de destruir o grafo inteiro, porque isso destrói o grafo junto com todos os seus nós e arestas.
destroy_grafo::proc(ptr_grafo:^^Grafo) {
    if ptr_grafo == nil {return}
    if ptr_grafo^ == nil {return}
    
    grafo := ptr_grafo^

    for i in 0..<len(grafo.nos) {
        destroy_no(&grafo.nos[i])
    }

    for i in 0..<len(grafo.arestas) {
        destroy_aresta(&grafo.arestas[i])
    }

    destroy_no(&grafo.inicio)
    destroy_no(&grafo.fim)

    delete(grafo.arestas)
    delete(grafo.nos)
    free(grafo)

    ptr_grafo^ = nil
}