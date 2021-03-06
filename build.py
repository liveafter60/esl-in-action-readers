#!/usr/bin/env python3


import os, sys, getopt, glob, configparser


class Build:
    odir = ''
    index = ''
    name = ''
    config = None


    def parse_argv(self, argv):
        try:
            opts, args = getopt.getopt(argv, 'hd:i:n:', ['directory=', 'index=',
                'name='])

        except:
            print('./build.py -d <output-directory> -i <index> -n <name>')
            sys.exit(2)

        for opt, arg in opts:
            if opt == '-h':
                print('./build.py -d <output-directory> -i <index> -n <name>')
                sys.exit()
            
            elif opt in ('-d', '--directory'):
                self.odir = arg

            elif opt in ('-i', '--index'):
                self.index = arg

            elif opt in ('-n', '--name'):
                self.name = arg


    def read_config(self):
        self.config = configparser.ConfigParser()
        self.config.read(self.index + '/frames.cfg')


    def read_duration(self, frame):
        return self.config['frames']['frame_' + str(frame)]


    def read_delay(self):
        return int(self.config['frames']['delay']) * 1000


    def gen_pdf(self):
        cmd_dir = 'mkdir -p {}/{}'.format(self.odir, self.index)
        cmd_base = ('pdflatex -halt-on-error -output-directory={}/{} {}/'
            ).format(self.odir, self.index, self.index)

        cmd_cover = cmd_base + 'cover.tex'
        cmd_text = cmd_base + self.name

        os.system(cmd_dir)
        os.system(cmd_cover)
        os.system(cmd_text)
        os.system(cmd_cover)
        os.system(cmd_text)


    def gen_frames(self):
        cmd = 'pdftoppm -png {}/{}/{}.pdf {}/{}/frame'.format(self.odir, 
            self.index, self.name, self.odir, self.index)
        os.system(cmd)


    def gen_video(self):
        path = '{}/{}/playlist.txt'.format(self.odir, self.index)
        with open(path, 'w') as playlist:
            count = len(glob.glob1(self.odir + '/' + self.index, '*.png'))
            for i in range(count):
                j = i + 1
                
                if count < 9:
                    record = 'file frame-' + str(j) + '.mp4\n'
                else:
                    record = 'file frame-' + str(j).zfill(2) + '.mp4\n'
                
                playlist.write(record)

                if count < 9:
                    cmd = 'ffmpeg -loop 1 -i {}/{}/frame-{}.png' \
                        ' -t {} {}/{}/frame-{}.mp4'.format(self.odir,
                        self.index, j, self.read_duration(j), self.odir,
                        self.index, j)
                else:
                    cmd = 'ffmpeg -loop 1 -i {}/{}/frame-{}.png' \
                        ' -t {} {}/{}/frame-{}.mp4'.format(self.odir,
                        self.index, str(j).zfill(2), self.read_duration(j),
                        self.odir, self.index, str(j).zfill(2))

                os.system(cmd)

            playlist.write('file logo.mp4\n')
            cmd = 'ffmpeg -loop 1 -i img/logo.png -t 3 {}/{}/logo.mp4'.format(
                self.odir, self.index)
            os.system(cmd)

        cmd = 'ffmpeg -f concat -i {}/{}/playlist.txt' \
            ' -c copy {}/{}/tmp.mp4'.format(self.odir, self.index, self.odir,
            self.index)
        os.system(cmd)


    def mix_audio(self):
        cmd = 'ffmpeg -i {}/media/{}.mp3 -af "adelay={}|{}"' \
            ' {}/{}/tmp.mp3'.format(self.index, self.name, self.read_delay(), 
            self.read_delay(), self.odir, self.index)
        os.system(cmd)

        cmd = ('ffmpeg -i {}/{}/tmp.mp3 -af "apad=pad_dur=3" {}/{}/tmp2.mp3'
            ).format(self.odir, self.index, self.odir, self.index)
        os.system(cmd)

        cmd = 'ffmpeg -i {}/{}/tmp.mp4 -i {}/{}/tmp2.mp3 -map 0 -map 1:a' \
            ' -c:v copy -shortest {}/{}/{}.mp4'.format(self.odir, self.index, 
            self.odir, self.index, self.odir, self.index, self.name)
        os.system(cmd)


if __name__ == '__main__':

    b = Build()

    b.parse_argv(sys.argv[1:])
    b.read_config()
    b.gen_pdf()
    b.gen_frames()
    b.gen_video()
    b.mix_audio()

