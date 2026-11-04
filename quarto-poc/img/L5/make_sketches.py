"""Flat-style sketches for Lecture 5 (Selection bias).

Writes next to this file:
  ferda_two_worlds.svg   slide "Two potential futures for one person"
  dating_profile.svg     slide "Selection is everywhere"

The person() helper is generic (seated/standing, hijab, hoodie, beanie, headphones, props),
so new scenes can be added as further functions.

Pure Python, no dependencies:  cd quarto-poc && python3 img/L5/make_sketches.py
The palette echoes the integration-paradox illustration on the research-question slide.
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))
FONT = "Helvetica Neue, Helvetica, Arial, sans-serif"

C = dict(
    paper="#f6efe4", paper2="#efe4d3", ink="#2b2623", navy="#2f3d5c", slate="#425570",
    red="#901A1E", rust="#c8643b", teal="#3a9e9a", mustard="#d9a441", sand="#e3cfb0",
    white="#fbf8f2", grey="#8a8580", lightgrey="#cfc6b8", black="#23222a", pink="#e98fb3",
    sky="#9fd3e6", green="#6a9a5b", wood="#9a6b45", wood2="#7c5436",
)
SKIN = dict(light="#f1caa6", medium="#d9a17a", tan="#b97e57", dark="#7d4e35")
HAIR = dict(black="#241d1b", brown="#5a3b2a", auburn="#8a3f25", blond="#d8b36a", grey="#c9c2b8")


def svg(w, h, body, bg=True):
    back = (f'<rect x="0" y="0" width="{w}" height="{h}" rx="22" fill="{C["paper"]}"/>'
            if bg else "")
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}" '
            f'font-family="{FONT}">{back}{body}</svg>')


def text(x, y, s, size=18, fill=None, weight="normal", anchor="middle", style=""):
    return (f'<text x="{x}" y="{y}" font-size="{size}" fill="{fill or C["ink"]}" '
            f'font-weight="{weight}" text-anchor="{anchor}" {style}>{s}</text>')


# --------------------------------------------------------------------------- people
def head(skin, hair, style, glasses=False, beard=False, cy=-178, mood="neutral"):
    """Head centred at (0, cy); returns (behind, front) svg so long hair/hijab can sit behind the body."""
    behind, front = "", ""
    h = HAIR.get(hair, hair)
    if style == "long":
        behind += (f'<path d="M -18,{cy} Q -21,{cy-26} 0,{cy-25} Q 21,{cy-26} 18,{cy} '
                   f'L 21,{cy+34} Q 0,{cy+40} -21,{cy+34} Z" fill="{h}"/>')
    if style == "hijab":
        behind += (f'<path d="M -21,{cy+2} Q -24,{cy-26} 0,{cy-26} Q 24,{cy-26} 21,{cy+2} '
                   f'L 30,{cy+38} Q 0,{cy+50} -30,{cy+38} Z" fill="{hair}"/>')
    face_rx, face_ry = (11.5, 13.5) if style == "hijab" else (15, 17)
    front += f'<ellipse cx="0" cy="{cy}" rx="{face_rx}" ry="{face_ry}" fill="{skin}"/>'
    if style in ("short", "bun", "long", "beanie"):
        front += (f'<path d="M -16,{cy+1} Q -18,{cy-22} 0,{cy-20} Q 18,{cy-22} 16,{cy+1} '
                  f'Q 13,{cy-11} 2,{cy-12} Q -9,{cy-9} -16,{cy+1} Z" fill="{h}"/>')
    if style == "beanie":
        front += (f'<path d="M -17,{cy-4} Q -17,{cy-30} 0,{cy-30} Q 17,{cy-30} 17,{cy-4} Z" fill="{C["mustard"]}"/>'
                  f'<rect x="-18" y="{cy-9}" width="36" height="7" rx="3" fill="#b8862f"/>')
    if style == "bun":
        front += f'<circle cx="0" cy="{cy-22}" r="8" fill="{h}"/>'
    if style == "curly":
        for dx, dy, r in [(-12, -8, 8), (-6, -15, 8), (3, -16, 8), (11, -11, 8), (15, -3, 6), (-15, -1, 6)]:
            front += f'<circle cx="{dx}" cy="{cy+dy}" r="{r}" fill="{h}"/>'
    if style == "bald":
        front += (f'<path d="M -15,{cy+2} Q -16,{cy-8} -12,{cy-10} L -12,{cy+2} Z '
                  f'M 15,{cy+2} Q 16,{cy-8} 12,{cy-10} L 12,{cy+2} Z" fill="{h}"/>')
    if beard:
        front += (f'<path d="M -14,{cy+2} Q -14,{cy+22} 0,{cy+24} Q 14,{cy+22} 14,{cy+2} '
                  f'Q 8,{cy+11} 0,{cy+10} Q -8,{cy+11} -14,{cy+2} Z" fill="{h}"/>')
    ey = cy - 1
    front += (f'<circle cx="-5" cy="{ey}" r="1.7" fill="{C["ink"]}"/>'
              f'<circle cx="5" cy="{ey}" r="1.7" fill="{C["ink"]}"/>')
    if mood == "smile":
        front += (f'<path d="M -4.5,{cy+7} Q 0,{cy+10.5} 4.5,{cy+7}" stroke="{C["ink"]}" '
                  f'stroke-width="1.4" fill="none" stroke-linecap="round"/>')
    elif mood == "concern":
        front += (f'<path d="M -4,{cy+9} Q 0,{cy+6.5} 4,{cy+9}" stroke="{C["ink"]}" '
                  f'stroke-width="1.4" fill="none" stroke-linecap="round"/>'
                  f'<path d="M -8,{ey-6} L -3,{ey-4.5} M 8,{ey-6} L 3,{ey-4.5}" stroke="{C["ink"]}" '
                  f'stroke-width="1.2" stroke-linecap="round"/>')
    else:
        front += (f'<path d="M -3.5,{cy+8} L 3.5,{cy+8}" stroke="{C["ink"]}" stroke-width="1.3" '
                  f'stroke-linecap="round"/>')
    if glasses:
        front += (f'<g fill="none" stroke="{C["ink"]}" stroke-width="1.3">'
                  f'<circle cx="-5.5" cy="{ey}" r="4.6"/><circle cx="5.5" cy="{ey}" r="4.6"/>'
                  f'<path d="M -0.9,{ey} L 0.9,{ey}"/></g>')
    return behind, front


def arm(x0, y0, x1, y1, sleeve, skin, w=11, bend=None):
    path = (f"M {x0},{y0} Q {bend[0]},{bend[1]} {x1},{y1}" if bend else f"M {x0},{y0} L {x1},{y1}")
    return (f'<path d="{path}" stroke="{sleeve}" stroke-width="{w}" fill="none" stroke-linecap="round"/>'
            f'<circle cx="{x1}" cy="{y1}" r="{w*0.55}" fill="{skin}"/>')


def person(x, y, s=1.0, skin="medium", hair="black", hairstyle="short", top="navy", bottom="ink",
           shoes="ink", dress=False, glasses=False, beard=False, arms="down", mood="neutral",
           seated=False, hijab=None, hood=False, headphones=False, extra_front="", flip=False):
    """Front-view figure standing (or seated) with feet at (x, y)."""
    sk = SKIN.get(skin, skin)
    tp, bt, sh = C.get(top, top), C.get(bottom, bottom), C.get(shoes, shoes)
    d = 28 if seated else 0              # seated: upper body sits lower
    style = "hijab" if hijab else hairstyle
    hcol = C.get(hijab, hijab) if hijab else hair
    behind, face = head(sk, hcol, style, glasses, beard, cy=-178 + d, mood=mood)
    g = [behind]
    # legs
    if seated:
        g.append(f'<rect x="-22" y="{-86+d}" width="44" height="22" rx="9" fill="{bt}"/>')
        g.append(f'<rect x="-19" y="-60" width="14" height="56" rx="6" fill="{bt}"/>')
        g.append(f'<rect x="5" y="-60" width="14" height="56" rx="6" fill="{bt}"/>')
    elif dress:
        g.append(f'<rect x="-15" y="-60" width="11" height="54" rx="5" fill="{sk}"/>')
        g.append(f'<rect x="4" y="-60" width="11" height="54" rx="5" fill="{sk}"/>')
    else:
        g.append(f'<rect x="-17" y="-94" width="15" height="88" rx="6" fill="{bt}"/>')
        g.append(f'<rect x="2" y="-94" width="15" height="88" rx="6" fill="{bt}"/>')
    g.append(f'<ellipse cx="-10" cy="-4" rx="11" ry="5" fill="{sh}"/>'
             f'<ellipse cx="10" cy="-4" rx="11" ry="5" fill="{sh}"/>')
    # neck + torso
    g.append(f'<rect x="-5" y="{-166+d}" width="10" height="12" fill="{sk}"/>')
    g.append(f'<path d="M -27,{-146+d} Q -26,{-158+d} -14,{-158+d} L 14,{-158+d} Q 26,{-158+d} 27,{-146+d} '
             f'L 23,{-90+d} L -23,{-90+d} Z" fill="{tp}"/>')
    if dress:
        g.append(f'<path d="M -23,{-96+d} L 23,{-96+d} L 31,-54 L -31,-54 Z" fill="{bt}"/>')
    if hood:  # hoodie: hood resting behind the neck, front pocket, strings
        g.append(f'<path d="M -21,{-160+d} Q 0,{-176+d} 21,{-160+d} L 17,{-150+d} Q 0,{-158+d} -17,{-150+d} Z" fill="#000" opacity="0.35"/>')
        g.append(f'<path d="M -14,{-112+d} L 14,{-112+d} L 17,{-96+d} L -17,{-96+d} Z" fill="#000" opacity="0.18"/>'
                 f'<path d="M -5,{-154+d} L -6,{-136+d} M 5,{-154+d} L 6,{-136+d}" stroke="{C["white"]}" '
                 f'stroke-width="1.6" stroke-linecap="round"/>')
    # arms
    L, R = (-25, -148 + d), (25, -148 + d)
    if arms == "down":
        g.append(arm(*L, -31, -98 + d, tp, sk) + arm(*R, 31, -98 + d, tp, sk))
    elif arms == "pockets":
        g.append(arm(*L, -18, -106 + d, tp, sk, bend=(-33, -125 + d)) +
                 arm(*R, 18, -106 + d, tp, sk, bend=(33, -125 + d)))
    elif arms == "hold":      # both hands in front of the chest (newspaper, form)
        g.append(arm(*L, -30, -120 + d, tp, sk, bend=(-36, -132 + d)) +
                 arm(*R, 30, -120 + d, tp, sk, bend=(36, -132 + d)))
    elif arms == "phone":     # right hand raises a phone
        g.append(arm(*L, -31, -98 + d, tp, sk) + arm(*R, 12, -136 + d, tp, sk, bend=(34, -118 + d)))
    elif arms == "mug":
        g.append(arm(*L, -31, -98 + d, tp, sk) + arm(*R, 14, -124 + d, tp, sk, bend=(34, -112 + d)))
    elif arms == "hand_left":  # left hand low (holds a child's hand / balloon string)
        g.append(arm(*L, -40, -100 + d, tp, sk) + arm(*R, 31, -98 + d, tp, sk))
    elif arms == "hand_right":
        g.append(arm(*L, -31, -98 + d, tp, sk) + arm(*R, 40, -100 + d, tp, sk))
    elif arms == "wave":
        g.append(arm(*L, -31, -98 + d, tp, sk) + arm(*R, 36, -196 + d, tp, sk, bend=(42, -160 + d)))
    elif arms == "write":     # right hand forward-down onto a table
        g.append(arm(*L, -22, -112 + d, tp, sk, bend=(-36, -126 + d)) +
                 arm(*R, 20, -104 + d, tp, sk, bend=(36, -120 + d)))
    g.append(face)
    if headphones:
        cy = -178 + d
        g.append(f'<path d="M -17,{cy} Q -19,{cy-27} 0,{cy-27} Q 19,{cy-27} 17,{cy}" stroke="{C["ink"]}" stroke-width="3" fill="none"/>'
                 f'<rect x="-21" y="{cy-6}" width="7" height="13" rx="3" fill="{C["red"]}"/>'
                 f'<rect x="14" y="{cy-6}" width="7" height="13" rx="3" fill="{C["red"]}"/>')
    g.append(extra_front)
    tf = f"translate({x},{y}) scale({-s if flip else s},{s})"
    return f'<g transform="{tf}">{"".join(g)}</g>'


def newspaper(cx, cy, w=78, h=56, title="NACHRICHTEN", headline=True, rot=0):
    x, y = cx - w / 2, cy - h / 2
    g = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="2" fill="{C["white"]}" stroke="{C["lightgrey"]}" stroke-width="1.2"/>',
         f'<line x1="{cx}" y1="{y+2}" x2="{cx}" y2="{y+h-2}" stroke="{C["lightgrey"]}" stroke-width="1"/>',
         text(cx, y + 9, title, size=7.5, weight="bold", fill=C["ink"], style='letter-spacing="0.6"')]
    if headline:
        g.append(f'<rect x="{x+5}" y="{y+13}" width="{w/2-9}" height="5" fill="{C["red"]}"/>')
        g.append(f'<rect x="{cx+4}" y="{y+13}" width="{w/2-9}" height="12" fill="{C["sand"]}"/>')
    for i in range(5):
        yy = y + 23 + i * 5.6
        g.append(f'<line x1="{x+5}" y1="{yy}" x2="{cx-4}" y2="{yy}" stroke="{C["grey"]}" stroke-width="1.2"/>')
        if i > 1:
            g.append(f'<line x1="{cx+4}" y1="{yy}" x2="{x+w-5}" y2="{yy}" stroke="{C["grey"]}" stroke-width="1.2"/>')
    return f'<g transform="rotate({rot} {cx} {cy})">{"".join(g)}</g>'


def armchair(x, y, col, s=1.0):
    return (f'<g transform="translate({x},{y}) scale({s})">'
            f'<rect x="-52" y="-150" width="104" height="100" rx="18" fill="{col}"/>'
            f'<rect x="-64" y="-92" width="22" height="70" rx="10" fill="{col}"/>'
            f'<rect x="42" y="-92" width="22" height="70" rx="10" fill="{col}"/>'
            f'<rect x="-50" y="-60" width="100" height="36" rx="10" fill="{col}"/>'
            f'<rect x="-50" y="-26" width="8" height="24" fill="{C["wood2"]}"/>'
            f'<rect x="42" y="-26" width="8" height="24" fill="{C["wood2"]}"/></g>')


def lamp(x, y):
    return (f'<g transform="translate({x},{y})"><rect x="-2" y="-150" width="4" height="150" fill="{C["ink"]}"/>'
            f'<ellipse cx="0" cy="-2" rx="16" ry="4" fill="{C["ink"]}"/>'
            f'<path d="M -20,-150 L 20,-150 L 12,-178 L -12,-178 Z" fill="{C["mustard"]}"/></g>')


def plant(x, y, s=1.0):
    return (f'<g transform="translate({x},{y}) scale({s})">'
            f'<path d="M -14,0 L 14,0 L 11,-26 L -11,-26 Z" fill="{C["rust"]}"/>'
            f'<path d="M 0,-26 Q -22,-50 -26,-74 Q -4,-58 0,-26 Z" fill="{C["green"]}"/>'
            f'<path d="M 0,-26 Q 20,-56 16,-84 Q 4,-56 0,-26 Z" fill="{C["green"]}"/>'
            f'<path d="M 0,-26 Q -4,-60 4,-92 Q 10,-60 0,-26 Z" fill="#7fb06c"/></g>')


# --------------------------------------------------------------------------- scenes
def ferda_two_worlds():
    W, H = 900, 470
    ferda = dict(skin="medium", hair="black", hairstyle="bun", top="teal", bottom="navy",
                 shoes="ink", glasses=True, seated=True)
    panels = []
    for i, (px, title, ylab, reads) in enumerate([
            (20, "World 1: with news", "Y₁ = 4 · often", True),
            (460, "World 0: without news", "Y₀ = 2 · rarely", False)]):
        g = [f'<rect x="{px}" y="20" width="420" height="430" rx="18" fill="{C["paper2"]}"/>',
             text(px + 210, 62, title, size=28, weight="bold", fill=C["red"] if reads else C["slate"])]
        # room: window + floor
        g.append(f'<rect x="{px+22}" y="84" width="96" height="100" rx="6" fill="{C["sky"]}" opacity="0.55"/>'
                 f'<path d="M {px+70},84 L {px+70},184 M {px+22},134 L {px+118},134" stroke="{C["paper2"]}" stroke-width="5"/>'
                 f'<rect x="{px}" y="372" width="420" height="78" fill="{C["sand"]}" opacity="0.55"/>')
        g.append(lamp(px + 368, 372))
        g.append(armchair(px + 215, 384, C["rust"], s=1.3))
        if reads:
            extra = newspaper(0, -108 + 28, w=86, h=60, title="NACHRICHTEN")
            fig = person(px + 215, 380, 1.62, arms="hold", mood="concern", extra_front=extra, **ferda)
            g.append(fig)
        else:
            mug = (f'<rect x="7" y="-117" width="15" height="17" rx="3" fill="{C["white"]}" stroke="{C["lightgrey"]}"/>'
                   f'<path d="M 22,-113 Q 29,-109 22,-104" stroke="{C["lightgrey"]}" stroke-width="2" fill="none"/>'
                   f'<path d="M 11,-122 Q 9,-128 13,-133 M 17,-122 Q 15,-128 19,-133" stroke="{C["grey"]}" stroke-width="1.2" fill="none"/>')
            fig = person(px + 215, 380, 1.62, arms="mug", mood="smile", extra_front=mug, **ferda)
            g.append(fig)
            # the unread paper, folded on a side table
            g.append(f'<rect x="{px+40}" y="300" width="70" height="8" rx="3" fill="{C["wood"]}"/>'
                     f'<rect x="{px+70}" y="308" width="8" height="64" fill="{C["wood2"]}"/>'
                     f'<rect x="{px+46}" y="289" width="56" height="11" rx="2" fill="{C["white"]}" stroke="{C["lightgrey"]}"/>'
                     f'<line x1="{px+52}" y1="295" x2="{px+96}" y2="295" stroke="{C["grey"]}" stroke-width="1.2"/>')
        g.append(f'<rect x="{px+80}" y="396" width="260" height="44" rx="22" fill="{C["white"]}"/>'
                 + text(px + 210, 426, ylab, size=25, weight="bold", fill=C["red"] if reads else C["slate"]))
        panels.append("".join(g))
    body = "".join(panels)
    return svg(W, H, body, bg=False)


def dating_profile():
    """A swipe-style dating-app profile card on a phone (generic, no real app or logo)."""
    W, H = 460, 560
    g = [f'<rect x="0" y="0" width="{W}" height="{H}" rx="22" fill="{C["paper"]}"/>']
    # phone body + screen
    g.append(f'<rect x="95" y="18" width="270" height="524" rx="36" fill="{C["ink"]}"/>'
             f'<rect x="107" y="44" width="246" height="472" rx="22" fill="{C["white"]}"/>'
             f'<rect x="200" y="28" width="60" height="8" rx="4" fill="#44403c"/>')
    # app header
    g.append(text(230, 76, "swipe \u2665", size=22, weight="bold", fill=C["red"]))
    # profile card: photo area with a person, gradient-free flat backdrop
    g.append(f'<clipPath id="card"><rect x="121" y="92" width="218" height="300" rx="16"/></clipPath>')
    card = [f'<rect x="121" y="92" width="218" height="300" fill="{C["sky"]}"/>',
            f'<rect x="121" y="300" width="218" height="92" fill="{C["green"]}" opacity="0.55"/>',
            f'<circle cx="300" cy="130" r="18" fill="{C["mustard"]}" opacity="0.8"/>',
            person(230, 470, 1.55, skin="tan", hair="brown", hairstyle="curly", top="rust", bottom="navy", mood="smile", arms="down"),
            f'<rect x="121" y="318" width="218" height="74" fill="{C["ink"]}" opacity="0.55"/>',
            text(137, 346, "Jonas, 24", size=22, weight="bold", fill=C["white"], anchor="start"),
            text(137, 370, "2 km away \u00b7 Sociology student", size=13, fill=C["white"], anchor="start")]
    g.append(f'<g clip-path="url(#card)">{"".join(card)}</g>')
    # bio chips
    for x, w, t in [(123, 70, "hiking"), (199, 64, "coffee"), (269, 70, "concerts")]:
        g.append(f'<rect x="{x}" y="402" width="{w}" height="26" rx="13" fill="{C["paper2"]}"/>'
                 + text(x + w / 2, 420, t, size=13, fill=C["slate"]))
    # swipe buttons
    g.append(f'<circle cx="178" cy="470" r="28" fill="{C["white"]}" stroke="{C["lightgrey"]}" stroke-width="2"/>'
             f'<path d="M 167,459 L 189,481 M 189,459 L 167,481" stroke="{C["slate"]}" stroke-width="5" stroke-linecap="round"/>'
             f'<circle cx="282" cy="470" r="28" fill="{C["white"]}" stroke="{C["lightgrey"]}" stroke-width="2"/>'
             f'<path d="M 282,485 C 260,470 265,452 276,454 C 280,455 282,459 282,461 C 282,459 284,455 288,454 C 299,452 304,470 282,485 Z" fill="{C["red"]}"/>')
    return svg(W, H, "".join(g), bg=False)


if __name__ == "__main__":
    for name, fn in [("ferda_two_worlds", ferda_two_worlds), ("dating_profile", dating_profile)]:
        with open(os.path.join(HERE, name + ".svg"), "w", encoding="utf-8") as f:
            f.write(fn())
        print("wrote", name + ".svg")
