package solucao

import "core:time"
//import "core:os"
import "core:fmt"
import lb "nucleo:labirinto"

clear_terminal :: proc() {
    fmt.println("\x1b[2J")
}

visualizar_solucao::proc(labirinto: ^lb.Labirinto, arestas_relacao: map[int] [dynamic]lb.Coordenada, nos_relacao: map[int] lb.Coordenada, passos: [dynamic]^PilhaPassos, solucao: ^PilhaPassos) {
    
    for passo in passos {
        clear_terminal()
        fmt.println("Passos seguidos:")
        for aresta := pop(passo); aresta != nil; aresta = pop(passo) {
            for c in arestas_relacao[aresta.valor] {
                lb.visitar_celula(labirinto,c)
            }

            c1 := nos_relacao[aresta.no1.valor]
            c2 := nos_relacao[aresta.no2.valor]

            if lb.pegar_celula(labirinto,c1) == lb.ComponenteLabirinto.caminho {
                lb.visitar_celula(labirinto,c1)
            }

            if lb.pegar_celula(labirinto,c2) == lb.ComponenteLabirinto.caminho {
                lb.visitar_celula(labirinto,c2)
            }
        }

        lb.imprimir_labirinto(labirinto)
        time.sleep(time.Millisecond*200)
        lb.limpar_caminhos_visitados(labirinto)
    }

    clear_terminal()

    fmt.println("Solução encontrada:")
    for aresta := pop(solucao); aresta != nil; aresta = pop(solucao) {
        for c in arestas_relacao[aresta.valor] {
            lb.visitar_celula(labirinto,c)
        }

        c1 := nos_relacao[aresta.no1.valor]
        c2 := nos_relacao[aresta.no2.valor]

        if lb.pegar_celula(labirinto,c1) == lb.ComponenteLabirinto.caminho {
            lb.visitar_celula(labirinto,c1)
        }

        if lb.pegar_celula(labirinto,c2) == lb.ComponenteLabirinto.caminho {
            lb.visitar_celula(labirinto,c2)
        }
    }

    lb.imprimir_labirinto(labirinto)
    time.sleep(time.Millisecond*200)
    lb.limpar_caminhos_visitados(labirinto)
}