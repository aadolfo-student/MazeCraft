package es

import "core:strings"
import "core:os"
ler_arquivo::proc(caminho: string) -> (string, bool) {
    arquivo_bytes, ok := os.read_entire_file(caminho)
    defer delete(arquivo_bytes)
    if !ok {return "",false}

    return strings.clone_from_bytes(arquivo_bytes), true
} 