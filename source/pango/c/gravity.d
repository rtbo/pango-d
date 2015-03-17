/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.gravity;

import pango.c.script;
import pango.c.matrix;

import glib;


/**
 * PangoGravity:
 * @PANGO_GRAVITY_SOUTH: Glyphs stand upright (default)
 * @PANGO_GRAVITY_EAST: Glyphs are rotated 90 degrees clockwise
 * @PANGO_GRAVITY_NORTH: Glyphs are upside-down
 * @PANGO_GRAVITY_WEST: Glyphs are rotated 90 degrees counter-clockwise
 * @PANGO_GRAVITY_AUTO: Gravity is resolved from the context matrix
 *
 * The #PangoGravity type represents the orientation of glyphs in a segment
 * of text.  This is useful when rendering vertical text layouts.  In
 * those situations, the layout is rotated using a non-identity PangoMatrix,
 * and then glyph orientation is controlled using #PangoGravity.
 * Not every value in this enumeration makes sense for every usage of
 * #PangoGravity; for example, %PANGO_GRAVITY_AUTO only can be passed to
 * pango_context_set_base_gravity() and can only be returned by
 * pango_context_get_base_gravity().
 *
 * See also: #PangoGravityHint
 *
 * Since: 1.16
 **/
enum PangoGravity {
  PANGO_GRAVITY_SOUTH,
  PANGO_GRAVITY_EAST,
  PANGO_GRAVITY_NORTH,
  PANGO_GRAVITY_WEST,
  PANGO_GRAVITY_AUTO
}

/**
 * PangoGravityHint:
 * @PANGO_GRAVITY_HINT_NATURAL: scripts will take their natural gravity based
 * on the base gravity and the script.  This is the default.
 * @PANGO_GRAVITY_HINT_STRONG: always use the base gravity set, regardless of
 * the script.
 * @PANGO_GRAVITY_HINT_LINE: for scripts not in their natural direction (eg.
 * Latin in East gravity), choose per-script gravity such that every script
 * respects the line progression.  This means, Latin and Arabic will take
 * opposite gravities and both flow top-to-bottom for example.
 *
 * The #PangoGravityHint defines how horizontal scripts should behave in a
 * vertical context.  That is, English excerpt in a vertical paragraph for
 * example.
 *
 * See #PangoGravity.
 *
 * Since: 1.16
 **/
enum PangoGravityHint {
  PANGO_GRAVITY_HINT_NATURAL,
  PANGO_GRAVITY_HINT_STRONG,
  PANGO_GRAVITY_HINT_LINE
}

/**
 * PANGO_GRAVITY_IS_VERTICAL:
 * @gravity: the #PangoGravity to check
 *
 * Whether a #PangoGravity represents vertical writing directions.
 *
 * Returns: %TRUE if @gravity is %PANGO_GRAVITY_EAST or %PANGO_GRAVITY_WEST,
 *          %FALSE otherwise.
 *
 * Since: 1.16
 **/
auto PANGO_GRAVITY_IS_VERTICAL(G)(G gravity) {
    return gravity == PANGO_GRAVITY_EAST || gravity == PANGO_GRAVITY_WEST;
}

/**
 * PANGO_GRAVITY_IS_IMPROPER:
 * @gravity: the #PangoGravity to check
 *
 * Whether a #PangoGravity represents a gravity that results in reversal of text direction.
 *
 * Returns: %TRUE if @gravity is %PANGO_GRAVITY_WEST or %PANGO_GRAVITY_NORTH,
 *          %FALSE otherwise.
 *
 * Since: 1.32
 **/
auto PANGO_GRAVITY_IS_IMPROPER(G)(G gravity) {
	return (gravity) == PANGO_GRAVITY_WEST || (gravity) == PANGO_GRAVITY_NORTH;
}


pure double       pango_gravity_to_rotation    (PangoGravity       gravity);

pure PangoGravity pango_gravity_get_for_matrix (const(PangoMatrix) *matrix);

pure PangoGravity pango_gravity_get_for_script (PangoScript        script,
					   PangoGravity       base_gravity,
					   PangoGravityHint   hint);

pure PangoGravity pango_gravity_get_for_script_and_width
					  (PangoScript        script,
					   gboolean           wide,
					   PangoGravity       base_gravity,
					   PangoGravityHint   hint);

