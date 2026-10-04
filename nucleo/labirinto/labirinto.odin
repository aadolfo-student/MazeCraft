package labirinto
import "core:fmt"
import "core:math"
import "nucleo:labirinto"

ComponenteLabirinto :: enum {
    inicio,
    caminho,
    caminho_visitado,
    parede,
    fim
}

Coordenada :: struct {
    i,j: int
}

Labirinto :: struct {
    altura, largura: int,
    matriz:  [dynamic][dynamic] ComponenteLabirinto
}

VERMELHO :: "\x1b[41m"
VERDE    :: "\x1b[42m"
AMARELO  :: "\x1b[43m"
AZUL     :: "\x1b[44m"
MAGENTA  :: "\x1b[45m"
RESETAR  :: "\x1b[0m"

imprimir_labirinto::proc(l: ^Labirinto) {
    matriz := l.matriz
    for linha in matriz {
        for celula in linha {
            switch celula {
                case ComponenteLabirinto.parede:
                    fmt.printf("%s   %s",MAGENTA,RESETAR)
                case ComponenteLabirinto.caminho:
                    fmt.printf("%s   %s",AMARELO,RESETAR)
                case ComponenteLabirinto.caminho_visitado:
                    fmt.printf("%s   %s",VERDE,RESETAR)
                case ComponenteLabirinto.inicio:
                    fmt.printf("%s   %s",AZUL,RESETAR)
                case ComponenteLabirinto.fim:
                    fmt.printf("%s   %s",VERMELHO,RESETAR)
            }
        }

        fmt.println()
    }
}

visitar_celula::proc(l: ^Labirinto, coordenada: Coordenada) {
    if l == nil {return;}

    if l.matriz[coordenada.i][coordenada.j] == ComponenteLabirinto.caminho {
        l.matriz[coordenada.i][coordenada.j] = ComponenteLabirinto.caminho_visitado
    }
}

pegar_celula::proc(l: ^Labirinto, coordenada: Coordenada) -> ComponenteLabirinto {
    return l.matriz[coordenada.i][coordenada.j]
}

distancia_coordendas::proc(c1: Coordenada, c2: Coordenada) -> f16 {
    x := f16(c1.i-c2.i)
    y := f16(c1.j - c2.j)

    return math.sqrt((x*x)+(y*y))
}

em_cima::proc(coordenada: Coordenada) -> Coordenada {
    return Coordenada{i = coordenada.i-1, j = coordenada.j}
}

em_baixo::proc(coordenada: Coordenada) -> Coordenada {
    return Coordenada{i = coordenada.i+1, j = coordenada.j}
}

a_esquerda::proc(coordenada: Coordenada) -> Coordenada {
    return Coordenada{i = coordenada.i, j = coordenada.j-1}
}

a_direita::proc(coordenada: Coordenada) -> Coordenada {
    return Coordenada{i = coordenada.i, j = coordenada.j+1}
}

verifica_coordenada::proc(l: ^Labirinto, c: Coordenada) -> bool {
    if c.i < 0 { return false }
    if c.j < 0 {return false }
    if c.i >= l.altura { return false }
    if c.j >= l.largura {return false }

    return true
}

create_coordenada::proc(i, j: int) -> Coordenada {
    return Coordenada{i = i,j = j}
}

limpar_caminhos_visitados::proc(l: ^Labirinto) {
    i, j := 0,0
    for linha in l.matriz {
        for celula in linha {
            if celula == ComponenteLabirinto.caminho_visitado {
                l.matriz[i][j] = ComponenteLabirinto.caminho
            }
            j += 1
        }

        j = 0
        i += 1
    }
}

create_labirinto::proc(texto_labirinto: string) -> ^Labirinto {
    i, j: int
    matriz := make([dynamic][dynamic] ComponenteLabirinto)
    linha := make([dynamic] ComponenteLabirinto)

    i = 0
    for letra in texto_labirinto {
        switch letra {
            case  '\n':
                j = len(linha)
                i += 1
                append(&matriz,linha)
                linha = make([dynamic] ComponenteLabirinto)
            case '+':
                append(&linha,ComponenteLabirinto.caminho)
            case '#':
                append(&linha,ComponenteLabirinto.parede)
            case 's':
                append(&linha,ComponenteLabirinto.inicio)
            case 'e':
                append(&linha,ComponenteLabirinto.fim)
        }
    }

    novo_labirinto := new(Labirinto)
    novo_labirinto.altura = i
    novo_labirinto.largura = j
    novo_labirinto.matriz = matriz

    return novo_labirinto
}

destroy_labirinto::proc(pont_labirinto: ^^Labirinto) {
    if pont_labirinto == nil {return;}
    if pont_labirinto^ == nil {return;}

    for linha in pont_labirinto^.matriz {
        delete(linha)
    }

    delete(pont_labirinto^.matriz)
    free(pont_labirinto^)
}