package main

import "core:os"
import "core:strings"

import "core:fmt"
import "core:mem"
import ferr "ferramentas:es"
import gf "nucleo:grafo"
import lb "nucleo:labirinto"
import sl "nucleo:solucao"
import a_star "nucleo:solucao/a_star"
import bfs "nucleo:solucao/bfs"
import dfs "nucleo:solucao/dfs"

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	input := ""

	fmt.println("Coloque o labiritino que você deseja no arquivo labirinto.txt")
	print_regras()

	fmt.println()
	fmt.println("Quando tiver preenchido o labirinto, por favor, aperte enter")
	delete(ler_teclado())

	texto_labirinto, ok := ferr.ler_arquivo("./labirinto.txt")
	defer delete(texto_labirinto)
	if !ok {
		fmt.println("Arquivo do labirinto não encontrado, encerrando o programa")
		return
	}

	labirinto := lb.create_labirinto(texto_labirinto)
	defer lb.destroy_labirinto(&labirinto)

	fmt.println("Labirinto carregado:")
	lb.imprimir_labirinto(labirinto)
	fmt.println()
	esperar()

	nos, no_inicio, no_fim, nos_relacao := lb.pegar_pontos(labirinto)
	defer delete(nos_relacao)

	clear_terminal()
	fmt.println("Nós encontrados no labirinto:")
	lb.imprimir_labirinto(labirinto)

	esperar()

	clear_terminal()

	nos2:= make([dynamic]^gf.No)
	defer delete(nos2)

	for n in nos {
		append(&nos2,n)
	}

	append(&nos2,no_inicio)
	append(&nos2,no_fim)


	fmt.println("Arestas encontradas:")
	arestas, arestas_relacao := lb.pegar_arestas(labirinto,no_inicio,no_fim,nos2,nos_relacao)
	defer {
		for _,n in arestas_relacao {
			delete(n)
		}
		delete(arestas_relacao)
	}

	lb.imprimir_labirinto(labirinto)
	esperar()

	lb.limpar_caminhos_visitados(labirinto)

	grafo := gf.create_grafo(no_inicio,no_fim,nos,arestas)
	defer gf.destroy_grafo(&grafo)

	// matriz_adjacencia := gf.criar_matriz_adjacencia(grafo)
	// matriz_incidencia := gf.criar_matriz_incidencia(grafo)
	// defer {
	// 	for a in matriz_adjacencia {
	// 		delete(a)
	// 	}

	// 	for a in matriz_incidencia {
	// 		delete(a)
	// 	}

	// 	delete(matriz_adjacencia)
	// 	delete(matriz_incidencia)
	// }

	// fmt.println("Matriz de adjacencia:")
	// for linha in matriz_adjacencia {
	// 	fmt.print("| ")
	// 	for i in linha {
	// 		fmt.printf("%d ",i)
	// 	}
	// 	fmt.println("|")
	// }

	// fmt.println("\nMatriz de incidencia:")
	// for linha in matriz_incidencia {
	// 	fmt.print("| ")
	// 	for i in linha {
	// 		fmt.printf("%d ",i)
	// 	}
	// 	fmt.println("|")
	// }

	fmt.println("Qual método de solução você deseja fazer?")
	print_opcoes()
	resposta := ler_teclado()
	defer delete(resposta)

	solucao : ^sl.PilhaPassos
	tentativas: [dynamic]^sl.PilhaPassos

	defer {
		for &t in tentativas {
			sl.destroy_pilha(&t)
		}
		delete(tentativas)

		sl.destroy_pilha(&solucao)
	}

	switch resposta[0] {
		case '1':
			tentativas, solucao = bfs.bfs(grafo)
		case '2':
			tentativas, solucao = dfs.dfs(grafo)
		case '3':
			tentativas,solucao = a_star.a_star(grafo)
		case:
			fmt.println("Nenhuma opção válida foi dada")
			return
	}

	sl.visualizar_solucao(labirinto,arestas_relacao,nos_relacao,tentativas,solucao)
	esperar()
}

print_regras::proc() {
	fmt.println("Regras para o labirinto:")
	fmt.println("1. Somento 4 caracteres são permitidos: +, #, s, e")
	fmt.println("2. Tente fazer um labirinto solucionável, ou pegue um dos exemplos dados")
	fmt.println("3. O caractere s (start) indica o início do labirinto, e o caractere e (end) o final")
	fmt.println("4. O caractere + indica um caminho")
	fmt.println("4. O caractere # indica uma parede")
}

print_opcoes::proc() {
	fmt.println("1: BFS")
	fmt.println("2: DFS")
	fmt.println("3: A*")
}

clear_terminal :: proc() {
    fmt.println("\x1b[2J")
}

esperar::proc() {
	fmt.println("Digite enter para continuar> ")
	delete(ler_teclado())
}

ler_teclado::proc() -> string {
	input := [2]u8{}

	for {
		os.read(os.stdin,input[:])

		if input[0] != 0 {
			break
		}
	}

	return strings.clone_from_bytes(input[:])
}