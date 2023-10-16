// Usage:
// - Listen to output raw file by VideoLAN VLC (it also suports pipe input "-")
//   $ rdmd step1_osc.d output.raw
//   $ vlc -I dummy --demux=rawaud --rawaud-channels 1 --rawaud-samplerate 44100 --rawaud-fourcc f32l output.raw vlc://quit
//
// - Look at its spectrum by FFMPEG ffplay.
//   $ ffplay -f f32le -ar 44100 -ac 1 output.raw
//
// - Convert it to WAV by FFMPEG.
//   $ ffmpeg -f f32le -ar 44100 -ac 1 -i output.raw output.wav
// dfmt off
import std;

enum sampleRate = 44_100;

float saw(float x) { return x - PI; }
float square(float x) { return sgn(x - PI); }

struct Osc(alias fun) {
  float front() const { return fun(_x); }
  void popFront() { _x = (_x + 2 * PI * _freq / sampleRate) % (2 * PI); }
  enum bool empty = false;
  float _freq = 0; // in herz. must be > 0.
  float _x = 0; // in [0, 2 * PI].
}

enum noise = Xorshift(1).map!(a => 2f * a / uint.max - 1);

void writeSamples(int chunkSize = 128, R)(ref File output, R range) {
   foreach (chunk; range.chunks(chunkSize))
      output.rawWrite(staticArray!chunkSize(chunk));
}

void main(string[] args) {
  File output = args.length > 1 ? File(args[1], "wb") : stdout;
  int n = sampleRate; // 1sec.
  foreach (r; tuple(Osc!sin(440), Osc!square(440), Osc!saw(440), noise)) {
    output.writeSamples(r.take(n));
  }
}
