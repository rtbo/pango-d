/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.glyph;

import pango.utils;
import pango.font;
import pango.types;
import pango.item;
import pango.c.glyph;

import glib;
import gobject;


/* 1024ths of a device unit */
/**
 * GlyphUnit:
 *
 * The #PangoGlyphUnit type is used to store dimensions within
 * Pango. Dimensions are stored in 1/%PANGO_SCALE of a device unit.
 * (A device unit might be a pixel for screen display, or
 * a point on a printer.) %PANGO_SCALE is currently 1024, and
 * may change in the future (unlikely though), but you should not
 * depend on its exact value. The PANGO_PIXELS() macro can be used
 * to convert from glyph units into device units with correct rounding.
 */
alias GlyphUnit = PangoGlyphUnit;

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
alias GlyphGeometry = PangoGlyphGeometry;


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
alias GlyphVisAttr = PangoGlyphVisAttr;

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
alias GlyphInfo = PangoGlyphInfo;

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

class GlyphString
{
    mixin NativePtrHolder!(PangoGlyphString, pango_glyph_string_free);

    package this(PangoGlyphString* ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    this() {
        initialize(pango_glyph_string_new(), Transfer.Full);
    }

    void extents(Font font, out Rectangle inkRect, out Rectangle logicalRect) {
        pango_glyph_string_extents(nativePtr, font.nativePtr, &inkRect, &logicalRect);
    }

    @property int width() {
        return pango_glyph_string_get_width(nativePtr);
    }

    void extentsRange(int start, int end, Font font, out Rectangle inkRect, out Rectangle logicalRect) {
        pango_glyph_string_extents_range(nativePtr, start, end, font.nativePtr, &inkRect, &logicalRect);
    }

    int[] logicalWidths(string text, int embeddingLevel) {
        if (text.length == 0) return [];
        int[] res = new int[g_utf8_strlen(text.ptr, text.length)];
        pango_glyph_string_get_logical_widths(nativePtr, cast(char*)text.ptr, cast(int)text.length, embeddingLevel, res.ptr);
        return res;
    }

    int indexToX(string text, Analysis *analysis, int index, bool trailing) {
        int res;
        // const cast of text after checking in C source code that no modification
        // is done on text (pointer is moved, dereferenced, but pointed-to data is not modified)
        pango_glyph_string_index_to_x(nativePtr, cast(char*)text.ptr, cast(int)text.length,
                                      &analysis.pangoStruct, index, trailing, &res);
        return res;
    }

    int xToIndex(string text, Analysis *analysis, int xPos, out bool trailing) {
        int ind;
        int trail;
        // const cast of text after checking in C source code that no modification
        // is done on text (pointer is moved, dereferenced, but pointed-to data is not modified)
        pango_glyph_string_x_to_index(nativePtr, cast(char*)text.ptr, cast(int)text.length,
                                      &analysis.pangoStruct, xPos, &ind, &trail);
        trailing = cast(bool)trail;
        return ind;
    }


    /* Turn a string of characters into a string of glyphs
    */
    static GlyphString shape(string text, const(Analysis)*analysis) {
        auto str = new GlyphString();
        pango_shape(text.ptr, cast(int)text.length, &analysis.pangoStruct, str.nativePtr);
        return str;
    }


    static GlyphString shapeFull(string text, string paragraph, const(Analysis)*analysis) {
        auto str = new GlyphString();
        pango_shape_full(text.ptr, cast(int)text.length,
            paragraph.ptr, cast(int)paragraph.length, &analysis.pangoStruct, str.nativePtr);
        return str;
    }

}


//GList *pango_reorder_items (GList *logical_items);

