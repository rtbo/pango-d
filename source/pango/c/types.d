/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.types;

public import pango.c.gravity;
public import pango.c.language;
public import pango.c.matrix;
public import pango.c.script;
public import pango.c.bidi_type;

import glib;
import gobject;



/* A index of a glyph into a font. Rendering system dependent */
/**
 * PangoGlyph:
 *
 * A #PangoGlyph represents a single glyph in the output form of a string.
 */
alias PangoGlyph = guint32;



/**
 * PANGO_SCALE:
 *
 * The %PANGO_SCALE macro represents the scale between dimensions used
 * for Pango distances and device units. (The definition of device
 * units is dependent on the output device; it will typically be pixels
 * for a screen, and points for a printer.) %PANGO_SCALE is currently
 * 1024, but this may be changed in the future.
 *
 * When setting font sizes, device units are always considered to be
 * points (as in "12 point font"), rather than pixels.
 */
/**
 * PANGO_PIXELS:
 * @d: a dimension in Pango units.
 *
 * Converts a dimension to device units by rounding.
 *
 * Return value: rounded dimension in device units.
 */
/**
 * PANGO_PIXELS_FLOOR:
 * @d: a dimension in Pango units.
 *
 * Converts a dimension to device units by flooring.
 *
 * Return value: floored dimension in device units.
 * Since: 1.14
 */
/**
 * PANGO_PIXELS_CEIL:
 * @d: a dimension in Pango units.
 *
 * Converts a dimension to device units by ceiling.
 *
 * Return value: ceiled dimension in device units.
 * Since: 1.14
 */
enum PANGO_SCALE = 1024;
auto PANGO_PIXELS(D)(D d) { return ((cast(int)d)+512) >> 10; }
auto PANGO_PIXELS_FLOOR(D)(D d) { return (cast(int)d) >> 10; }
auto PANGO_PIXELS_CEIL(D)(D d) { return ((cast(int)d) + 1023) >> 10; }



/* The above expressions are just slightly wrong for floating point d;
 * For example we'd expect PANGO_PIXELS(-512.5) => -1 but instead we get 0.
 * That's unlikely to matter for practical use and the expression is much
 * more compact and faster than alternatives that work exactly for both
 * integers and floating point.
 *
 * PANGO_PIXELS also behaves differently for +512 and -512.
 */

/**
 * PANGO_UNITS_ROUND:
 * @d: a dimension in Pango units.
 *
 * Rounds a dimension to whole device units, but does not
 * convert it to device units.
 *
 * Return value: rounded dimension in Pango units.
 * Since: 1.18
 */
auto PANGO_UNITS_ROUND(D)(D d) { (d + (PANGO_SCALE >> 1)) & ~(PANGO_SCALE - 1); }


extern (C)
pure int    pango_units_from_double (double d);

extern (C)
pure double pango_units_to_double (int i);


/**
 * PangoRectangle:
 * @x: X coordinate of the left side of the rectangle.
 * @y: Y coordinate of the the top side of the rectangle.
 * @width: width of the rectangle.
 * @height: height of the rectangle.
 *
 * The #PangoRectangle structure represents a rectangle. It is frequently
 * used to represent the logical or ink extents of a single glyph or section
 * of text. (See, for instance, pango_font_get_glyph_extents())
 *
 */
struct PangoRectangle
{
  int x;
  int y;
  int width;
  int height;
}

/* Macros to translate from extents rectangles to ascent/descent/lbearing/rbearing
 */
/**
 * PANGO_ASCENT:
 * @rect: a #PangoRectangle
 *
 * Extracts the <firstterm>ascent</firstterm> from a #PangoRectangle
 * representing glyph extents. The ascent is the distance from the
 * baseline to the highest point of the character. This is positive if the
 * glyph ascends above the baseline.
 */
/**
 * PANGO_DESCENT:
 * @rect: a #PangoRectangle
 *
 * Extracts the <firstterm>descent</firstterm> from a #PangoRectangle
 * representing glyph extents. The descent is the distance from the
 * baseline to the lowest point of the character. This is positive if the
 * glyph descends below the baseline.
 */
/**
 * PANGO_LBEARING:
 * @rect: a #PangoRectangle
 *
 * Extracts the <firstterm>left bearing</firstterm> from a #PangoRectangle
 * representing glyph extents. The left bearing is the distance from the
 * horizontal origin to the farthest left point of the character.
 * This is positive for characters drawn completely to the right of the
 * glyph origin.
 */
/**
 * PANGO_RBEARING:
 * @rect: a #PangoRectangle
 *
 * Extracts the <firstterm>right bearing</firstterm> from a #PangoRectangle
 * representing glyph extents. The right bearing is the distance from the
 * horizontal origin to the farthest right point of the character.
 * This is positive except for characters drawn completely to the left of the
 * horizontal origin.
 */
auto PANGO_ASCENT(R)(R rect) { return -rect.y; }
auto PANGO_DESCENT(R)(R rect) { return rect.y + rect.height; }
auto PANGO_LBEARING(R)(R rect) { return rect.x; }
auto PANGO_RBEARING(R)(R rect) { return rect.x + rect.width; }

extern (C)
void pango_extents_to_pixels (PangoRectangle *inclusive,
			      PangoRectangle *nearest);


