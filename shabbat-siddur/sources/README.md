# Shabbat Siddur: sources and decisions

One record per section file. This page holds what applies to all of them.

## Yosef's scope decisions (October 2026)

- **Nusach authority:** Yosef's Turkish siddur (the one the birkon and Seder
  HaShulchan were checked against). *Siddur Zechut Yosef* is not the authority.
- **Base text:** Torat Emet (public domain), corrected against the siddur.
- **Chazzan's repetition:** Kedushah and the responses only.
- **Torah service at Mincha:** the service only, no reading text.
- **Korbanot:** the full block (Pitum HaKetoret, Eizehu Mekoman, Rabbi Yishmael).
- **Kaddish:** every Kaddish in full, with the congregational responses.
- **Special days:** a rubric for when Tzidkatcha is omitted. VaTodi'enu and
  Havdalah in Kiddush are not included.
- **After Havdalah:** VeYiten Lecha only, no songs.
- **Havdalah:** shared with Seder HaShulchan (`shared/texts/havdalah.tex`).
- **Me'ein Shalosh:** included at the end (`shared/texts/after-blessings.tex`),
  so Havdalah's page reference works.
- **Title:** תְּפִלּוֹת מִנְחָה וְעַרְבִית לְמוֹצָאֵי שַׁבָּת; nusach line "According to the
  custom of the Turkish Sephardic community of Seattle"; imprint as the birkon.
- **Responses** (אָמֵן etc.): slightly smaller bold, no brackets.
- **Page numbers:** small, centered at the foot (no preference from Yosef;
  needed for cross-references).
- **End of Motzei Shabbat Arvit:** Aleinu, Barechu, Kaddish (as outlined).
- Points where the outline and Torat Emet differ: **match the siddur**. They
  are listed under "Open" in each record.

## Conventions applied (all sections)

- The Name is set with `\Shem{}` (standard pointing). After the prefixes
  שֶׁ and דְ the yod keeps its sheva, so the prefix letter is written before a
  plain `\Shem{}`. Torat Emet also spells the Name in some Amidah closings as a
  letter string with added vavs; those are converted too.
- The source's Hebrew instructions become our own English rubrics. Pause marks
  (יפסיק מעט), stress notes (מלרע) and the paseq stroke (|) are dropped.
- Congregational responses use `\response{}` (defined in `main.tex`).
- **Not yet compared with Yosef's siddur**, and not yet proofread for small
  source typos (missing vowels, as in ולֹא and לעַמּוֹ). Both are done from the
  photos.
