#!/usr/bin/env python


import os, sys, getopt, glob


class Build:
    directory = ''
    name = ''


    def argparse(self, argv):
        try:
            opts, args = getopt.getopt(argv, 'hd:n:', ['directory=', 'name='])

        except:
            print('./build.py -d <directory> -n <name>')
            sys.exit(2)

        for opt, arg in opts:
            if opt == '-h':
                print('./build.py -d <directory> -n <name>')
                sys.exit()

            elif opt in ('-d', '--directory'):
                self.directory = arg

            elif opt in ('-n', '--name'):
                self.name = arg


    def pdflatex(self):
        cmd_dir = 'mkdir -p bin/' + self.directory
        cmd_base = ('pdflatex -halt-on-error -output-directory=bin/{} {}/'
            ).format(self.directory, self.directory)

        cmd_cover = cmd_base + 'cover.tex'
        cmd_text = cmd_base + self.name

        os.system(cmd_dir)
        os.system(cmd_cover)
        os.system(cmd_text)
        os.system(cmd_cover)
        os.system(cmd_text)


    def pdftoppm(self):
        cmd = 'pdftoppm -png bin/{}/{}.pdf bin/{}/frame'.format(self.directory,
            self.name, self.directory)
        os.system(cmd)


    def ffmpeg(self):
        count = len(glob.glob1('bin/' + self.directory, '*.png'))
        cmd = 'ffmpeg -loop 1 -i bin/{}/frame-{}.png -t 5 bin/{}/frame-{}.mp4'
        playlist = open('bin/{}/playlist.txt'.format(self.directory), 'w')

        for x in range(count):
            playlist.write('file frame-{}.mp4\n'.format(x + 1))
            os.system(cmd.format(self.directory, x + 1, self.directory,
                x + 1))

        playlist.close()
        cmd = 'ffmpeg -f concat -i bin/{}/playlist.txt -c copy bin/{}/tmp.mp4'
        os.system(cmd.format(self.directory, self.directory))

        cmd = 'ffmpeg -i {}/vid/{}.mp3 -af adelay="10000|10000" bin/{}/tmp.mp3'
        os.system(cmd.format(self.directory, self.name, self.directory))

        cmd = ('ffmpeg -i bin/{}/tmp.mp4 -i bin/{}/tmp.mp3 -map 0 -map 1:a -c:v'
            + ' copy -shortest bin/{}/{}.mp4')
        os.system(cmd.format(self.directory, self.directory, self.directory,
            self.name))


if __name__ == '__main__':

    b = Build()

    b.argparse(sys.argv[1:])
    b.pdflatex()
    b.pdftoppm()
    b.ffmpeg()

