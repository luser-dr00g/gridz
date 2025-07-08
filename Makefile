
.PHONY: all example

all: example

example: gridz.pdf

gridz.pdf: gridz.ps
	gs -dBATCH -sDEVICE=pdfwrite -sOutputFile=gridz.pdf -dEXAMPLE gridz.ps
