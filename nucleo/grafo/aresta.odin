package grafo

import "core:sys/wasm/wasi"
/*
 Uma estrutura que representa a ligação entre dois nós, respectivamente no campos no1 e no2
 A aresta pode ser identificada pelo seu campo valor
 */
Aresta :: struct {
    valor :int,
    peso: f16,
    no1,no2: ^No
}

create_aresta::proc(no1,no2:^No, peso: f16, valor:int) -> ^Aresta {
    nova_aresta := new(Aresta)
    nova_aresta.no1 = no1
    nova_aresta.no2 = no2
    nova_aresta.peso = peso
    nova_aresta.valor = valor

	append(&no1.arestas, nova_aresta) //como eu criei uma nova aresta, devo adicionar elas aos nos obviamente
	append(&no2.arestas, nova_aresta)

	return nova_aresta
}

destroy_aresta :: proc(aresta: ^^Aresta) {
	if aresta == nil {return}
	if aresta^ == nil {return}

	free(aresta^)

	aresta^ = nil
}

/*
 Recebe como argumento uma aresta e um nó.
 Verifica qual das pontas da aresta corresponde ao Nó, e retorna o nó na outra ponta
 Caso a aresta não incida no nó passado como argumento, a função retorna nil
 */
no_na_outra_ponta :: proc(aresta: ^Aresta, no: ^No) -> ^No {
	if no.valor == aresta.no1.valor {
		return aresta.no2
	}

	if no.valor == aresta.no2.valor {
		return aresta.no1
	}

	return nil
}
