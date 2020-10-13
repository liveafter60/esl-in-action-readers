DIR = bin
CMD_PDF = pdflatex -halt-on-error -output-directory=$(DIR)
CMD_PNG = pdftoppm -png

all: r1 r2 r3

r1:
	 ./build.py -d $(DIR) -i 01 -n this-is-fairys-album

r2:
	mkdir -p $(DIR)/02
	$(CMD_PDF)/02 02/cover.tex
	$(CMD_PDF)/02 02/the-old-woman-who-lived-in-a-shoe.tex
	$(CMD_PDF)/02 02/cover.tex
	$(CMD_PDF)/02 02/the-old-woman-who-lived-in-a-shoe.tex
	$(CMD_PNG) $(DIR)/02/the-old-woman-who-lived-in-a-shoe.pdf $(DIR)/02/frame

r3:
	mkdir -p $(DIR)/03
	$(CMD_PDF)/03 03/cover.tex
	$(CMD_PDF)/03 03/fairys-dream.tex
	$(CMD_PDF)/03 03/cover.tex
	$(CMD_PDF)/03 03/fairys-dream.tex
	$(CMD_PNG) $(DIR)/03/fairys-dream.pdf $(DIR)/03/frame

clean:
	rm -rfv bin/*

# https://trac.ffmpeg.org/wiki/Concatenate
