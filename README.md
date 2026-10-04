# Analisador de C com Bun e Jison

Este projeto implementa um analisador léxico e sintático para um subconjunto da
linguagem C. O lexer e a gramática ficam em `src/parser.jison`, e o programa de
entrada lê um arquivo `.c` e envia seu conteúdo para o parser.

## Pré-requisitos

- [Bun](https://bun.sh/) instalado e disponível no `PATH`.
- Um arquivo-fonte C para analisar.

Verifique a instalação:

```bash
bun --version
```

## Instalação

Na raiz do repositório, instale as dependências definidas no `package.json`:

```bash
bun install
```

Isso instala o Jison (`jison@0.4.18`) usado para gerar o parser JavaScript.

## Gerando o parser

Sempre que `src/parser.jison` for alterado, gere novamente `src/parser.js`.

Executando a partir da raiz do projeto:

```bash
bun jison ./src/parser.jison -o ./src/parser.js
```

O mesmo comando, executado dentro do diretório `src`, é:

```bash
bun jison parser.jison
```

Também é possível usar o script definido no `package.json`:

```bash
bun run parse
```

## Analisando um arquivo C

O arquivo de entrada atual é `src/init.ts`. Portanto, a partir da raiz do
projeto, execute:

```bash
bun run src/init.ts src/sample.c
```

Para analisar outro arquivo:

```bash
bun run src/init.ts caminho/para/arquivo.c
```

O programa informa o arquivo analisado, exibe as diretivas e construções
reconhecidas e termina com `ANALISE CONCLUIDA COM SUCESSO` quando a análise
termina sem erros.

## Comandos equivalentes solicitados

Caso os arquivos sejam executados a partir de `src`, o fluxo pode ser escrito
da seguinte forma:

```bash
bun jison parser.jison
bun run init.ts ../arquivo.c
```

O comando `bun run init.rs arquivo.c` só funcionará se existir um arquivo
`init.rs`. Neste repositório, o arquivo correspondente é `src/init.ts`; `.rs` é
uma extensão normalmente usada para código Rust e não está presente neste
projeto.

## Fluxo completo

Exemplo usando o arquivo fornecido pelo projeto:

```bash
bun install
bun run parse
bun run src/init.ts src/sample.c
```

Se o parser já estiver atualizado, a segunda etapa (`bun run parse`) pode ser
omitida.

## Estrutura relevante

```text
.
├── package.json       # dependência do Jison e script de geração
├── bun.lock           # versões bloqueadas das dependências
└── src/
    ├── init.ts        # ponto de entrada do analisador
    ├── parser.jison   # lexer e gramática
    ├── parser.js      # parser gerado pelo Jison
    └── sample.c       # exemplo de entrada
```

## Erros comuns

- **Arquivo não encontrado:** confirme o caminho passado após `src/init.ts`.
- **Erro de sintaxe:** verifique se o arquivo `.c` usa construções suportadas
  pela gramática.
- **Parser desatualizado:** execute `bun run parse` novamente após modificar
  `src/parser.jison`.
