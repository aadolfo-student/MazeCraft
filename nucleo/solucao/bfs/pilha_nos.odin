package bfs

import gf "nucleo:grafo"


/*
 Essa pilha contém a lista de aresta que devemos percorrer
 para encontrar algum outro nó (não necessariamente a solução)
 */
PilhaNos :: struct {
    len: int,
	atual: ^ItemNo,
}

ItemNo :: struct {
	proximo: ^ItemNo,
	no:  ^gf.No,
}


//Isso aqui é uma pilha comum, então tem uma função push, onde você coloca uma aresta
push :: proc(pilha: ^PilhaNos, no: ^gf.No) {
	novo_passo := create_item_no(pilha.atual, no)
	pilha.atual = novo_passo
    pilha.len += 1
}

//Pop normal de qualquer pilha. Se a pilha estiver vazia, retorna nil
pop :: proc(pilha: ^PilhaNos) -> ^gf.No {
	atual := pilha.atual

	if atual == nil {return nil}

	no := atual.no
	pilha.atual = atual.proximo

	destroy_item_no(&atual)

    pilha.len -= 1

	return no
}

//limpa a pilha
clean :: proc(pilha: ^PilhaNos) {
	for {
		if pop(pilha) == nil {return}
	}
}

create_item_no :: proc(proximo: ^ItemNo, no: ^gf.No) -> ^ItemNo {
	novo_passo := new(ItemNo)
	novo_passo.proximo = proximo
	novo_passo.no = no

	return novo_passo
}

destroy_item_no :: proc(ptr_passo: ^^ItemNo) {
	if ptr_passo == nil {return}
	if ptr_passo^ == nil {return}

	free(ptr_passo^)
	ptr_passo^ = nil
}

create_pilha_nos :: proc(passo_inicial: ^ItemNo = nil) -> ^PilhaNos {
	nova_pilha := new(PilhaNos)
	nova_pilha.atual = passo_inicial
    nova_pilha.len = 0

	return nova_pilha
}

destroy_pilha_nos :: proc(ptr_pilha: ^^PilhaNos) {
	if ptr_pilha == nil {return}
	if ptr_pilha^ == nil {return}

	clean(ptr_pilha^)

	free(ptr_pilha^)
	ptr_pilha^ = nil
}
