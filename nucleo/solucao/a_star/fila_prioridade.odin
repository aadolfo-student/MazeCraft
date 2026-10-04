package a_star

import gf "nucleo:grafo"

FilaArestas :: struct {
    primeiro: ^ItemAresta,
}

ItemAresta :: struct {
    aresta: ^gf.Aresta,
    proximo: ^ItemAresta
}

push::proc(f: ^FilaArestas,aresta: ^gf.Aresta) {
    if f == nil {return}
    if aresta == nil {return}

    novo_item := create_item_aresta(aresta)

    //se a fila está vazia, apenas inicializa os dois atributos e para
    if f.primeiro == nil {
        f.primeiro = novo_item
        return
    }

    atual := f.primeiro
    anterior : ^ItemAresta = nil

    for novo_item.aresta.peso > atual.aresta.peso {

        anterior = atual
        atual = atual.proximo
        if atual == nil {
            anterior.proximo = novo_item
            return
        }
    }

    if anterior == nil {
        novo_item.proximo = f.primeiro
        f.primeiro = novo_item
        return
    }

    anterior.proximo = novo_item
    novo_item.proximo = atual
}

pop::proc(f: ^FilaArestas) -> ^gf.Aresta {
    if f == nil {return nil}
    if f.primeiro == nil {return nil}

    primeiro := f.primeiro
    aresta := primeiro.aresta

    f.primeiro = primeiro.proximo

    destroy_item_aresta(&primeiro)

    return aresta
}

create_item_aresta::proc(aresta: ^gf.Aresta) -> ^ItemAresta {
    novo_item := new(ItemAresta)
    novo_item.aresta = aresta
    novo_item.proximo = nil

    return novo_item
}

destroy_item_aresta::proc(item: ^^ItemAresta) {
    if item == nil {return}
    if item^ == nil {return}

    free(item^)
    item^ = nil
}

create_fila_aresta::proc() -> ^FilaArestas {
    nova_fila := new(FilaArestas)
    nova_fila.primeiro = nil

    return nova_fila
}

destroy_fila_aresta::proc(f: ^^FilaArestas) {
    if f == nil {return}
    if f^ == nil {return}

    for p := pop(f^); p != nil; p = pop(f^) {}

    free(f^)

    f^ = nil
}