package dfs

import gf "nucleo:grafo"
import sl "nucleo:solucao"


relacao_nos_visitados: map[int] u8
/*
 Recebe como argumento um grafo e retorna, em primeiro lugar, a
 lista de tentativas realizadas para solucionar o grafo do labirinto,
 e em segundo lugar a solução encontrada pelo método no labirinto
 */
dfs :: proc(grafo: ^gf.Grafo) -> ([dynamic]^sl.PilhaPassos, ^sl.PilhaPassos) {
	lista_passos := make([dynamic] ^sl.PilhaPassos)
	defer delete(lista_passos)
	passos_atuais := sl.create_passos()
	
	lista_solucoes, solucao, ok := percorre_grafo(grafo.fim.valor, grafo.inicio, lista_passos,passos_atuais)
	// delete(lista_passos)
	// for &l in lista_passos {
	// 	sl.destroy_pilha(&l)
	// }
	delete(relacao_nos_visitados)

	return lista_solucoes, solucao
}

visitar_no::proc(no: ^gf.No) {
	relacao_nos_visitados[no.valor] = 1
}

no_visitado::proc(no: ^gf.No) -> bool{
	_, ok := relacao_nos_visitados[no.valor]

	return ok
}

percorre_grafo::proc(fim: int,no: ^gf.No, lista_passos: [dynamic] ^sl.PilhaPassos, passos_atuais: ^sl.PilhaPassos) -> ([dynamic]^sl.PilhaPassos, ^sl.PilhaPassos, bool) {
	visitar_no(no)
	lista_passos := lista_passos

	//ele vai tentar ir pra cada uma das arestas
	for aresta in no.arestas {
		//depois, ele vai pegar o no da outra ponta da aresta
		outro_no := gf.no_na_outra_ponta(aresta,no)
		if outro_no.valor == fim {
			sl.push(passos_atuais,aresta)

			return lista_passos, passos_atuais, true
		}

		if no_visitado(outro_no) {
			continue
		}

		sl.push(passos_atuais,aresta)

		append(&lista_passos,sl.clone(passos_atuais))
		lista_s, solucao, ok := percorre_grafo(fim,outro_no,lista_passos,passos_atuais)
		lista_passos = lista_s

		if ok {
			//delete(lista_passos)
			return lista_s, solucao, true
		}
	}

	append(&lista_passos,sl.clone(passos_atuais))
	sl.pop(passos_atuais)

	return lista_passos,passos_atuais,false
}
