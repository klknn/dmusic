// dfmt off
import std;

enum sampleRate = 44_100;
enum noise = Xorshift(1).map!(a => 2f* a / uint.max - 1);

struct Osc {
  @nogc pure @safe:
  float front() const { return PI * (2 * t - 1); }
  void popFront() { t = (t + freq / sampleRate) % 1; }
  enum empty = false;
  float freq = 0;
  float t = 0;
}

float toHertz(float note) @nogc pure @safe {
  return 440.0f * pow(2.0, (note - 69.0f) / 12.0f);
}

void main(string[] args) {
  File output = args.length > 1 ? File(args[1], "wb") : stdout;
  foreach (osc; [60, 62, 64, 65, 67, 69, 71, 72].map!toHertz.map!Osc) {
    static foreach (fn; AliasSeq!(sin, sgn, x => x / cast(float) PI)) {
      output.rawWrite(osc.map!fn.take(sampleRate / 2).array);
    }
  }
}
