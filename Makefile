CC = gcc
AS = as
LD = gcc

CFLAGS  = -m32 -O2 -g -Wall
ASFLAGS = --32 -g
LDFLAGS = -m32 -g

TARGET = test_for

C_SRC   = main.c
ASM_SRC = for.s

C_OBJ   = main.o
ASM_OBJ = for.o

# domyślny plik wejściowy
DEFAULT_INPUT = rand1M

# INPUT można nadpisać: make INPUT=plik
INPUT ?= $(DEFAULT_INPUT)

OUT = wyniki.txt

# ===== DOMYŚLNY CEL =====
all: run

# ===== BUILD =====
$(C_OBJ): $(C_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

$(ASM_OBJ): $(ASM_SRC)
	$(AS) $(ASFLAGS) -o $@ $<

$(TARGET): $(C_OBJ) $(ASM_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

# ===== RUN =====
run: $(TARGET)
	@if [ ! -f "$(INPUT)" ]; then \
		echo "❌ Brak pliku wejściowego: $(INPUT)"; \
		echo "👉 Użyj: make INPUT=nazwa_pliku"; \
		exit 1; \
	fi
	@echo "▶ Uruchamiam: ./$(TARGET) < $(INPUT)"
	./$(TARGET) < $(INPUT)

# ===== CLEAN =====
clean:
	rm -f $(TARGET) $(C_OBJ) $(ASM_OBJ) $(OUT)

.PHONY: all run clean

