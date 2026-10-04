package labirinto

import gf "nucleo:grafo"

/*
 procedimento para pegar as arestas de um labirinto. Observe que para ele funcionar corretamente, é necessário que:
 * Você primeiro execute a função pegar_pontos no mesmo labirinto
 * Você não limpe os caminhos visitados do labirinto depois de executar o procedimento anterior
 * Você inclua na lista de pontos, o ponto de início e de fim. Essa função não vai diferenciar essses nós dos demais
 */
pegar_arestas::proc(l:^Labirinto, no_inicio,no_fim: ^gf.No, nos: [dynamic]^gf.No, relacao_nos: map[int] Coordenada) -> ([dynamic]^gf.Aresta,map[int] [dynamic] Coordenada){
    lista_arestas := make([dynamic]^gf.Aresta)
    relacao_arestas := make(map[int] [dynamic]Coordenada) //precisamos de uma relação da lista de coordenadas pra cada aresta
    coordenada_inicio := relacao_nos[no_inicio.valor]
    coordenada_fim := relacao_nos[no_fim.valor]

    //primeiro, vamos de nó em nó
    contar_arestas := 0
    for no in nos {
        //para cada nó, vamos tentar pegar suas arestas. Para isso, vamos pegar sua coordenada no labirinto:
        coordenada := relacao_nos[no.valor]
        //agora, vamos verficar cada uma das direções da coordenada
        //nas direções em que o vizinho for um 

        //verificamos em cima
        if vizinho := em_cima(coordenada); verifica_coordenada(l,vizinho) {
           if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                coor1:= caminho_coordenadas[0]
                coor2:= caminho_coordenadas[len(caminho_coordenadas)-1]

                peso: f16
                peso1 := (distancia_coordendas(coor1,coordenada_inicio) + distancia_coordendas(coor2,coordenada_fim))
                peso2 := (distancia_coordendas(coor2,coordenada_inicio) + distancia_coordendas(coor1,coordenada_fim))

                if peso1 < peso2 {
                    peso = peso1
                } else {
                    peso = peso2
                }

                nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            } else if pegar_celula(l, vizinho) == ComponenteLabirinto.caminho_visitado ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.inicio ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.fim 
            {
                outro_no := no_da_coordenada(nos,relacao_nos,vizinho)
                if outro_no != nil {
                    peso: f16
                    peso1 := (distancia_coordendas(coordenada,coordenada_inicio) + distancia_coordendas(vizinho,coordenada_fim))
                    peso2 := (distancia_coordendas(vizinho,coordenada_inicio) + distancia_coordendas(coordenada,coordenada_fim))

                    if peso1 < peso2 {
                        peso = peso1
                    } else {
                        peso = peso2
                    }

                    nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                    contar_arestas += 1
                    append(&lista_arestas,nova_aresta)
                    relacao_arestas[nova_aresta.valor] = [dynamic]Coordenada{}
                }                
            }
        }

        //verificamos embaixo
        if vizinho := em_baixo(coordenada); verifica_coordenada(l,vizinho) {
           if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                coor1:= caminho_coordenadas[0]
                coor2:= caminho_coordenadas[len(caminho_coordenadas)-1]

                peso: f16
                peso1 := (distancia_coordendas(coor1,coordenada_inicio) + distancia_coordendas(coor2,coordenada_fim))
                peso2 := (distancia_coordendas(coor2,coordenada_inicio) + distancia_coordendas(coor1,coordenada_fim))

                if peso1 < peso2 {
                    peso = peso1
                } else {
                    peso = peso2
                }

                nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            } else if pegar_celula(l, vizinho) == ComponenteLabirinto.caminho_visitado ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.inicio ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.fim 
            {
                outro_no := no_da_coordenada(nos,relacao_nos,vizinho)
                if outro_no != nil {
                    peso: f16
                    peso1 := (distancia_coordendas(coordenada,coordenada_inicio) + distancia_coordendas(vizinho,coordenada_fim))
                    peso2 := (distancia_coordendas(vizinho,coordenada_inicio) + distancia_coordendas(coordenada,coordenada_fim))

                    if peso1 < peso2 {
                        peso = peso1
                    } else {
                        peso = peso2
                    }

                    nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                    contar_arestas += 1
                    append(&lista_arestas,nova_aresta)
                    relacao_arestas[nova_aresta.valor] = [dynamic]Coordenada{}
                }                
            }
        }

        //verificamos na esquerda
        if vizinho := a_esquerda(coordenada); verifica_coordenada(l,vizinho) {
           if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                coor1:= caminho_coordenadas[0]
                coor2:= caminho_coordenadas[len(caminho_coordenadas)-1]

                peso: f16
                peso1 := (distancia_coordendas(coor1,coordenada_inicio) + distancia_coordendas(coor2,coordenada_fim))
                peso2 := (distancia_coordendas(coor2,coordenada_inicio) + distancia_coordendas(coor1,coordenada_fim))

                if peso1 < peso2 {
                    peso = peso1
                } else {
                    peso = peso2
                }

                nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            } else if pegar_celula(l, vizinho) == ComponenteLabirinto.caminho_visitado ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.inicio ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.fim 
            {
                outro_no := no_da_coordenada(nos,relacao_nos,vizinho)
                if outro_no != nil {
                    peso: f16
                    peso1 := (distancia_coordendas(coordenada,coordenada_inicio) + distancia_coordendas(vizinho,coordenada_fim))
                    peso2 := (distancia_coordendas(vizinho,coordenada_inicio) + distancia_coordendas(coordenada,coordenada_fim))

                    if peso1 < peso2 {
                        peso = peso1
                    } else {
                        peso = peso2
                    }

                    nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                    contar_arestas += 1
                    append(&lista_arestas,nova_aresta)
                    relacao_arestas[nova_aresta.valor] = [dynamic]Coordenada{}
                }                
            }
        }

        //e também na direita
        if vizinho := a_direita(coordenada); verifica_coordenada(l,vizinho) {
           if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                coor1:= caminho_coordenadas[0]
                coor2:= caminho_coordenadas[len(caminho_coordenadas)-1]

                peso: f16
                peso1 := (distancia_coordendas(coor1,coordenada_inicio) + distancia_coordendas(coor2,coordenada_fim))
                peso2 := (distancia_coordendas(coor2,coordenada_inicio) + distancia_coordendas(coor1,coordenada_fim))

                if peso1 < peso2 {
                    peso = peso1
                } else {
                    peso = peso2
                }

                nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            } else if pegar_celula(l, vizinho) == ComponenteLabirinto.caminho_visitado ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.inicio ||
                pegar_celula(l, vizinho) == ComponenteLabirinto.fim 
            {
                outro_no := no_da_coordenada(nos,relacao_nos,vizinho)
                if outro_no != nil {
                    peso: f16
                    peso1 := (distancia_coordendas(coordenada,coordenada_inicio) + distancia_coordendas(vizinho,coordenada_fim))
                    peso2 := (distancia_coordendas(vizinho,coordenada_inicio) + distancia_coordendas(coordenada,coordenada_fim))

                    if peso1 < peso2 {
                        peso = peso1
                    } else {
                        peso = peso2
                    }

                    nova_aresta := gf.create_aresta(no,outro_no,peso,contar_arestas)
                    contar_arestas += 1
                    append(&lista_arestas,nova_aresta)
                    relacao_arestas[nova_aresta.valor] = [dynamic]Coordenada{}
                }                
            }
        }
    }

    for no in nos {
        i, j := relacao_nos[no.valor].i, relacao_nos[no.valor].j
        coordenada := Coordenada{i = i, j = j}
        if pegar_celula(l, coordenada) == ComponenteLabirinto.inicio || pegar_celula(l, coordenada) == ComponenteLabirinto.fim{continue}
        l.matriz[i][j] = ComponenteLabirinto.caminho
    }

    return lista_arestas,relacao_arestas
}

/*
 Para montar a aresta, precisamos saber qual o nó de onde a aresta está vindo, e também a lista de coordenadas que já visitamos
 Então, vamos verificar as células ao redor da coordenada, se a célula for um caminho, vamos marcar a coordenada atual
 como visitada, e vamos seguir para a próxima célula de caminho.
 Quando todas as células ao redor da coordenada não forem caminhos, ela vai verificar se existem dois caminhos_visitados.
 Se sim, significa que um deles é o nó da outra ponta da aresta, então, ela tenta pegar o nó correspondente a sua coordenada e retorna
 a lista de coordenadas coletadas até agora
 */
montar_aresta::proc(
    no_inicial: ^gf.No,
    anterior_coordenada, atual_coordenada: Coordenada,
    l: ^Labirinto,
    lista_coordenadas: [dynamic]Coordenada,
    nos: [dynamic]^gf.No,
    relacao_nos: map[int] Coordenada
) -> (^gf.No, [dynamic]Coordenada) {
    lista_coordenadas := lista_coordenadas //devido ao cu doce de odin, temos que sombrear essa variável
    //para montar uma aresta, temos que saber por qual caminho essa aresta continua
    coordenada_final : Coordenada //= Coordenada{i=-1,j=-1}
    visitar_celula(l,atual_coordenada) //ja podemos visitar a celula atual

    //agora vamos executar o passo a seguir para cada uma das direcoes
    //supomos que não deve haver risco de a coordenada ter mais de um vizinho como caminho
    if vizinho := em_cima(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado || 
            pegar_celula(l,vizinho) == ComponenteLabirinto.inicio || 
            pegar_celula(l,vizinho) == ComponenteLabirinto.fim {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    if vizinho := em_baixo(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado ||
            pegar_celula(l,vizinho) == ComponenteLabirinto.inicio || 
            pegar_celula(l,vizinho) == ComponenteLabirinto.fim  {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    if vizinho := a_esquerda(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado ||
            pegar_celula(l,vizinho) == ComponenteLabirinto.inicio || 
            pegar_celula(l,vizinho) == ComponenteLabirinto.fim   {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    if vizinho := a_direita(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado ||
            pegar_celula(l,vizinho) == ComponenteLabirinto.inicio || 
            pegar_celula(l,vizinho) == ComponenteLabirinto.fim   {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    //se chegou até aqui, significa que chegamos ao final da aresta, então, significa que a coordenada já foi definida, e podemos usar ele para encontrar
    //então, podemos adicionar ela a lista de coordenadas, e pegamos o seu nó correspondente

    append(&lista_coordenadas,atual_coordenada)
    no_final := no_da_coordenada(nos,relacao_nos,coordenada_final)

    return no_final,lista_coordenadas

}

no_da_coordenada::proc(nos: [dynamic]^gf.No, relacao_nos: map[int] Coordenada, c: Coordenada) -> ^gf.No {
    for index,num in relacao_nos {
        if num == c {
            for no in nos {
                if no.valor == index {
                    return no
                }
            }
        }
    }

    return nil
}

ponto_da_coordenada::proc(x_pos,y_pos: int,nos: []^gf.No, coordenadas: map[int] [2]int) -> ^gf.No {
    for index, coordenada in coordenadas {
        if x_pos == coordenada[0] && y_pos == coordenada[1] {
            for no in nos {
                if no.valor == index {
                    return no
                }
            }
        }
    }

    return nil
}