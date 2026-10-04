package labirinto

import gf "nucleo:grafo"

/*
 Percorre a matriz do labirinto, tentanto encontrar os nós
 Ao concluir, retorna a lista de nós, o nó inicial, o nó final e uma relação do valor dos nós para seu ponto na matriz.
 No labirinto, todos os pontos dos nós também vão estar marcados como visitados
 */
pegar_pontos::proc(l: ^Labirinto) -> ([dynamic]^gf.No, ^gf.No, ^gf.No, map[int] Coordenada) {
    //primeiro, vamos definir uma relação de pontos para mapas
    relacao_de_pontos := make(map[int] Coordenada) //esse mapa vai guardar uma relação do valor do nó para a coordenada da sua célula no labirinto
    nos := make([dynamic]^gf.No)
    no_inicio: ^gf.No
    no_fim: ^gf.No

    contador_nos := 0
    coordenada := Coordenada{i = 0, j = 0}

    for linha in l.matriz {
        for celula in linha {
            //vamos então, verificar célula a célula os seus vizinhos. as células de início e de fim obrigatóriamente serão nós
            //celulas de parede serão ignoradas aqui
            //nas células de caminho, vamos verificar quantas vizinhas elas possuem. caso seja um valor diferente de 2,
            //significa que a célula é um nó

            #partial switch celula {
                case ComponenteLabirinto.inicio:
                    no_inicio = gf.create_no(contador_nos)
                    relacao_de_pontos[contador_nos] = coordenada
                    contador_nos += 1
                
                case ComponenteLabirinto.fim:
                    no_fim = gf.create_no(contador_nos)
                    relacao_de_pontos[contador_nos] = coordenada
                    contador_nos += 1
                
                case ComponenteLabirinto.caminho:
                    if contar_vizinhos(l, coordenada) != 2 {
                        novo_no := gf.create_no(contador_nos)
                        visitar_celula(l,coordenada)

                        append(&nos, novo_no)
                        relacao_de_pontos[contador_nos] = coordenada
                        contador_nos += 1
                    }
            }

            coordenada.j += 1
        }

        coordenada.j = 0
        coordenada.i += 1
    }

    return nos,no_inicio,no_fim,relacao_de_pontos
}

contar_vizinhos::proc(labirinto: ^Labirinto, coordenada: Coordenada) -> int {
    vizinhos := 0

    cima := em_cima(coordenada)
    baixo := em_baixo(coordenada)
    esquerda := a_esquerda(coordenada)
    direito := a_direita(coordenada)

    //verificamos em cima
    if verifica_coordenada(labirinto,cima){
        vizinho := pegar_celula(labirinto,cima)
        if  vizinho == ComponenteLabirinto.caminho ||
            vizinho == ComponenteLabirinto.inicio ||
            vizinho == ComponenteLabirinto.fim ||
            vizinho == ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    //verificamos embaixo
    if verifica_coordenada(labirinto,baixo){
        vizinho := pegar_celula(labirinto,baixo)
        if  vizinho == ComponenteLabirinto.caminho ||
            vizinho == ComponenteLabirinto.inicio ||
            vizinho == ComponenteLabirinto.fim ||
            vizinho == ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    //verificamos na esquerda
    if verifica_coordenada(labirinto,esquerda){
        vizinho := pegar_celula(labirinto,esquerda)
        if  vizinho == ComponenteLabirinto.caminho ||
            vizinho == ComponenteLabirinto.inicio ||
            vizinho == ComponenteLabirinto.fim ||
            vizinho == ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    //e também na direita
    if verifica_coordenada(labirinto,direito){
        vizinho := pegar_celula(labirinto,direito)
        if  vizinho == ComponenteLabirinto.caminho ||
            vizinho == ComponenteLabirinto.inicio ||
            vizinho == ComponenteLabirinto.fim ||
            vizinho == ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    return vizinhos
}