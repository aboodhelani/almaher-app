"""Synthesises the competition's original sound effects into assets/sounds/.

Run: python3 tool/make_sounds.py   (standard library only)
"""
import math
import struct
import wave
from pathlib import Path

RATE = 44100
OUT = Path(__file__).resolve().parent.parent / "assets" / "sounds"


def tone(freq, dur, vol=0.5, shape="sine", attack=0.01, release=0.08, glide=None):
    """One note with a soft attack/release; [glide] slides to another freq."""
    n = int(RATE * dur)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / RATE
        f = freq if glide is None else freq + (glide - freq) * (i / n)
        phase += 2 * math.pi * f / RATE
        if shape == "sine":
            v = math.sin(phase)
        elif shape == "square":
            v = 0.6 if math.sin(phase) >= 0 else -0.6
        elif shape == "tri":
            v = 2 / math.pi * math.asin(math.sin(phase))
        else:  # bell: sine + soft octave partial
            v = 0.75 * math.sin(phase) + 0.25 * math.sin(2 * phase)
        env = min(1.0, t / attack) if attack else 1.0
        env *= min(1.0, (dur - t) / release) if release else 1.0
        out.append(v * vol * max(0.0, env))
    return out


def silence(dur):
    return [0.0] * int(RATE * dur)


def mix(*tracks):
    n = max(len(t) for t in tracks)
    return [sum(t[i] for t in tracks if i < len(t)) for i in range(n)]


def save(name, samples):
    peak = max(1e-9, max(abs(s) for s in samples))
    gain = min(1.0, 0.9 / peak)
    with wave.open(str(OUT / name), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b"".join(struct.pack("<h", int(s * gain * 32767)) for s in samples))


OUT.mkdir(parents=True, exist_ok=True)

# New question: a rising three-note bell.
save("question.wav", tone(659, 0.12, 0.5, "bell") + tone(784, 0.12, 0.5, "bell") + tone(1047, 0.32, 0.55, "bell", release=0.25))

# Buzzer pressed: a bright, punchy double square.
save("buzz.wav", mix(tone(880, 0.28, 0.35, "square", release=0.05), tone(1320, 0.28, 0.2, "square", release=0.05)))

# Correct: a quick major third up.
save("correct.wav", tone(784, 0.11, 0.5, "tri") + tone(1175, 0.30, 0.55, "tri", release=0.2))

# Wrong: a low falling buzz.
save("wrong.wav", tone(330, 0.35, 0.45, "square", glide=196, release=0.12))

# Last seconds: a short wooden tick.
save("tick.wav", tone(1600, 0.035, 0.45, "sine", attack=0.002, release=0.03))

# Winner: an ascending arpeggio into a held chord.
arp = []
for f in (523, 659, 784, 1047):
    arp += tone(f, 0.13, 0.45, "bell", release=0.06)
chord = mix(tone(523, 0.9, 0.3, "bell", release=0.6), tone(659, 0.9, 0.3, "bell", release=0.6), tone(784, 0.9, 0.3, "bell", release=0.6), tone(1047, 0.9, 0.25, "bell", release=0.6))
save("win.wav", arp + chord)

print("wrote", sorted(p.name for p in OUT.glob("*.wav")))
