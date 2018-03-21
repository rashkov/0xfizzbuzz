blah:
	as ./fb.s -o fb.o && ld -dynamic-linker /lib/ld-linux.so.2 -o fb fb.o -lc && ./fb
