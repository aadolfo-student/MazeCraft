package a_star

import gf "nucleo:grafo"
import sl "nucleo:solucao"


relacao_nos_visitados: map[int] u8
/*
 Recebe como argumento um grafo e retorna, em primeiro lugar, a
 lista de tentativas realizadas para solucionar o grafo do labirinto,
 e em segundo lugar a solução encontrada pelo método no labirinto
 */
a_star :: proc(grafo: ^gf.Grafo) -> ([dynamic]^sl.PilhaPassos, ^sl.PilhaPassos) {
	relacao_nos_visitados = make(map[int] u8)
	defer delete(relacao_nos_visitados)

	todas_tentativas := make([dynamic]^sl.PilhaPassos)
	passos_ate_no := make(map[int] [dynamic]^gf.Aresta)
	defer {
		for _, value in passos_ate_no {
			delete(value)
		}
		delete(passos_ate_no)
	}

	fila := create_fila_aresta()
	defer destroy_fila_aresta(&fila)

	pilha_passos := sl.create_passos()
	no_atual := grafo.inicio
	passos_ate_no[grafo.inicio.valor] = [dynamic]^gf.Aresta{}

	for no_atual.valor != grafo.fim.valor {
		//primeiro, vamos marcar o no atual como visitado
		visitar_no(no_atual)

		//depois, vamos pegar o caminho ate ele
		caminho_ate_aqui := passos_ate_no[no_atual.valor]

		for aresta in no_atual.arestas {
			//agora, vamos basicamente colocar cada uma das arestas do no na fila de prioridade

			//primeiro, pegamos o no da outra ponta dessa aresta
			outra_ponta := gf.no_na_outra_ponta(aresta,no_atual)

			//e atribuimos o caminho dela
			novo_caminho := make([dynamic]^gf.Aresta)

			for a in caminho_ate_aqui {
				append(&novo_caminho,a)
			}

			//adicionamo a aresta ao caminho
			append(&novo_caminho,aresta)

			//verifico se ja ha um caminho ate aquele no
			if caminho_existente, ok := passos_ate_no[outra_ponta.valor]; ok {
				//se sim, verifico se o novo caminho tem mais ou menos peso
				if peso_caminho(novo_caminho) < peso_caminho(caminho_existente) {
					delete(caminho_existente)
					//se for mais leve, defino o no como o novo caminho
					passos_ate_no[outra_ponta.valor] = novo_caminho
				} else {
					delete(novo_caminho)
				}
			} else {
				passos_ate_no[outra_ponta.valor] = novo_caminho
			}

			// passos_ate_no[outra_ponta.valor] = novo_caminho

			//enviamos por fim, a aresta para a fila
			push(fila,aresta)
		}

		//tentamos entao pegar a proxima aresta da fila
		proxima_aresta := pop(fila)
		for {
			//se for nulo, acabamos aqui, ou há um erro ou o algortimo nao roda
			if proxima_aresta == nil {
				return nil,nil
			}

			//verificamos cada uma das pontas dessa aresta, para saber se não já visitamos as duas pontas
			if !no_visitado(proxima_aresta.no1) {
				no_atual = proxima_aresta.no1
				break
			}

			if !no_visitado(proxima_aresta.no2) {
				no_atual = proxima_aresta.no2
				break
			}

			//se todas as pontas da aresta foram visitadas, vamos para a proxima
			proxima_aresta = pop(fila)
		}

		sl.push(pilha_passos,proxima_aresta)
		append(&todas_tentativas,sl.clone(pilha_passos))
	}

	lista_solucao := passos_ate_no[no_atual.valor]
	sl.clean(pilha_passos)

	#reverse for l in lista_solucao {
		sl.push(pilha_passos,l)
	}

	return todas_tentativas,pilha_passos
}

visitar_no::proc(no: ^gf.No) {
	relacao_nos_visitados[no.valor] = 1
}

no_visitado::proc(no: ^gf.No) -> bool {
	_,ok := relacao_nos_visitados[no.valor]

	return ok
}

peso_caminho::proc(caminho: [dynamic]^gf.Aresta) -> f16 {
	resultado :f16 = 0
	for n in caminho {
		resultado += n.peso
	}

	return resultado
}