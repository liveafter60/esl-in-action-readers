DIR = bin
CMD = pdflatex -halt-on-error -output-directory=$(DIR)

all: r1 r2 r3

r1:
	mkdir -p $(DIR)/01
	$(CMD)/01 01/cover.tex
	$(CMD)/01 01/this-is-fairys-album.tex
	$(CMD)/01 01/cover.tex
	$(CMD)/01 01/this-is-fairys-album.tex
r2:
	mkdir -p $(DIR)/02
	$(CMD)/02 02/cover.tex
	$(CMD)/02 02/the-old-woman-who-lived-in-a-shoe.tex
	$(CMD)/02 02/cover.tex
	$(CMD)/02 02/the-old-woman-who-lived-in-a-shoe.tex

r3:
	mkdir -p $(DIR)/03
	$(CMD)/03 03/cover.tex
	$(CMD)/03 03/fairys-dream.tex
	$(CMD)/03 03/cover.tex
	$(CMD)/03 03/fairys-dream.tex

clean:
	rm -rfv bin/*

