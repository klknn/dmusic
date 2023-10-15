// Usage:
//   rdmd step1_osc.d |  ffplay - -f f32le -ar 44100 -ac 2
import std.logger;
import std.math;
import std.random;
import std.range;
import std.stdio;

const float sampleRate = 44_100;

struct Osc {
  enum Kind {
    sin,
    saw,
    square,
    noise,
  }

  // Returns [-1, 1] value at the current phase and freq.
  float front() const {
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
  void popFront() {
    _phase += 2.0 * PI * _freq / sampleRate;
    _phase %= 2.0 * PI;
  }

  enum bool empty = false;

  Kind _kind = Kind.sin;
  float _freq = 0; // in herz. must be > 0.
  float _phase = 0; // in [0, 2 * PI].
}

void main() {
  float[2] wav;
  foreach (x; Osc(Osc.Kind.noise, 440)) {
    wav[] = x;
    stdout.rawWrite(wav);
  }
}
