package matriz

/*
  cria uma matriz com as dimensoes n x m.
  provavelmente vai ser usado algumas vezes na criação das matrizes do grafo
  Para desencargo de consciencia: esta função foi gerada por IA
 */
create_matrix :: proc($T: typeid, n,m: int) -> [][]T {
    matriz := make([][]T, n)

    for i in 0..<n {
        matriz[i] = make([]T, m)
    }
    return matriz
}

/*
 Uma função que será útil para obter a transversa da matriz.
 Novamente, para desencargo de consciencia, esta função foi feita com ferramentas de IA
*/
transverter_matriz::proc($T:typeid,matriz:[][]T) -> [][]T {
    if len(matriz) == 0 do return [][]T{}
    
    // Encontrar o número máximo de colunas
    max_colunas := 0
    for linha in matriz {
        if len(linha) > max_colunas {
            max_colunas = len(linha)
        }
    }
    
    if max_colunas == 0 do return [][]T{}
    
    // Criar a matriz transposta
    transposta := make([][]T, max_colunas)
    for j in 0..<max_colunas {
        // Contar quantas linhas têm pelo menos j+1 colunas
        linhas_com_coluna_j := 0
        for i in 0..<len(matriz) {
            if j < len(matriz[i]) {
                linhas_com_coluna_j += 1
            }
        }
        
        transposta[j] = make([]T, linhas_com_coluna_j)
        
        // Preencher a coluna j da transposta
        pos := 0
        for i in 0..<len(matriz) {
            if j < len(matriz[i]) {
                transposta[j][pos] = matriz[i][j]
                pos += 1
            }
        }
    }
    
    return transposta
}