# $File: latex.make
# $Date: Tue Apr 08 16:01:13 2014 +0800
# $Author: jiakai <jia.kai66@gmail.com>

TARGET = <++>
PDFDEPS = build $(addprefix build/,$(wildcard *.tex)) \
		  $(addprefix build/,$(wildcard *.bib))

all: view

build/$(TARGET).pdf: $(PDFDEPS)
	cd build && latexmk -xelatex -8bit -shell-escape $(TARGET).tex

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
