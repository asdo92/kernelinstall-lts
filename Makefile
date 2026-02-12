# Kernel Installer Makefile
# Author: Alexia Michelle <alexia@goldendoglinux.org>
# Modified by asdo92 <asdo92@duck.com>
# LICENSE: GNU GPL 3.0
# --------------------------------------------------

CC = gcc
PKG_CONFIG ?= pkg-config
NCURSES_CFLAGS := $(shell $(PKG_CONFIG) --cflags ncursesw 2>/dev/null)
NCURSES_LIBS := $(shell $(PKG_CONFIG) --libs ncursesw 2>/dev/null)

ifeq ($(NCURSES_LIBS),)
    NCURSES_CFLAGS = -D_GNU_SOURCE
    NCURSES_LIBS = -lncursesw
endif

CFLAGS = -Wall -Wextra -g -D_FORTIFY_SOURCE=2 $(NCURSES_CFLAGS)
LDFLAGS = $(NCURSES_LIBS)
OBJ = kernel-install.o
TARGET = kernel-installer-lts
DISTRO_DIR = distro
DISTRO_HEADERS = $(DISTRO_DIR)/common.h $(DISTRO_DIR)/debian.h $(DISTRO_DIR)/linuxmint.h $(DISTRO_DIR)/fedora.h $(DISTRO_DIR)/distros.h

# Reglas de compilación
$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET) $(LDFLAGS)
	$(CC) kernel-install-cloud.o -o kernel-installer-lts-cloud $(LDFLAGS)
	deps/shc -rS -f kernel-selector-lts.sh -o kernel-selector-lts.o
	mv kernel-selector-lts.sh.x.c kernel-selector-lts.c
	gcc -static kernel-selector-lts.c -o kernel-selector-lts
	rm -rf kernel-selector-lts.c
	rm -rf kernel-selector-lts.o
	rm -rf kernel-install.o

kernel-install.o: kernel-install.c $(DISTRO_HEADERS)
	$(CC) $(CFLAGS) -c kernel-install.c -o kernel-install.o
	$(CC) $(CFLAGS) -c kernel-install-cloud.c -o kernel-install-cloud.o

install: $(TARGET)
	cp $(TARGET) /usr/local/bin/
	cp kernel-installer-lts-cloud /usr/local/bin/
	cp kernel-selector-lts /usr/local/bin/
	cp config-cloud-amd64 /boot/

uninstall:
	rm -f /usr/local/bin/$(TARGET)
	rm -f /usr/local/bin/kernel-installer-lts-cloud
	rm -f /usr/local/bin/kernel-selector-lts

clean:
	rm -f $(TARGET) $(OBJ)
	rm -f kernel-installer-lts-cloud
	rm -f kernel-selector-lts

.PHONY: all install uninstall clean
