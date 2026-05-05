#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINES 1000

typedef struct {
    int address;
    int code;
} Line;

typedef struct {
    int address;
    char name[10];
} Label;

Line lines[MAX_LINES];
Label labels[MAX_LINES];

int lineCount = 0;
int labelCount = 0;

// ================= OPCODES =================
char *getMnemonic(int opcode) {
    switch (opcode) {
        case 0x0: return "JP";
        case 0x1: return "JZ";
        case 0x2: return "JN";
        case 0x3: return "LV";
        case 0x4: return "AD";
        case 0x5: return "SB";
        case 0x6: return "ML";
        case 0x7: return "DV";
        case 0x8: return "LD";
        case 0x9: return "MM";
        case 0xA: return "SC";
        case 0xB: return "RS";
        case 0xC: return "HM";
        case 0xD: return "GD";
        case 0xE: return "PD";
        case 0xF: return "SO";
        default: return NULL;
    }
}

// ================= LABELS =================
int hasLabel(int address) {
    for (int i = 0; i < labelCount; i++)
        if (labels[i].address == address)
            return i;
    return -1;
}

void addLabel(int address) {
    if (hasLabel(address) != -1) return;

    sprintf(labels[labelCount].name, "L%04X", address);
    labels[labelCount].address = address;
    labelCount++;
}

char* getLabelName(int address) {
    int i = hasLabel(address);
    if (i != -1) return labels[i].name;
    return NULL;
}

// ================= MAIN =================
int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s arquivo.mvn\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Erro ao abrir arquivo\n");
        return 1;
    }

    // Nome saída
   /* char outputName[100];
    strcpy(outputName, argv[1]);
    char *dot = strrchr(outputName, '.');
    if (dot) strcpy(dot, ".asm");
    else strcat(outputName, ".asm");*/

    //FILE *out = fopen(outputName, "w");

    // ================= PASSAGEM 1 =================
    while (fscanf(file, "%x %x", &lines[lineCount].address, &lines[lineCount].code) == 2) {
        int code = lines[lineCount].code;
        int opcode = (code >> 12) & 0xF;
        int operand = code & 0x0FFF;

        char *mnemonic = getMnemonic(opcode);

        // Se for instrução de desvio → criar label
        if (mnemonic &&
            (opcode == 0x0 || opcode == 0x1 || opcode == 0x2 || opcode == 0xA)) {
            addLabel(operand);
        }

        lineCount++;
    }

    rewind(file);

    // ================= PASSAGEM 2 =================
    int lastAddress = -2;

    for (int i = 0; i < lineCount; i++) {

        int address = lines[i].address;
        int code = lines[i].code;

        // Detecta bloco
        if (address != lastAddress + 2) {
            printf("\n@ /%04X\n", address);
        }

        // Label no início da linha
        char *labelHere = getLabelName(address);
        if (labelHere) {
            printf("%s ", labelHere);
        } else {
            printf("        ");
        }

        int opcode = (code >> 12) & 0xF;
        int operand = code & 0x0FFF;

        char *mnemonic = getMnemonic(opcode);

        if (mnemonic) {
            char *labelOp = getLabelName(operand);

            if (labelOp) {
                printf("%s %s\n", mnemonic, labelOp);
            } else {
                printf("%s /%04X\n", mnemonic, operand);
            }
        } else {
            printf("K /%04X\n", code);
        }

        lastAddress = address;
    }

    fclose(file);

    return 0;
}
