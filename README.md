# asm-cli

linux commands implementation in `assembly x86` <br/>
Just for fun and some little experiments with linux's cool [syscalls](https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md#x86_64-64_bit)

## This repo contains:
- [x] cat
- [x] echo
- [x] touch
- [x] pwd
- [x] mkdir
- [x] rmdir

 
Build on a linux 64-bit machine you will also need NASM 
If you don't have NASM:
```bash
sudo apt install nasm
```

## Build - for example (cat)

```bash
nasm -f elf64 cat.asm -o cat.o
ld cat.o -o cat
```

## Run 

```bash
./cat file.txt
```

