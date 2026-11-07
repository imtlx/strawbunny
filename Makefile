.PHONY: all clean

all: out/strawbunny

out/strawbunny: strawbunny.asm
	mkdir -p out
	fasm ./strawbunny.asm out/strawbunny
	chmod +x out/strawbunny

clean:
	rm -r out

