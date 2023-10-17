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
enum noise = Xorshift(1).map!"2f*a/uint.max-1";

// Returns saw waveform in [-PI, PI] cycled in the given frequency.
struct Osc {
  @nogc pure @safe:
  float front() const { return PI * (2 * t - 1); }
  void popFront() { t = (t + freq / sampleRate) % 1; }
  enum empty = false;
  float freq = 0;
  float t = 0;
}

void main(string[] args) {
  File output = args.length > 1 ? File(args[1], "wb") : stdout;
  Osc osc = {freq: 440};
  foreach (r; tuple(osc.map!sin, osc.map!sgn, osc, noise)) {
    output.rawWrite(r.take(sampleRate).array);
  }
}
