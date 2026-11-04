"""Flat-style sketch for Lecture 8 (Multiple OLS): reachability bias at the doorstep.

Writes next to this file:
  reachability.svg   slide "Who opens the door first?"

Reuses the people and drawing helpers from img/L5/make_sketches.py, so both decks share one style.

Pure Python, no dependencies:  cd quarto-poc && python3 img/L8/make_sketches.py
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "L5"))
from make_sketches import C, person, svg, text  # noqa: E402


def door(x, y, w=118, h=250, open_=False, col=None):
    """Front door with its frame, bottom-left corner at (x, y + h)."""
    col = col or C["navy"]
    g = [f'<rect x="{x-10}" y="{y-10}" width="{w+20}" height="{h+10}" fill="{C["wood2"]}"/>',
         f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{C["ink"] if open_ else col}"/>']
    if open_:  # the door leaf swung inwards, seen edge-on at the left
        g.append(f'<path d="M {x},{y} L {x+26},{y+14} L {x+26},{y+h-6} L {x},{y+h} Z" fill="{col}"/>')
    else:
        g.append(f'<rect x="{x+14}" y="{y+16}" width="{w-28}" height="{h/2-30}" rx="4" fill="none" '
                 f'stroke="{C["slate"]}" stroke-width="3"/>'
                 f'<rect x="{x+14}" y="{y+h/2}" width="{w-28}" height="{h/2-30}" rx="4" fill="none" '
                 f'stroke="{C["slate"]}" stroke-width="3"/>'
                 f'<circle cx="{x+w-16}" cy="{y+h/2-6}" r="5" fill="{C["mustard"]}"/>')
    return "".join(g)


def clipboard():
    """A clipboard held in front of the chest (coordinates of the person() figure)."""
    return (f'<rect x="-20" y="-134" width="40" height="50" rx="3" fill="{C["wood"]}"/>'
            f'<rect x="-16" y="-128" width="32" height="40" fill="{C["white"]}"/>'
            f'<rect x="-8" y="-138" width="16" height="7" rx="2" fill="{C["grey"]}"/>'
            + "".join(f'<line x1="-12" y1="{-120+i*7}" x2="12" y2="{-120+i*7}" stroke="{C["grey"]}" stroke-width="1.4"/>'
                      for i in range(4)))


def chip(cx, y, w, label, col):
    return (f'<rect x="{cx-w/2}" y="{y}" width="{w}" height="40" rx="20" fill="{C["white"]}"/>'
            + text(cx, y + 27, label, size=19, weight="bold", fill=col))


def reachability():
    W, H = 1000, 600
    g = []
    # ---- left panel: Inge opens on the first visit, in daylight
    px = 20
    g.append(f'<rect x="{px}" y="20" width="470" height="430" rx="18" fill="{C["paper2"]}"/>')
    g.append(text(px + 235, 58, "Inge, 71, retired", size=27, weight="bold", fill=C["slate"]))
    g.append(f'<rect x="{px+30}" y="90" width="96" height="92" rx="6" fill="{C["sky"]}" opacity="0.6"/>'
             f'<circle cx="{px+100}" cy="116" r="13" fill="{C["mustard"]}"/>'
             f'<rect x="{px}" y="372" width="470" height="78" fill="{C["sand"]}" opacity="0.55"/>')
    g.append(door(px + 280, 122, open_=True, col=C["teal"]))
    g.append(person(px + 345, 372, 1.22, skin="light", hair="grey", hairstyle="bun", top="mustard",
                    bottom="slate", glasses=True, mood="smile", arms="down"))
    g.append(person(px + 150, 380, 1.32, skin="tan", hair="brown", hairstyle="short", top="red",
                    bottom="ink", arms="hold", mood="smile", extra_front=clipboard()))
    g.append(chip(px + 235, 396, 330, "Visit 1: at home ✓", C["slate"]))

    # ---- right panel: Mikkel is out three times, opens on the fourth visit, at night
    px = 510
    g.append(f'<rect x="{px}" y="20" width="470" height="430" rx="18" fill="{C["paper2"]}"/>')
    g.append(text(px + 235, 58, "Mikkel, 26, works shifts", size=27, weight="bold", fill=C["red"]))
    g.append(f'<rect x="{px+30}" y="90" width="96" height="92" rx="6" fill="{C["navy"]}"/>'
             f'<circle cx="{px+98}" cy="116" r="12" fill="{C["white"]}"/>'
             f'<circle cx="{px+104}" cy="111" r="11" fill="{C["navy"]}"/>'
             f'<rect x="{px}" y="372" width="470" height="78" fill="{C["sand"]}" opacity="0.55"/>')
    g.append(door(px + 300, 122, open_=False, col=C["rust"]))
    # the "sorry we missed you" card with three failed visits
    g.append(f'<rect x="{px+318}" y="150" width="82" height="62" rx="3" fill="{C["white"]}" '
             f'transform="rotate(-4 {px+359} 181)"/>'
             + text(px + 359, 172, "Sorry we", size=12, fill=C["ink"])
             + text(px + 359, 186, "missed you", size=12, fill=C["ink"])
             + text(px + 359, 205, "✗ ✗ ✗", size=15, weight="bold", fill=C["red"]))
    g.append(person(px + 175, 380, 1.32, skin="medium", hair="black", hairstyle="short", top="slate",
                    bottom="navy", arms="phone", hood=True, headphones=True, mood="neutral"))
    g.append(chip(px + 235, 396, 330, "Visit 4: finally home ✓", C["red"]))

    # ---- timeline: the fieldwork window around the attack
    x0, x1 = 70, 930
    days = 36                         # 14 Sep .. 20 Oct 2002
    pos = lambda d: x0 + d / days * (x1 - x0)
    attack = pos(29)                  # 13 Oct
    y = 515
    g.append(f'<line x1="{x0}" y1="{y}" x2="{attack}" y2="{y}" stroke="{C["slate"]}" stroke-width="8" stroke-linecap="round"/>'
             f'<line x1="{attack}" y1="{y}" x2="{x1}" y2="{y}" stroke="{C["red"]}" stroke-width="8" stroke-linecap="round"/>')
    g.append(text((x0 + attack) / 2, y + 34, "interviewed before = control", size=19, weight="bold", fill=C["slate"])
             + text((attack + x1) / 2 + 4, y + 34, "after = treated", size=19, weight="bold", fill=C["red"])
             + text(x0, y + 62, "14 Sep 2002", size=16, fill=C["grey"], anchor="start")
             + text(x1, y + 62, "20 Oct 2002", size=16, fill=C["grey"], anchor="end"))
    g.append(f'<line x1="{attack}" y1="{y-30}" x2="{attack}" y2="{y+14}" stroke="{C["ink"]}" stroke-width="3"/>'
             + text(attack - 12, y - 16, "Bali attack, 13 Oct", size=18, weight="bold", fill=C["ink"], anchor="end"))
    for d, name, col in [(3, "Inge", C["slate"]), (32, "Mikkel", C["red"])]:
        g.append(f'<circle cx="{pos(d)}" cy="{y}" r="11" fill="{C["white"]}" stroke="{col}" stroke-width="4"/>'
                 + text(pos(d), y - 22, name, size=18, weight="bold", fill=col))
    return svg(W, H, "".join(g), bg=False)


if __name__ == "__main__":
    with open(os.path.join(HERE, "reachability.svg"), "w", encoding="utf-8") as f:
        f.write(reachability())
    print("wrote reachability.svg")
