DIR = bin
CMD = pdflatex -halt-on-error -output-directory=$(DIR)

all:
	mkdir -p bin
	$(CMD) 01-this-is-fairys-album/cover.tex
	$(CMD) 01-this-is-fairys-album/this-is-fairys-album.tex
	$(CMD) 01-this-is-fairys-album/cover.tex
	$(CMD) 01-this-is-fairys-album/this-is-fairys-album.tex
	$(CMD) 02-the-old-woman-who-lived-in-a-shoe/cover.tex
	$(CMD) 02-the-old-woman-who-lived-in-a-shoe/the-old-woman-who-lived-in-a-shoe.tex
	$(CMD) 02-the-old-woman-who-lived-in-a-shoe/cover.tex
	$(CMD) 02-the-old-woman-who-lived-in-a-shoe/the-old-woman-who-lived-in-a-shoe.tex

clean:
	rm -rfv bin/*

