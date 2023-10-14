# dmusic

WIP music programming in D.

## Requirements

Download these binaries:
- D compiler (LDC2 1.32.2 is tested) https://github.com/ldc-developers/ldc/releases
- ffplay (4.4.2 is tested) https://ffbinaries.com/downloads

## Tutorial

### Step 1 Play sine wave

Run this command to listen to 440Hz sine wave in your computer.

```shell
$ rdmd step1_osc.d |  ffplay - -f f32le -ar 44100 -ac 2
```

Then, let's change the sine wave into saw or square, or why don't you add your own osc?
