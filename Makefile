# 1. Base Project Settings
CC = gcc
CFLAGS = -Wall -Wextra -I. -Isrc -Isrc/ui
TARGET_NAME = program

SRC = src/main.c \
	  src/engine/game.c \
	  src/hlprs/extra.c \
	  src/ui/glad.c \
	  src/ui/render.c

OBJS = $(patsubst src/%.c, obj/%.o, $(SRC))

# 2. OS Detection and Conditional Logic
ifeq ($(OS),Windows_NT)
    SHELL = cmd.exe
    TARGET = bin/$(TARGET_NAME).exe
    LIBS = -lglfw3 -lopengl32 -lgdi32
    RES_OBJ = obj/resource.o
    
    # Windows Install/Clean Commands
    INSTALL_DIR = C:\Program Files\MyProgram
    INSTALL_CMD = if not exist "$(INSTALL_DIR)" mkdir "$(INSTALL_DIR)" && copy bin\$(TARGET_NAME).exe "$(INSTALL_DIR)\"
    UNINSTALL_CMD = if exist "$(INSTALL_DIR)" rmdir /S /Q "$(INSTALL_DIR)"
    CLEAN_CMD = if exist obj rmdir /S /Q obj && if exist bin rmdir /S /Q bin
    MKDIR_OBJ = @if not exist "$(subst /,\,$(dir $@))" mkdir "$(subst /,\,$(dir $@))"
    MKDIR_BIN = @if not exist bin mkdir bin
else
    SHELL = /bin/sh
    TARGET = bin/$(TARGET_NAME)
    LIBS = -lglfw3 -lGL -lm -lX11 -lpthread -ldl
    RES_OBJ = 
    
    # Linux / macOS Install/Clean Commands
    INSTALL_DIR = /usr/local/bin
    INSTALL_CMD = mkdir -p $(INSTALL_DIR) && cp bin/$(TARGET_NAME) $(INSTALL_DIR)/$(TARGET_NAME)
    UNINSTALL_CMD = rm -f $(INSTALL_DIR)/$(TARGET_NAME)
    CLEAN_CMD = rm -rf obj bin
    MKDIR_OBJ = @mkdir -p $(dir $@)
    MKDIR_BIN = @mkdir -p bin
endif

# 3. Build Rules
all: $(TARGET)

# Fix: Linked $(RES_OBJ) so the icon actually embeds into the executable
$(TARGET): $(OBJS) $(RES_OBJ)
	$(MKDIR_BIN)
	$(CC) $(OBJS) $(RES_OBJ) -o $(TARGET) $(CFLAGS) $(LIBS)

# Rule to compile standard C files
obj/%.o: src/%.c
	$(MKDIR_OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

# Fix: Wrapped windres in a Windows check so it doesn't break Linux builds
ifdef RES_OBJ
$(RES_OBJ): src/resource.rc src/app.ico
	@if not exist obj mkdir obj
	windres --use-temp-file -i src/resource.rc -o $(RES_OBJ) -O coff
endif

# 4. Utility Rules
clean:
	$(CLEAN_CMD)

install: all
	$(INSTALL_CMD)

uninstall:
	$(UNINSTALL_CMD)
