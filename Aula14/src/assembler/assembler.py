class bcolors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


assembly = "ASM.txt"  # Arquivo de entrada de contem o assembly
destinoBIN = "BIN.txt"  # Arquivo de saída que contem o binário formatado para VHDL

# definição dos mnemônicos e seus
# respectivo OPCODEs

registers = {
    "%R0": "00",
    "%R1": "01",
    "%R2": "10",
    "%R3": "11",
}

mne = {
    "NOP": "00000",
    "LDA": "00001",
    "SOMA": "00010",
    "SUB": "00011",
    "LDI": "00100",
    "STA": "00101",
    "JMP": "00110",
    "JEQ": "00111",
    "CEQ": "01000",
    "JSR": "01001",
    "RET": "01010",
    "CLT": "01011",
    "CGT": "01100",
    "JLT": "01101",
    "JGT": "01110",
    "AND": "01111",
    "OR": "10000",
}

# Tabela com labels e seus respectivos endereços
labels = {}

# Converte o valor após o caractere arroba '@'
# em um valor hexadecimal de 2 dígitos (8 bits)
def converteArroba(line):
    line = line.split("@")

    if line[1] in labels:
        line[1] = labels[line[1]]
    else:
        line[1] = int(line[1])

    number_in_9_bits = format(line[1], "09b")
    line[1] = f'" & "00" & "{number_in_9_bits}"'
    line = "".join(line)

    return line


# Converte o valor após o caractere cifrão'$'
# em um valor hexadecimal de 2 dígitos (8 bits)
def converteCifrao(line):
    line = line.split("$")
    number_in_9_bits = format(int(line[1]), "09b")
    line[1] = f'" & "00" & "{number_in_9_bits}"'
    line = "".join(line)
    return line


# Define a string que representa o comentário
# a partir do caractere cerquilha '#'
def defineComentario(line):
    if "#" in line:
        line = line.split("#")
        line = line[0] + "\t#" + line[1]
        return line
    else:
        return line


# Remove o comentário a partir do caractere cerquilha '#',
# deixando apenas a instrução
def defineInstrucao(line):
    line = line.split("#")
    line = line[0]
    return line


# Consulta o dicionário e "converte" o mnemônico em
# seu respectivo valor em hexadecimal
def trataMnemonico(line):
    line = line.replace("\n", "")  # Remove o caracter de final de linha
    line = line.replace("\t", "")  # Remove o caracter de tabulacao
    line = line.split(" ")
    line[0] = mne[line[0]]
    line = "".join(line)
    return line


def adicionaLabelNaTabela(label, linha):
    if label not in labels:
        labels[label] = linha - (len(labels))


with open(assembly, "r") as f:  # Abre o arquivo ASM
    lines = f.readlines()  # Verifica a quantidade de linhas

# Insere as linhas do arquivo *.txt na linha que começa com 'import *'
for i in range(len(lines)):
    if lines[i].startswith("import"):
        with open(f"{lines[i].split()[1]}.txt", "r") as f:
            lines_file_aux = f.readlines()

        lines[i:i] = lines_file_aux
        lines.pop(i + len(lines_file_aux))


# Remove linhas em branco
lines = [line for line in lines if line.strip()]

# Remove espaços em branco no começo da linha
lines = [line.lstrip() for line in lines]

# Remove tabulações no começo da linha
lines = [line.lstrip("\t") for line in lines]

# Remove linhas que começam com os caracteres de comentário '//'
lines = [line for line in lines if not line.startswith("//")]


# Encontra labels e adiciona na tabela de simbolos
for index_linha, line in enumerate(lines):
    if ":" in line:
        adicionaLabelNaTabela(line.split(":")[0], index_linha)

with open(destinoBIN, "w") as f:  # Abre o destino BIN

    cont = 0  # Cria uma variável para contagem

    for line in lines:

        # Verifica se a linha começa com alguns caracteres invalidos ('\n' ou ' ' ou '#')
        if line.startswith("\n") or line.startswith(" ") or line.startswith("#"):
            line = line.replace("\n", "")
            print(
                f"{bcolors.FAIL}Sintaxe invalida na Linha: {line}{bcolors.ENDC}"
            )  # Print apenas para debug

        # Verifica se a linha começa com um label
        elif ":" in line:
            f.write(f"\n-- {line.split(':')[0]}:\n")
            print(f"\n{bcolors.OKCYAN}Label {line.split(':')[0]}:{bcolors.ENDC}")

        # Se a linha for válida para conversão, executa
        else:
            # Exemplo de linha => 1. JSR @14 #comentario1
            comentarioLine = defineComentario(line).replace(
                "\n", ""
            )  # Define o comentário da linha. Ex: #comentario1
            instrucaoLine = defineInstrucao(line).replace(
                "\n", ""
            )  # Define a instrução. Ex: JSR @14

            # Verifica se a instrução possui um caractere virgula ','
            if "," in instrucaoLine:
                instrucaoLine = instrucaoLine.replace(",", "")  # Remove a virgula
                instrucaoLine = instrucaoLine.split()  # Divide a instrução em uma lista
                mnemonico = mne[instrucaoLine[0]]  # Define o mnemônico
                registrador = registers[instrucaoLine[1]]  # Define o registrador
                numero = format(int(instrucaoLine[2][1:]), "09b")  # Define o número

                f.write(
                    f'tmp({str(cont)}) := "{mnemonico}" & "{registrador}" & "{numero}";\t-- {comentarioLine}\n'
                )  # Escreve no arquivo BIN.txt

                print(
                    f'{bcolors.OKGREEN}{str(cont)}{bcolors.ENDC}: "{mnemonico}" & "{registrador}" & "{numero}";\t-- {comentarioLine}'
                )  # Print apenas para debug
            else:
                instrucaoLine = trataMnemonico(
                    instrucaoLine
                )  # Trata o mnemonico. Ex(JSR @14): x"9" @14

                if "@" in instrucaoLine:  # Se encontrar o caractere arroba '@'
                    instrucaoLine = converteArroba(
                        instrucaoLine
                    )  # converte o número após o caractere Ex(JSR @14): x"9" x"0E"

                elif "$" in instrucaoLine:  # Se encontrar o caractere cifrao '$'
                    instrucaoLine = converteCifrao(
                        instrucaoLine
                    )  # converte o número após o caractere Ex(LDI $5): x"4" x"05"

                else:  # Senão, se a instrução nao possuir nenhum imediator, ou seja, nao conter '@' ou '$'
                    instrucaoLine = instrucaoLine.replace(
                        "\n", ""
                    )  # Remove a quebra de linha
                    number_in_9_bits = format(0, "09b")
                    instrucaoLine = f'{instrucaoLine}" & "00" & "{number_in_9_bits}"'  # Acrescenta o valor x"00". Ex(RET): x"A" x"00"

                # Formata para o arquivo BIN
                # Entrada => 1. JSR @14 #comentario1
                # Saída =>   1. tmp(0) := x"90E";	-- JSR @14 	#comentario1

                f.write(
                    f'tmp({str(cont)}) := "{instrucaoLine};\t-- {comentarioLine}\n'
                )  # Escreve no arquivo BIN.txt

                print(
                    f'{bcolors.OKGREEN}{str(cont)}{bcolors.ENDC}: "{instrucaoLine}; \t-- {comentarioLine}'
                )  # Print apenas para debug

            cont += 1  # Incrementa a variável de contagem, utilizada para incrementar as posições de memória no VHDL
