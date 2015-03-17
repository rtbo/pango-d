/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.glyph;

import pango.c.types;
import pango.c.item;
import pango.c.font;

import glib;
import gobject;

import std.bitmanip;

extern (C):

/* 1024ths of a device unit */
/**
 * PangoGlyphUnit:
 *
 * The #PangoGlyphUnit type is used to store dimensions within
 * Pango. Dimensions are stored in 1/%PANGO_SCALE of a device unit.
 * (A device unit might be a pixel for screen display, or
 * a point on a printer.) %PANGO_SCALE is currently 1024, and
 * may change in the future (unlikely though), but you should not
 * depend on its exact value. The PANGO_PIXELS() macro can be used
 * to convert from glyph units into device units with correct rounding.
 */
alias PangoGlyphUnit = gint32;

/* Positioning information about a glyph
 */
/**
 * PangoGlyphGeometry:
 * @width: the logical width to use for the the character.
 * @x_offset: horizontal offset from nominal character position.
 * @y_offset: vertical offset from nominal character position.
 *
 * The #PangoGlyphGeometry structure contains width and positioning
 * information for a single glyph.
 */
struct PangoGlyphGeometry
{
  PangoGlyphUnit width;
  PangoGlyphUnit x_offset;
  PangoGlyphUnit y_offset;
}

/* Visual attributes of a glyph
 */
/**
 * PangoGlyphVisAttr:
 * @is_cluster_start: set for the first logical glyph in each cluster. (Clusters
 * are stored in visual order, within the cluster, glyphs
 * are always ordered in logical order, since visual
 * order is meaningless; that is, in Arabic text, accent glyphs
 * follow the glyphs for the base character.)
 *
 * The PangoGlyphVisAttr is used to communicate information between
 * the shaping phase and the rendering phase.  More attributes may be
 * added in the future.
 */
struct PangoGlyphVisAttr
{
    mixin(bitfields!(
        guint, "is_cluster_start", 1,
        guint, "", 7));
}

/* A single glyph
 */
/**
 * PangoGlyphInfo:
 * @glyph: the glyph itself.
 * @geometry: the positional information about the glyph.
 * @attr: the visual attributes of the glyph.
 *
 * The #PangoGlyphInfo structure represents a single glyph together with
 * positioning information and visual attributes.
 * It contains the following fields.
 */
struct PangoGlyphInfo
{
  PangoGlyph    glyph;
  PangoGlyphGeometry geometry;
  PangoGlyphVisAttr  attr;
}

/* A string of glyphs with positional information and visual attributes -
 * ready for drawing
 */
/**
 * PangoGlyphString:
 *
 * The #PangoGlyphString structure is used to store strings
 * of glyphs with geometry and visual attribute information.
 * The storage for the glyph information is owned
 * by the structure which simplifies memory management.
 */
struct PangoGlyphString {
  gint num_glyphs;

  PangoGlyphInfo *glyphs;

  /* This is a memory inefficient way of representing the information
   * here - each value gives the byte index within the text
   * corresponding to the glyph string of the start of the cluster to
   * which the glyph belongs.
   */
  gint *log_clusters;

  /*< private >*/
  gint space;
}


PangoGlyphString *pango_glyph_string_new      ();
void              pango_glyph_string_set_size (PangoGlyphString *str,
					       gint              new_len);
pure GType             pango_glyph_string_get_type ();
PangoGlyphString *pango_glyph_string_copy     (PangoGlyphString *str);
void              pango_glyph_string_free     (PangoGlyphString *str);
void              pango_glyph_string_extents  (PangoGlyphString *glyphs,
					       PangoFont        *font,
					       PangoRectangle   *ink_rect,
					       PangoRectangle   *logical_rect);
int               pango_glyph_string_get_width(PangoGlyphString *glyphs);

void              pango_glyph_string_extents_range  (PangoGlyphString *glyphs,
						     int               start,
						     int               end,
						     PangoFont        *font,
						     PangoRectangle   *ink_rect,
						     PangoRectangle   *logical_rect);

void pango_glyph_string_get_logical_widths (PangoGlyphString *glyphs,
					    const(char)       *text,
					    int               length,
					    int               embedding_level,
					    int              *logical_widths);

void pango_glyph_string_index_to_x (PangoGlyphString *glyphs,
				    char             *text,
				    int               length,
				    PangoAnalysis    *analysis,
				    int               index_,
				    gboolean          trailing,
				    int              *x_pos);
void pango_glyph_string_x_to_index (PangoGlyphString *glyphs,
				    char             *text,
				    int               length,
				    PangoAnalysis    *analysis,
				    int               x_pos,
				    int              *index_,
				    int              *trailing);

/* Turn a string of characters into a string of glyphs
 */
void pango_shape (const(gchar)      *text,
		  gint              length,
		  const(PangoAnalysis) *analysis,
		  PangoGlyphString *glyphs);

void pango_shape_full (const(gchar)      *item_text,
		       gint              item_length,
		       const(gchar)      *paragraph_text,
		       gint              paragraph_length,
		       const(PangoAnalysis) *analysis,
		       PangoGlyphString *glyphs);

GList *pango_reorder_items (GList *logical_items);

