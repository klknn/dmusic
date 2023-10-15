# dmusic

WIP music programming in D.

## Requirements

Download these binaries:
- D compiler (LDC2 1.32.2 is tested) https://github.com/ldc-developers/ldc/releases
- VideoLAN VLC (3.0.16 is tested) https://www.videolan.org/vlc/#download
- (optional) FFmpeg https://ffmpeg.org/download.html

## Tutorial

### Step 1 Play sound

Run this command to play 440Hz sin/square/saw/noise wave in your computer. `rdmd` and `vlc` executables are found in the downloaded archive in the previous "Requirements" section.

```shell
$ rdmd step1_osc.d output.raw
$ vlc -I dummy --demux=rawaud --rawaud-channels 1 --rawaud-samplerate 44100 --rawaud-fourcc f32l output.raw vlc://quit
```

(Optional) If you have the ffmpeg, you can convert the raw file to WAV file so that you can listen to your sound in popular players:

```shell
$ ffmpeg -f f32le -ar 44100 -ac 1 -i output.raw output.wav
```

You can find more fun usages in the code header doc. Let's tweak the oscillators to make some strange sounds.
