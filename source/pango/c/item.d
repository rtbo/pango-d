/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.item;

import pango.c.types;
import pango.c.font;
import pango.c.engine;

import glib;
import gobject;

extern (C):

/**
 * PANGO_ANALYSIS_FLAG_CENTERED_BASELINE:
 *
 * Whether the segment should be shifted to center around the baseline.
 * Used in vertical writing directions mostly.
 *
 * Since: 1.16
 */
enum PANGO_ANALYSIS_FLAG_CENTERED_BASELINE = (1 << 0);

/**
 * PANGO_ANALYSIS_FLAG_IS_ELLIPSIS:
 *
 * This flag is used to mark runs that hold ellipsized text,
 * in an ellipsized layout.
 *
 * Since: 1.36.7
 */
enum PANGO_ANALYSIS_FLAG_IS_ELLIPSIS = (1 << 1);

/**
 * PangoAnalysis:
 * @shape_engine: the engine for doing rendering-system-dependent processing.
 * @lang_engine: the engine for doing rendering-system-independent processing.
 * @font: the font for this segment.
 * @level: the bidirectional level for this segment.
 * @gravity: the glyph orientation for this segment (A #PangoGravity).
 * @flags: boolean flags for this segment (currently only one) (Since: 1.16).
 * @script: the detected script for this segment (A #PangoScript) (Since: 1.18).
 * @language: the detected language for this segment.
 * @extra_attrs: extra attributes for this segment.
 *
 * The #PangoAnalysis structure stores information about
 * the properties of a segment of text.
 */
struct PangoAnalysis
{
  PangoEngineShape *shape_engine;
  PangoEngineLang  *lang_engine;
  PangoFont *font;

  guint8 level;
  guint8 gravity; /* PangoGravity */
  guint8 flags;

  guint8 script; /* PangoScript */
  PangoLanguage *language;

  GSList *extra_attrs;
}

/**
 * PangoItem:
 *
 * The #PangoItem structure stores information about a segment of text.
 */
struct PangoItem
{
  gint offset;
  gint length;
  gint num_chars;
  PangoAnalysis analysis;
}


pure GType pango_item_get_type ();

PangoItem *pango_item_new   ();
PangoItem *pango_item_copy  (PangoItem  *item);
void       pango_item_free  (PangoItem  *item);
PangoItem *pango_item_split (PangoItem  *orig,
			     int         split_index,
			     int         split_offset);

