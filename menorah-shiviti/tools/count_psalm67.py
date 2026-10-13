#!/usr/bin/env python3
"""Word and letter counts for Psalm 67 in the Sefaria export editions.

Usage: python3 count_psalm67.py
Fetches each edition's JSON from the public Sefaria export bucket and prints,
per verse: words split on spaces, words also split on maqaf, and letters
(alef to tav, final forms included; points and marks excluded).
"""
import json
import re
import urllib.parse
import urllib.request

BASE = ('https://storage.googleapis.com/sefaria-export/json/'
        'Tanakh/Writings/Psalms/Hebrew/')
EDITIONS = [
    "Tanach with Ta'amei Hamikra",
    'Tanach with Nikkud',
    'Miqra according to the Masorah',
]
LETTER = re.compile('[א-ת]')


def clean(verse):
    verse = re.sub(r'<[^>]+>', '', verse)      # MAM markup (implicit maqaf, paseq)
    verse = re.sub(r'\{[^}]*\}', '', verse)    # petucha / setuma markers
    verse = re.sub(r'&[a-z]+;', ' ', verse)    # &thinsp; &nbsp;
    return verse


def words(verse, maqaf):
    sep = r'[\s־]+' if maqaf else r'\s+'
    return [w for w in re.split(sep, verse) if LETTER.search(w)]


for title in EDITIONS:
    url = BASE + urllib.parse.quote(title) + '.json'
    data = json.load(urllib.request.urlopen(url))
    print(f"== {data['versionTitle']} | license: {data.get('license')}")
    total = 0
    for n, verse in enumerate(data['text'][66], 1):
        v = clean(verse)
        w = len(words(v, maqaf=True))
        if n > 1:
            total += w
        print(f'  v{n}: {len(words(v, maqaf=False)):2} words, {w:2} with maqaf split, '
              f'{len(LETTER.findall(v)):2} letters')
    print(f'  verses 2-8, maqaf split: {total} words')
