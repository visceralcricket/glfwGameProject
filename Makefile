CC = gcc
CFLAGS = -Wall -Wextra -I. -Isrc -Isrc/ui

LIBS = -lglfw3 -lopengl32 -lgdi32
TARGET = program.exe
SRC = src/main.c \
	  src/engine/game.c \
	  src/hlprs/extra.c \
	  src/ui/glad.c \
	  src/ui/render.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(SRC) -o $(TARGET) $(CFLAGS) $(LIBS)

clean:
	del $(TARGET)