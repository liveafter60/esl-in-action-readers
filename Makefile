DIR = bin
CMD = pdflatex -halt-on-error -output-directory=$(DIR)

all: r1 r2

r1:
	mkdir -p bin
	$(CMD) 01/cover.tex
	$(CMD) 01/this-is-fairys-album.tex
	$(CMD) 01/cover.tex
	$(CMD) 01/this-is-fairys-album.tex
r2:
	mkdir -p bin
	$(CMD) 02/cover.tex
	$(CMD) 02/the-old-woman-who-lived-in-a-shoe.tex
	$(CMD) 02/cover.tex
	$(CMD) 02/the-old-woman-who-lived-in-a-shoe.tex

clean:
	rm -rfv bin/*

