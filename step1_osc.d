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
import std;

enum sampleRate = 44_100;

struct Osc {
  enum Kind {
    sin,
    square,
    saw,
    noise,
  }
  // Returns [-1, 1] value at the current phase and freq.
  float front() const @nogc @safe {
    final switch (_kind) {
    case Kind.sin:
      return sin(_phase);
    case Kind.saw:
      return _phase - PI;
    case Kind.square:
      return sgn(_phase - PI);
    case Kind.noise:
      return uniform01!float() * 2 - 1;
    }
  }

  // Increments phase with angular freq normalized by the sample rate.
  void popFront() @nogc @safe {
    _phase += 2.0 * PI * _freq / sampleRate;
    _phase %= 2.0 * PI;
  }

  enum bool empty = false; // Infinite range.

  Kind _kind = Kind.sin;
  float _freq = 0; // in herz. must be > 0.
  float _phase = 0; // in [0, 2 * PI].
}

void main(string[] args) {
  info("Available Osc kinds: ", [EnumMembers!(Osc.Kind)]);
  File output = args.length > 1 ? File(args[1], "wb") : stdout;
  info("Output file:", output.name);
  enum chunkSize = 128;
  foreach (kind; EnumMembers!(Osc.Kind))
    foreach (chunk; Osc(kind, 440).take(sampleRate).chunks(chunkSize))
      output.rawWrite(staticArray!chunkSize(chunk));
}
