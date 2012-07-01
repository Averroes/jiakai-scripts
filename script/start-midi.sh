#!/bin/bash -e
sudo modprobe snd_seq
sudo fluidsynth -a alsa -m alsa_seq -g 0.5 -is /home/fluid-soundfont-3.1/FluidR3_GM.sf2 &
