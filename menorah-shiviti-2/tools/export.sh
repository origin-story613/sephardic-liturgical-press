#!/bin/sh
# Build the final Shiviti 2 files for printing or laser engraving into
# ../export/: a PDF and an SVG in which every letter is a plain filled shape
# (no live text, no clipping, no reused symbols), which CorelDRAW imports
# cleanly. No draft label. Needs lualatex, mutool and python3.
#   sh tools/export.sh [format]      format: poster (default), aceo, siddur, birkon
set -e
cd "$(dirname "$0")/.."
fmt=${1:-poster}
job=shiviti-2-$fmt
tmp=$(mktemp -d)
for i in 1 2; do
  lualatex -interaction=nonstopmode -halt-on-error -jobname="$job" \
    -output-directory="$tmp" "\\def\\menorahformat{$fmt}\\def\\menorahfinal{}\\input{main}" >/dev/null
done
mkdir -p export
cp "$tmp/$job.pdf" "export/$job.pdf"
mutool draw -q -F svg -O text=path -o "$tmp/$job.svg" "export/$job.pdf" 2>/dev/null
[ -f "$tmp/$job.svg" ] || mv "$tmp/${job}1.svg" "$tmp/$job.svg"
python3 -I tools/inline_svg_uses.py "$tmp/$job.svg" "export/$job.svg"
rm -rf "$tmp"
echo "wrote export/$job.pdf and export/$job.svg"
