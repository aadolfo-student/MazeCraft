package bfs

import "core:container/queue"
import sl "nucleo:solucao"
import gf "nucleo:grafo"

no_visitado::proc(no: ^gf.No, relacao_nos: map[int] [dynamic]^gf.Aresta) -> bool{
	_,ok := relacao_nos[no.valor]

	return ok
}

bfs::proc(grafo: ^gf.Grafo) -> ([dynamic]^sl.PilhaPassos, ^sl.PilhaPassos) {
	passos_para_ponto := make(map[int] [dynamic]^gf.Aresta)
	lista_passos := make([dynamic]^sl.PilhaPassos)
	geracao_atual := create_pilha_nos()
	push(geracao_atual,grafo.inicio)

	passos_para_ponto[grafo.inicio.valor] = [dynamic]^gf.Aresta{}

	//itero a cada geracao
	for geracao_atual.len != 0 {
		//preparo a nova geracao
		nova_geracao := create_pilha_nos()

		arestas_dessa_geracao := sl.create_passos()

		//itero sobre os nos da geracao atual
		for no := pop(geracao_atual); no != nil; no = pop(geracao_atual) {
			passos_do_no := passos_para_ponto[no.valor]
			for aresta in no.arestas {
				outro_no := gf.no_na_outra_ponta(aresta,no)
				if no_visitado(outro_no,passos_para_ponto) {
					continue
				}

				novos_passos := make([dynamic]^gf.Aresta)

				for p in passos_do_no {
					append(&novos_passos,p)
				}

				append(&novos_passos, aresta)
				sl.push(arestas_dessa_geracao,aresta)
				passos_para_ponto[outro_no.valor] = novos_passos

				//se o outro no for o final, podemos parar por aqui
				if outro_no.valor == grafo.fim.valor {
					//basta colocar as arestas dessa geracao na lista_passos
					append(&lista_passos,arestas_dessa_geracao)

					solucao := sl.create_passos()

					//agora vamos pegar as arestas da solucao
					#reverse for a in passos_para_ponto[outro_no.valor] {
						sl.push(solucao,a)
					}

					//limpando a memoria
					destroy_pilha_nos(&nova_geracao)
					destroy_pilha_nos(&geracao_atual)
					for _,value in passos_para_ponto {
						delete(value)
					}
					delete(passos_para_ponto)

					return lista_passos,solucao
					
				}


				//adiciono o outro no na proxima geracao
				push(nova_geracao,outro_no)
			}
		}

		//quando acabo com essa geracao, limpo a geracao atual da memória, e passo a nova fila para o ponteiro
		destroy_pilha_nos(&geracao_atual)
		append(&lista_passos,arestas_dessa_geracao)
		geracao_atual = nova_geracao
	}


	return nil, nil
}
