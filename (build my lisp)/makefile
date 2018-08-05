CC= gcc

CFLAGS= -ledit -lm -g -Wall

CSTD= -std=c99

OBJ= main.o type.o builtin_func.o mpc.o

EXE=main

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

main: $(OBJ)
	$(CC) $(CSTD) $(OBJ)  $(CFLAGS) -o $(EXE)

clean:
	rm  $(EXE) $(OBJ)

debug:
	gdb -tui ./main.out
