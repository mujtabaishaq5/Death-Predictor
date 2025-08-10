# ☠️ Assembly Death Predictor

A quirky, fun program written entirely in Assembly language that predicts your "death" based on some inputs — just for entertainment and learning low-level programming!

---

## 💀 What is this?

This project is a simple **Death Predictor** implemented in Assembly. It demonstrates:

- Low-level programming techniques
- Working with user input/output in Assembly
- Basic logic and arithmetic at the hardware level
- Fun with bitwise operations and randomness

If you love Assembly language or want to see how something silly can be done at the lowest level, this is for you!

---

## ⚙️ Features

- Runs directly on x86 (specify architecture 64-bit
- Takes user input to generate a "death prediction"
- Uses Assembly instructions for all calculations
- Minimal dependencies, runs in terminal/console

---

## 🛠️ How to Build & Run

### Prerequisites

- NASM assembler installed ([Download here](https://www.nasm.us/))
- A Unix-like terminal (Linux, macOS) or Windows with WSL / Cygwin
- `ld` linker or equivalent

```asm
section .data
msg: db "Hello World!", 10 ; 10 for newline
msglen equ $ - msg

section .text

 global _start


_start:

   lea rsi, [rel msg]
   mov rdx, msglen
   jmp .print

   ; exit program
   mov rax, 0x2000003
   xor rdi, rdi
   syscall

.print:
 
   mov rax, 0x2000004
   mov rdi, 1
   syscall

```

### Build Instructions

```bash
# Assemble the program
nasm -f elf64 death_predictor.asm -o death_predictor.o

# Link the object file to create executable
ld death_predictor.o -o death_predictor

# Run the program
./death_predictor
