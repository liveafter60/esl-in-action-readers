DIR = bin
CMD_PDF = pdflatex -halt-on-error -output-directory=$(DIR)
CMD_PNG = pdftoppm -png

all: r1 r2 r3

r1:
	 ./build.py -d $(DIR) -i 01 -n this-is-fairys-album

r2:
	 ./build.py -d $(DIR) -i 02 -n the-old-woman-who-lived-in-a-shoe

r3:
	./build.py -d $(DIR) -i 03 -n fairys-dream

r4:
	./build.py -d $(DIR) -i 04 -n peace-and-war

clean:
	rm -rfv bin/*

