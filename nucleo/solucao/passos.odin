package solucao

import gf "nucleo:grafo"


/*
 Essa pilha contém a lista de aresta que devemos percorrer
 para encontrar algum outro nó (não necessariamente a solução)
 */
PilhaPassos :: struct {
	atual: ^Passo,
}

Passo :: struct {
	proximo: ^Passo,
	aresta:  ^gf.Aresta,
}


//Isso aqui é uma pilha comum, então tem uma função push, onde você coloca uma aresta
push :: proc(pilha: ^PilhaPassos, aresta: ^gf.Aresta) {
	novo_passo := create_passo(pilha.atual, aresta)
	pilha.atual = novo_passo
}

//Pop normal de qualquer pilha. Se a pilha estiver vazia, retorna nil
pop :: proc(pilha: ^PilhaPassos) -> ^gf.Aresta {
	atual := pilha.atual

	if atual == nil {return nil}

	aresta := atual.aresta
	pilha.atual = atual.proximo

	destroy_passo(&atual)

	return aresta
}

clone :: proc(pilha: ^PilhaPassos) -> ^PilhaPassos {
	item_atual := pilha.atual
	lista_arestas := make([dynamic] ^gf.Aresta)
	defer delete(lista_arestas)

	for item_atual != nil {
		append(&lista_arestas,item_atual.aresta)
		item_atual = item_atual.proximo
	}

	nova_pilha := create_passos()

	#reverse for aresta in lista_arestas {
		push(nova_pilha,aresta)
	}

	return nova_pilha
}

//limpa a pilha
clean :: proc(pilha: ^PilhaPassos) {
	for {
		if pop(pilha) == nil {return}
	}
}

create_passo :: proc(proximo: ^Passo, aresta: ^gf.Aresta) -> ^Passo {
	novo_passo := new(Passo)
	novo_passo.proximo = proximo
	novo_passo.aresta = aresta

	return novo_passo
}

destroy_passo :: proc(ptr_passo: ^^Passo) {
	if ptr_passo == nil {return}
	if ptr_passo^ == nil {return}

	free(ptr_passo^)
	ptr_passo^ = nil
}

create_passos :: proc(passo_inicial: ^Passo = nil) -> ^PilhaPassos {
	nova_pilha := new(PilhaPassos)
	nova_pilha.atual = passo_inicial

	return nova_pilha
}

destroy_pilha :: proc(ptr_pilha: ^^PilhaPassos) {
	if ptr_pilha == nil {return}
	if ptr_pilha^ == nil {return}

	clean(ptr_pilha^)

	free(ptr_pilha^)
	ptr_pilha^ = nil
}
