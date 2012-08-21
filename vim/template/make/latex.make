# $File: latex.make
# $Date: Wed Jul 04 10:18:17 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

TARGET = <++>
TEX = xelatex -shell-escape
PDFDEPS = output $(addprefix output/,$(wildcard *.tex))


all: view

output/$(TARGET).pdf: $(PDFDEPS)
	cd output && $(TEX) $(TARGET).tex && $(TEX) $(TARGET).tex

output/%: %
	[ -h $@ ] || ln -s ../$< output/

output:
	mkdir $@

view: output/$(TARGET).pdf
	evince output/$(TARGET).pdf

rebuild: clean output/$(TARGET).pdf

clean:
	rm -rf output

.PHONY: all view clean rebuild

# vim: ft=make
