/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.gravity;

import pango.matrix;
import pango.script;
import pango.c.gravity;
import pango.c.script;



/**
* Gravity:
* South: Glyphs stand upright (default)
* East: Glyphs are rotated 90 degrees clockwise
* North: Glyphs are upside-down
* West: Glyphs are rotated 90 degrees counter-clockwise
* Auto: Gravity is resolved from the context matrix
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
enum Gravity {
    South   = PangoGravity.PANGO_GRAVITY_SOUTH,
    East    = PangoGravity.PANGO_GRAVITY_EAST,
    North   = PangoGravity.PANGO_GRAVITY_NORTH,
    West    = PangoGravity.PANGO_GRAVITY_WEST,
    Auto    = PangoGravity.PANGO_GRAVITY_AUTO
}

/**
* GravityHint:
* Natural: scripts will take their natural gravity based
* on the base gravity and the script.  This is the default.
* Strong: always use the base gravity set, regardless of
* the script.
* Line: for scripts not in their natural direction (eg.
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
enum GravityHint {
    Natural = PangoGravityHint.PANGO_GRAVITY_HINT_NATURAL,
    Strong  = PangoGravityHint.PANGO_GRAVITY_HINT_STRONG,
    Line    = PangoGravityHint.PANGO_GRAVITY_HINT_LINE
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
@property bool vertical(Gravity gravity) {
    return gravity == Gravity.East || gravity == Gravity.West;
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
@property bool improper(Gravity gravity) {
    return gravity == Gravity.West || gravity == Gravity.North;
}


pure @property double rotation(Gravity gravity) {
    return pango_gravity_to_rotation(cast(PangoGravity)gravity);
}

pure Gravity gravityForMatrix(const(Matrix) matrix) {
    return cast(Gravity)pango_gravity_get_for_matrix(matrix.nativePtr);
}

pure Gravity gravityForScript(Script script, Gravity baseGravity, GravityHint hint) {
    return cast(Gravity)pango_gravity_get_for_script(cast(PangoScript) script,
                                                     cast(PangoGravity) baseGravity,
                                                     cast(PangoGravityHint)hint);
}

pure Gravity gravityForScriptAndWidth(Script script, bool wide,
                                      Gravity baseGravity, GravityHint hint) {
    return cast(Gravity)
        pango_gravity_get_for_script_and_width(cast(PangoScript) script, wide,
                                               cast(PangoGravity) baseGravity,
                                               cast(PangoGravityHint)hint);
}

