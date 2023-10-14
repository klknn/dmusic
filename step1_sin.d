// Usage:
//   rdmd step1_sin.d |  ffplay - -f f32le -ar 44100 -ac 2
import std.math;
import std.stdio;

void main() {
  float sampleRate = 44_100;
  float i = 0;
  float[2] wav;
  while (true) {
    wav[] = sin(2.0 * PI * 440 * i / sampleRate);
    stdout.rawWrite(wav);
    ++i;
  }
}
