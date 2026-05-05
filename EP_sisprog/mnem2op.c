#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 100
#define MAX_LABELS 100

// Estrutura para rótulos
typedef struct {
    char name[20];
    int address;
} Label;

Label labels[MAX_LABELS];
int label_count = 0;

// Tabela de mnemônicos → opcode
int getOpcode(char *mnemonic) {
    if (strcmp(mnemonic, "JP") == 0) return 0x0;
    if (strcmp(mnemonic, "JZ") == 0) return 0x1;
    if (strcmp(mnemonic, "JN") == 0) return 0x2;
    if (strcmp(mnemonic, "LV") == 0) return 0x3;
    if (strcmp(mnemonic, "AD") == 0) return 0x4;
    if (strcmp(mnemonic, "SB") == 0) return 0x5;
    if (strcmp(mnemonic, "ML") == 0) return 0x6;
    if (strcmp(mnemonic, "DV") == 0) return 0x7;
    if (strcmp(mnemonic, "LD") == 0) return 0x8;
    if (strcmp(mnemonic, "MM") == 0) return 0x9;
    if (strcmp(mnemonic, "SC") == 0) return 0xA;
    if (strcmp(mnemonic, "RS") == 0) return 0xB;
    if (strcmp(mnemonic, "HM") == 0) return 0xC;
    if (strcmp(mnemonic, "GD") == 0) return 0xD;
    if (strcmp(mnemonic, "PD") == 0) return 0xE;
    if (strcmp(mnemonic, "SO") == 0) return 0xF;

    return -1;
}

// Busca rótulo
int findLabel(char *name) {
    for (int i = 0; i < label_count; i++) {
        if (strcmp(labels[i].name, name) == 0)
            return labels[i].address;
    }
    return 0;
}

// Adiciona rótulo
void addLabel(char *name, int address) {
    strcpy(labels[label_count].name, name);
    labels[label_count].address = address;
    label_count++;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s arquivo.asm\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Erro ao abrir arquivo\n");
        return 1;
    }

    char line[MAX_LINE];
    int address = 0;

    // 🔹 PRIMEIRA PASSAGEM (coletar rótulos)
    while (fgets(line, MAX_LINE, file)) {
        char part1[20], part2[20], part3[20];

        int n = sscanf(line, "%s %s %s", part1, part2, part3);
        if (n == 0) continue;

        // Diretiva @
        if (strcmp(part1, "@") == 0) {
            sscanf(part2 + 1, "%x", &address); // /XXXX
            continue;
        }

        // Label
        if (n == 3) {
            addLabel(part1, address);
        }

        address += 2;
    }

    rewind(file);
    address = 0;

    // 🔹 SEGUNDA PASSAGEM (gerar código)
    while (fgets(line, MAX_LINE, file)) {
    char part1[20], part2[20], part3[20];

    int n = sscanf(line, "%s %s %s", part1, part2, part3);
    //printf("n: %d\n", n);
    if (n == 0 || n==-1) {
        //printf("space \n");
        continue;}

    // Diretiva @
    if (strcmp(part1, "@") == 0) {
        sscanf(part2 + 1, "%x", &address);
        continue;
    }

    char *mnemonic;
    char *operand;

    if (n == 3) {
        mnemonic = part2;
        operand = part3;
    } else {
        mnemonic = part1;
        operand = part2;
    }

    // Diretiva K (não é instrução!)
    if (strcmp(mnemonic, "K") == 0) {
        int value;
        sscanf(operand + 1, "%x", &value);
        printf("%04X %04X\n", address, value);
        address += 2;
        continue;
    }

    int opcode = getOpcode(mnemonic);
    int op_value = 0;

    if (operand[0] == '/') {
        sscanf(operand + 1, "%x", &op_value);
    } else if (operand[0] == '=') {
        op_value = atoi(operand + 1);
    } else {
        op_value = findLabel(operand);
    }

    int instruction = (opcode << 12) | (op_value & 0x0FFF);
    if(instruction>0){
        printf("%04X %04X\n", address, instruction);
    }

    address += 2;
}
    fclose(file);
    return 0;
}
