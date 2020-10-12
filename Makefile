DIR = bin
CMD_PDF = pdflatex -halt-on-error -output-directory=$(DIR)
CMD_PNG = pdftoppm -png

all: r1 r2 r3

r1:
	mkdir -p $(DIR)/01
	$(CMD_PDF)/01 01/cover.tex
	$(CMD_PDF)/01 01/this-is-fairys-album.tex
	$(CMD_PDF)/01 01/cover.tex
	$(CMD_PDF)/01 01/this-is-fairys-album.tex
	$(CMD_PNG) $(DIR)/01/this-is-fairys-album.pdf $(DIR)/01/frame
	ffmpeg -loop 1 -i $(DIR)/01/frame-1.png -t 5 $(DIR)/01/frame-1.mp4
	ffmpeg -loop 1 -i $(DIR)/01/frame-2.png -t 5 $(DIR)/01/frame-2.mp4
	ffmpeg -loop 1 -i $(DIR)/01/frame-3.png -t 5 $(DIR)/01/frame-3.mp4
	ffmpeg -loop 1 -i $(DIR)/01/frame-4.png -t 5 $(DIR)/01/frame-4.mp4
	ffmpeg -loop 1 -i $(DIR)/01/frame-5.png -t 5 $(DIR)/01/frame-5.mp4
	cd $(DIR)/01; printf "file '%s\n" *.mp4 > PLAYLIST; cd ..
	ffmpeg -f concat -i $(DIR)/01/PLAYLIST -c copy $(DIR)/01/out.mp4
	ffmpeg -i $(DIR)/01/out.mp4 -i 01/vid/this-is-fairys-album.mp3 -map 0 -map 1:a -c:v copy -shortest $(DIR)/01/this-is-fairys-album.mp4

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
