/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.item;

import pango.utils;
import pango.font;
import pango.glyph;
import pango.language;
import pango.script;
import pango.gravity;
import pango.c.item;

import glib;
import gobject;

///**
// * PANGO_ANALYSIS_FLAG_CENTERED_BASELINE:
// *
// * Whether the segment should be shifted to center around the baseline.
// * Used in vertical writing directions mostly.
// *
// * Since: 1.16
// */
//enum PANGO_ANALYSIS_FLAG_CENTERED_BASELINE = (1 << 0);
enum AnalysisFlagCenteredBaseline = PANGO_ANALYSIS_FLAG_CENTERED_BASELINE;

///**
// * PANGO_ANALYSIS_FLAG_IS_ELLIPSIS:
// *
// * This flag is used to mark runs that hold ellipsized text,
// * in an ellipsized layout.
// *
// * Since: 1.36.7
// */
//enum PANGO_ANALYSIS_FLAG_IS_ELLIPSIS = (1 << 1);
enum AnalysisFlagIsEllipsis = PANGO_ANALYSIS_FLAG_IS_ELLIPSIS;

///**
// * PangoAnalysis:
// * @shape_engine: the engine for doing rendering-system-dependent processing.
// * @lang_engine: the engine for doing rendering-system-independent processing.
// * @font: the font for this segment.
// * @level: the bidirectional level for this segment.
// * @gravity: the glyph orientation for this segment (A #PangoGravity).
// * @flags: boolean flags for this segment (currently only one) (Since: 1.16).
// * @script: the detected script for this segment (A #PangoScript) (Since: 1.18).
// * @language: the detected language for this segment.
// * @extra_attrs: extra attributes for this segment.
// *
// * The #PangoAnalysis structure stores information about
// * the properties of a segment of text.
// */
struct Analysis
{
    PangoAnalysis pangoStruct;

    //PangoEngineShape *shape_engine;
    //PangoEngineLang  *lang_engine;

    @property Font font() { return cast(Font)getExistingDObject(pangoStruct.font, Transfer.None); }
    @property void font(Font f) { pangoStruct.font = f.nativePtr; }

    alias level = pangoStruct.level;

    @property Gravity gravity() { return cast(Gravity)pangoStruct.gravity; }
    @property void gravity (Gravity gravity) { pangoStruct.gravity = cast(guint8)gravity; }

    alias flags = pangoStruct.flags;

    @property Script script() { return cast(Script)pangoStruct.script; }
    @property void script (Script script) { pangoStruct.script = cast(guint8)script; }

    @property Language language() { return Language(pangoStruct.language); }
    @property void language(Language language) { pangoStruct.language = language.nativePtr; }

    //GSList *extra_attrs;
}



///**
// * PangoItem:
// *
// * The #PangoItem structure stores information about a segment of text.
// */
//struct PangoItem
//{
//  gint offset;
//  gint length;
//  gint num_chars;
//  PangoAnalysis analysis;
//}
class Item {
    mixin NativePtrHolder!(PangoItem, pango_item_free);

    package this(PangoItem *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    this() {
        initialize(pango_item_new(), Transfer.Full);
    }

    Item split(int splitIndex, int splitOffset) {
        return getDObject!Item(pango_item_split(nativePtr, splitIndex, splitOffset), Transfer.Full);
    }
}

