.DEFAULT_GOAL := numbers

#SHELL           = /bin/bash
BUILDDATE      := `date -u +'%Y-%m-%d_%H:%M:%S_%Z'`

# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

# Defaults
AS=nasm							# Assembler
ASFLAGS=-f elf64 -g -F dwarf	# Assembler flags
LD=ld							# Linker
LDFLAGS=''  					# Linker flags
SOURCES=$(wildcard *.asm)		# Source files
OBJECTS=$(SOURCES:.asm=.o) 		# Object files
EXECUTABLE=numbers				# Program name

all: $(EXECUTABLE)  ## Build all

$(EXECUTABLE): $(OBJECTS)  ## Create executable
	@echo "\033[33;1mLinking\033[0m"
	$(LD) $(LDFLAGS) $(OBJECTS) -o $(EXECUTABLE)

%.o : %.asm  ## Compile
	@echo "\033[33;1mCompiling\033[0m"
	$(AS) $(ASFLAGS) -o $@ $<

listing: numbers.asm   ## Create listing file
	nasm -f elf32 numbers.asm -l numbers.lst

.PHONY: clean
clean: ## Clean up
	@echo "\033[33;1mCleaning\033[0m"
	rm -f *.o
	rm -f numbers numbers.lst

.PHONY: help
help: ## Display help
	@echo "Make targets"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

.PHONY: docker
docker: ## Create Docker image
	docker build --rm --tag numbers .
	docker image prune --force --filter label=stage=builder
