"""Draws the app icon and the native launch image from the logo
(assets/svg/logo.svg: gold calligraphy on a navy disc) and writes every
size iOS and Android need.

    python3 tool/make_icons.py      (needs ImageMagick: `magick`)
"""
import os
import re
import subprocess
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NAVY = '#181A35'

with open(os.path.join(ROOT, 'assets/svg/logo.svg')) as f:
    _LOGO = f.read()
# The logo's artwork without its disc (the icon's square is navy anyway).
_ART = re.sub(r'<circle[^>]*/>', '', _LOGO.split('>', 1)[1].rsplit('</svg>', 1)[0])


def icon_svg(scale):
    """The calligraphy on a navy square; [scale] shrinks it (Android's
    adaptive icon keeps it inside the safe zone)."""
    offset = 1280 - 1280 * scale
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2560 2560" width="1024" height="1024">
  <rect width="2560" height="2560" fill="{NAVY}"/>
  <g transform="translate({offset} {offset}) scale({scale})">{_ART}</g>
</svg>'''


def launch_svg():
    """The logo on the navy launch background."""
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2560 2560" width="1024" height="1024">
  <rect width="2560" height="2560" fill="{NAVY}"/>
  {_ART}
</svg>'''


def render(svg, out, size, opaque=False):
    """Renders with Quick Look (WebKit; ImageMagick's own SVG renderer drops
    these strokes), then resizes with ImageMagick."""
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        path = f'{tmp}/art.svg'
        with open(path, 'w') as f:
            f.write(svg)
        subprocess.run(['qlmanage', '-t', '-s', '1024', '-o', tmp, path],
                       check=True, capture_output=True)
        args = ['magick', f'{path}.png', '-resize', f'{size}x{size}']
        if opaque:  # App Store icons must not have an alpha channel.
            args += ['-alpha', 'off']
        subprocess.run(args + [out], check=True)


def main():
    ios = f'{ROOT}/ios/Runner/Assets.xcassets/AppIcon.appiconset'
    full = icon_svg(0.96)
    for name in os.listdir(ios):
        if not name.endswith('.png'):
            continue
        # Icon-App-83.5x83.5@2x.png → 83.5 × 2
        dims, scale = name[len('Icon-App-'):-len('.png')].split('@')
        size = round(float(dims.split('x')[0]) * int(scale[0]))
        render(full, f'{ios}/{name}', size, opaque=True)

    res = f'{ROOT}/android/app/src/main/res'
    densities = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
    for d, k in densities.items():
        render(full, f'{res}/mipmap-{d}/ic_launcher.png', round(48 * k), opaque=True)
        # Adaptive icon foreground: 108dp canvas, mark inside the 66dp zone.
        render(icon_svg(0.72),
               f'{res}/mipmap-{d}/ic_launcher_foreground.png', round(108 * k))
        render(launch_svg(), f'{res}/drawable-{d}/launch_logo.png', round(200 * k))

    launch = f'{ROOT}/ios/Runner/Assets.xcassets/LaunchImage.imageset'
    for suffix, k in (('', 1), ('@2x', 2), ('@3x', 3)):
        render(launch_svg(), f'{launch}/LaunchImage{suffix}.png', 200 * k)
    print('icons written')


if __name__ == '__main__':
    main()
