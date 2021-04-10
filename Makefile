SRC=$(shell find . -type f -iname "*.asm")
ENTRY=src/mod.asm
BINARY=mod

all: $(BINARY)

$(BINARY): $(SRC)
	sjasmplus $(ENTRY)

clean:
	rm mod