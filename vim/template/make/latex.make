# $File: latex.make
# $Date: Sun Sep 16 15:04:55 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

TARGET = <++>
TEX = xelatex -shell-escape
PDFDEPS = build $(addprefix build/,$(wildcard *.tex))

all: view

build/$(TARGET).pdf: $(PDFDEPS)
	cd build && $(TEX) $(TARGET).tex && $(TEX) $(TARGET).tex

build/%: %
	[ -h $@ ] || ln -s ../$< build/

build:
	mkdir $@

view: build/$(TARGET).pdf
	evince build/$(TARGET).pdf

rebuild: clean build/$(TARGET).pdf

clean:
	rm -rf build

.PHONY: all view clean rebuild

# vim: ft=make
