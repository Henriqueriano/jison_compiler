import parser from "./parser.js";

const filePath = process.argv[2];

if (!filePath) {
    console.error("Uso: bun run index.ts <arquivo.c>");
    process.exit(1);
}

try {
    const file = Bun.file(filePath);

    if (!(await file.exists())) {
        console.error(`Arquivo não encontrado: ${filePath}`);
        process.exit(1);
    }

    const codigo = await file.text();

    console.log(`\nAnalisando: ${filePath}\n`);

    parser.parse(codigo);

} catch (error) {
    console.error("\nErro durante a análise:");

    if (error instanceof Error) {
        console.error(error.message);
    } else {
        console.error(error);
    }

    process.exit(1);
}
