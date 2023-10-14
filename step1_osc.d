// Usage:
//   rdmd step1_sin.d |  ffplay - -f f32le -ar 44100 -ac 2
import std.math;
import std.stdio;

const float sampleRate = 44_100;

struct Osc {
  enum Kind {
    sin,
    saw,
    square,
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
    }
  }

  // Increments phase with angular freq normalized by the sample rate.
  void popFront() {
    _phase += 2.0 * PI * _freq / sampleRate;
    _phase %= 2.0 * PI;
  }

  enum bool empty = false;

  Kind _kind = Kind.sin;
  float _freq = 0;
  float _phase = 0;
}

void main() {
  float i = 0;
  float[2] wav;
  foreach (x; Osc(Osc.Kind.sin, 440)) {
    wav[] = x;
    stdout.rawWrite(wav);
  }
}
