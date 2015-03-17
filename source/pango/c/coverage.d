/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.coverage;

import glib;

extern (C):

/**
 * PangoCoverage:
 *
 * The #PangoCoverage structure represents a map from Unicode characters
 * to #PangoCoverageLevel. It is an opaque structure with no public fields.
 */
struct PangoCoverage;

/**
 * PangoCoverageLevel:
 * @PANGO_COVERAGE_NONE: The character is not representable with the font.
 * @PANGO_COVERAGE_FALLBACK: The character is represented in a way that may be
 * comprehensible but is not the correct graphical form.
 * For instance, a Hangul character represented as a
 * a sequence of Jamos, or a Latin transliteration of a Cyrillic word.
 * @PANGO_COVERAGE_APPROXIMATE: The character is represented as basically the correct
 * graphical form, but with a stylistic variant inappropriate for
 * the current script.
 * @PANGO_COVERAGE_EXACT: The character is represented as the correct graphical form.
 *
 * Used to indicate how well a font can represent a particular Unicode
 * character point for a particular script.
 */
enum PangoCoverageLevel {
  PANGO_COVERAGE_NONE,
  PANGO_COVERAGE_FALLBACK,
  PANGO_COVERAGE_APPROXIMATE,
  PANGO_COVERAGE_EXACT
}

PangoCoverage *    pango_coverage_new     ();
PangoCoverage *    pango_coverage_ref     (PangoCoverage      *coverage);
void               pango_coverage_unref   (PangoCoverage      *coverage);
PangoCoverage *    pango_coverage_copy    (PangoCoverage      *coverage);
PangoCoverageLevel pango_coverage_get     (PangoCoverage      *coverage,
					   int                 index_);
void               pango_coverage_set     (PangoCoverage      *coverage,
					   int                 index_,
					   PangoCoverageLevel  level);
void               pango_coverage_max     (PangoCoverage      *coverage,
					   PangoCoverage      *other);

void           pango_coverage_to_bytes   (PangoCoverage  *coverage,
					  guchar        **bytes,
					  int            *n_bytes);
PangoCoverage *pango_coverage_from_bytes (guchar         *bytes,
					  int             n_bytes);

