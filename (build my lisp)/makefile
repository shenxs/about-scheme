
CC=gcc

CFLAGS= -ledit -lm

CSTD= -std=c99

main: *.c
	$(CC) $(CSTD) -g main.c mpc.c $(CFLAGS) -o main.out

clean:
	rm *.out

debug:
	gdb -tui ./main.out
