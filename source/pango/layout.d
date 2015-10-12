/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.layout;

import pango.utils;
import pango.bidi_type;
import pango.context;
import pango.attributes;
import pango.break_;
import pango.font;
import pango.types;
import pango.tabs;
import pango.glyph_item;
import pango.c.layout;
import pango.c.font;

import glib;
import gobject;

import std.string;

/**
 * PangoLayoutRun:
 *
 * The #PangoLayoutRun structure represents a single run within
 * a #PangoLayoutLine; it is simply an alternate name for
 * #PangoGlyphItem.
 * See the #PangoGlyphItem docs for details on the fields.
 */
alias LayoutRun = GlyphItem;

/**
 * PangoAlignment:
 * @PANGO_ALIGN_LEFT: Put all available space on the right
 * @PANGO_ALIGN_CENTER: Center the line within the available space
 * @PANGO_ALIGN_RIGHT: Put all available space on the left
 *
 * A #PangoAlignment describes how to align the lines of a #PangoLayout within the
 * available space. If the #PangoLayout is set to justify
 * using pango_layout_set_justify(), this only has effect for partial lines.
 */
enum Alignment {
  Left      = PangoAlignment.PANGO_ALIGN_LEFT,
  Center    = PangoAlignment.PANGO_ALIGN_CENTER,
  Right     = PangoAlignment.PANGO_ALIGN_RIGHT
}

/**
 * PangoWrapMode:
 * @PANGO_WRAP_WORD: wrap lines at word boundaries.
 * @PANGO_WRAP_CHAR: wrap lines at character boundaries.
 * @PANGO_WRAP_WORD_CHAR: wrap lines at word boundaries, but fall back to character boundaries if there is not
 * enough space for a full word.
 *
 * A #PangoWrapMode describes how to wrap the lines of a #PangoLayout to the desired width.
 */
enum WrapMode {
  Word      = PangoWrapMode.PANGO_WRAP_WORD,
  Char      = PangoWrapMode.PANGO_WRAP_CHAR,
  WordChar  = PangoWrapMode.PANGO_WRAP_WORD_CHAR
}

/**
 * PangoEllipsizeMode:
 * @PANGO_ELLIPSIZE_NONE: No ellipsization
 * @PANGO_ELLIPSIZE_START: Omit characters at the start of the text
 * @PANGO_ELLIPSIZE_MIDDLE: Omit characters in the middle of the text
 * @PANGO_ELLIPSIZE_END: Omit characters at the end of the text
 *
 * The #PangoEllipsizeMode type describes what sort of (if any)
 * ellipsization should be applied to a line of text. In
 * the ellipsization process characters are removed from the
 * text in order to make it fit to a given width and replaced
 * with an ellipsis.
 */
enum EllipsizeMode {
  None      = PangoEllipsizeMode.PANGO_ELLIPSIZE_NONE,
  Start     = PangoEllipsizeMode.PANGO_ELLIPSIZE_START,
  Middle    = PangoEllipsizeMode.PANGO_ELLIPSIZE_MIDDLE,
  End       = PangoEllipsizeMode.PANGO_ELLIPSIZE_END
}


/* The PangoLayout and PangoLayoutClass structs are private; if you
 * need to create a subclass of these, file a bug.
 */
class Layout : D_GObject
{
    mixin GObjectHolder!PangoLayout;

    package this(PangoLayout *ptr, Transfer transfer) {
        super(cast(GObject*)ptr, transfer);
    }

    this(Context context) {
        super(cast(GObject*)pango_layout_new(context.nativePtr), Transfer.Full);
    }

    Layout copy() {
        return getDObject!Layout(pango_layout_copy(nativePtr), Transfer.Full);
    }

    @property Context context() {
        return getDObject!Context(pango_layout_get_context(nativePtr), Transfer.None);
    }

    @property AttrList attributes() {
        return getDObject!AttrList(pango_layout_get_attributes(nativePtr), Transfer.None);
    }

    @property void attributes(AttrList attrs) {
        pango_layout_set_attributes(nativePtr, attrs.nativePtr);
    }

    @property void text(string text) {
        pango_layout_set_text(nativePtr, text.ptr, cast(int)text.length);
    }

    @property string text() {
        return fromStringz(pango_layout_get_text(nativePtr)).idup;
    }

    @property int characterCount() {
        return pango_layout_get_character_count(nativePtr);
    }

    void setMarkup(string markup) {
        pango_layout_set_markup(nativePtr, markup.ptr, cast(int)markup.length);
    }

    void setMarkupWithAccel(string markup, dchar accelMarker, out dchar accelChar) {
        pango_layout_set_markup_with_accel(nativePtr, markup.ptr, cast(int)markup.length, accelMarker, &accelChar);
    }

    @property void fontDescription (const(FontDescription) desc) {
        pango_layout_set_font_description(nativePtr, desc.nativePtr);
    }

    @property const(FontDescription) fontDescription() {
        return getDObject!FontDescription(cast(PangoFontDescription*)pango_layout_get_font_description(nativePtr), Transfer.None);
    }

    @property void width(int w) {
        pango_layout_set_width(nativePtr, w);
    }

    @property int width() {
        return pango_layout_get_width(nativePtr);
    }

    @property void height(int h) {
        pango_layout_set_height(nativePtr, h);
    }

    @property int height() {
        return pango_layout_get_height(nativePtr);
    }

    @property WrapMode wrap() {
        return cast(WrapMode)pango_layout_get_wrap(nativePtr);
    }

    @property void wrap(WrapMode mode) {
        return pango_layout_set_wrap(nativePtr, cast(PangoWrapMode)mode);
    }

    @property bool wrapped() {
        return cast(bool)pango_layout_is_wrapped(nativePtr);
    }

    @property void indent(int val) {
        pango_layout_set_indent(nativePtr, val);
    }

    @property int indent() {
        return pango_layout_get_indent(nativePtr);
    }

    @property void spacing(int val) {
        pango_layout_set_spacing(nativePtr, val);
    }

    @property int spacing() {
        return pango_layout_get_spacing(nativePtr);
    }

    @property void justify(bool val) {
        pango_layout_set_justify(nativePtr, cast(gboolean)val);
    }

    @property bool justify() {
        return cast(bool)pango_layout_get_justify(nativePtr);
    }

    @property void autoDir(bool val) {
        pango_layout_set_auto_dir(nativePtr, cast(gboolean)val);
    }

    @property bool autoDir() {
        return cast(bool)pango_layout_get_auto_dir(nativePtr);
    }

    @property void alignment(Alignment val) {
        pango_layout_set_alignment(nativePtr, cast(PangoAlignment)val);
    }

    @property Alignment alignment() {
        return cast(Alignment) pango_layout_get_alignment(nativePtr);
    }

    @property tabs(TabArray tabs) {
        pango_layout_set_tabs(nativePtr, tabs.nativePtr);
    }

    @property TabArray tabs() {
        return getDObject!TabArray(pango_layout_get_tabs(nativePtr), Transfer.Full);
    }

    @property void singleParagraphMode(bool val) {
        pango_layout_set_single_paragraph_mode(nativePtr, cast(gboolean)val);
    }

    @property bool singleParagraphMode() {
        return cast(bool)pango_layout_get_single_paragraph_mode(nativePtr);
    }


    @property void ellipsize(EllipsizeMode val) {
        pango_layout_set_ellipsize(nativePtr, cast(PangoEllipsizeMode)val);
    }

    @property EllipsizeMode ellipsize() {
        return cast(EllipsizeMode) pango_layout_get_ellipsize(nativePtr);
    }

    @property bool ellipsized() {
        return cast(bool) pango_layout_is_ellipsized(nativePtr);
    }

    @property int unknownGlyphsCount() {
        return pango_layout_get_unknown_glyphs_count(nativePtr);
    }

    void contextChanged() {
        pango_layout_context_changed(nativePtr);
    }

    @property uint serial() {
        return pango_layout_get_serial(nativePtr);
    }

    @property LogAttr[] logAttrs() {
        return listValues!(LogAttr, pango_layout_get_log_attrs)(nativePtr);
    }

    @property const(LogAttr)[] logAttrsReadOnly() {
        int n;
        const(LogAttr)* attrs = pango_layout_get_log_attrs_readonly(nativePtr, &n);
        return attrs[0 .. n];
    }

    Rectangle indexToPos(int index) {
        Rectangle pos;
        pango_layout_index_to_pos(nativePtr, index, &pos);
        return pos;
    }

    void indexToLineX(int index, bool trailing, out int line, out int xPos) {
        pango_layout_index_to_line_x(nativePtr, index, trailing, &line, &xPos);
    }

    void cursorPos(int index, out Rectangle strongPos, out Rectangle weakPos) {
        pango_layout_get_cursor_pos(nativePtr, index, &strongPos, &weakPos);
    }

    void moveCursorVisually(bool strong, int oldIndex, int oldTrailing, int direction,
                            out int newIndex, out int newTrailing) {
        pango_layout_move_cursor_visually(nativePtr, strong, oldIndex, oldTrailing,
                                          direction, &newIndex, &newTrailing);
    }

    bool xyToIndex(int x, int y, out int index, out int trailing) {
        return cast(bool)pango_layout_xy_to_index(nativePtr, x, y, &index, &trailing);
    }

    void extents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_get_extents(nativePtr, &inkRect, &logicalRect);
    }

    void pixelExtents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_get_pixel_extents(nativePtr, &inkRect, &logicalRect);
    }

    void size(out int width, out int height) {
        pango_layout_get_size(nativePtr, &width, &height);
    }

    void pixelSize(out int width, out int height) {
        pango_layout_get_pixel_size(nativePtr, &width, &height);
    }

    @property int baseline() {
        return pango_layout_get_baseline(nativePtr);
    }

    @property int lineCount() {
        return pango_layout_get_line_count(nativePtr);
    }

    LayoutLine line(int line) {
        return getDObject!LayoutLine(pango_layout_get_line(nativePtr, line), Transfer.None);
    }

    LayoutLine lineReadOnly(int line) {
        return getDObject!LayoutLine(pango_layout_get_line_readonly(nativePtr, line), Transfer.None);
    }


    LayoutLine[] lines() {
        GSList *list = pango_layout_get_lines(nativePtr);
        LayoutLine[] res;
        while (list) {
            res ~= getDObject!LayoutLine(cast(PangoLayoutLine*)list.data, Transfer.None);
            list = list.next;
        }
        return res;
    }

    LayoutLine[] linesReadOnly() {
        GSList *list = pango_layout_get_lines_readonly(nativePtr);
        LayoutLine[] res;
        while (list) {
            res ~= getDObject!LayoutLine(cast(PangoLayoutLine*)list.data, Transfer.None);
            list = list.next;
        }
        return res;
    }


    @property LayoutIter iter() {
        return getDObject!LayoutIter(pango_layout_get_iter(nativePtr), Transfer.Full);
    }
}



/**
* PangoLayoutLine:
* @start_index: start of line as byte index into layout->text
* @length: length of line in bytes
* @is_paragraph_start: #TRUE if this is the first line of the paragraph
* @resolved_dir: #Resolved PangoDirection of line
*
* The #PangoLayoutLine structure represents one of the lines resulting
* from laying out a paragraph via #PangoLayout. #PangoLayoutLine
* structures are obtained by calling pango_layout_get_line() and
* are only valid until the text, attributes, or settings of the
* parent #PangoLayout are modified.
*
* Routines for rendering PangoLayout objects are provided in
* code specific to each rendering system.
*/

struct LayoutLine
{
    mixin RefCountedGObj!(PangoLayoutLine, "pango_layout_line");

    package this(PangoLayoutLine *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    @property Layout layout() { return getDObject!Layout(nativePtr.layout, Transfer.None); }
    @property void layout(Layout l) { nativePtr.layout = l.nativePtr; }

    @property int startIndex() const { return nativePtr.start_index; }
    @property void startIndex(int val) { nativePtr.start_index = val; }

    @property int length() const { return nativePtr.length; }
    @property void length(int val) { nativePtr.length = val; }

    // GSList * runs;

    @property bool isParagraphStart() { return cast(bool)nativePtr.is_paragraph_start; }
    @property void isParagraphStart(bool val) { nativePtr.is_paragraph_start = cast(uint)val; }

    @property Direction resolvedDir() { return cast(Direction)nativePtr.resolved_dir; }
    @property void resolvedDir(Direction direction) { nativePtr.resolved_dir = cast(uint)direction; }


    bool xToIndex(int xPos, out int index, out int trailing) {
        return cast(bool)pango_layout_line_x_to_index(nativePtr, xPos, &index, &trailing);
    }

    int indexToX(int index, bool trailing) {
        int res;
        pango_layout_line_index_to_x(nativePtr, index, trailing, &res);
        return res;
    }

    int[2][] xRanges(int startIndex, int endIndex) {
        int *arr;
        int n;
        pango_layout_line_get_x_ranges(nativePtr, startIndex, endIndex, &arr, &n);
        if (!n) return [];
        scope(exit) g_free(arr);
        int[2][] res;
        foreach(i; 0..n) {
            res ~= [ arr[2*i], arr[2*i+1] ];
        }
        return res;
    }

    void extents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_line_get_extents(nativePtr, &inkRect, &logicalRect);
    }

    void pixelExtents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_line_get_pixel_extents(nativePtr, &inkRect, &logicalRect);
    }
}


class LayoutIter {
    mixin NativePtrHolder!(PangoLayoutIter, pango_layout_iter_free);

    this (PangoLayoutIter *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }


    @property int index() {
        return pango_layout_iter_get_index(nativePtr);
    }

    @property LayoutRun run() {
        return getDObject!LayoutRun(pango_layout_iter_get_run(nativePtr), Transfer.None);
    }

    @property LayoutRun runReadOnly() {
        return getDObject!LayoutRun(pango_layout_iter_get_run_readonly(nativePtr), Transfer.None);
    }

    @property LayoutLine line() {
        return getDObject!LayoutLine(pango_layout_iter_get_line(nativePtr), Transfer.None);
    }

    @property LayoutLine lineReadOnly() {
        return getDObject!LayoutLine(pango_layout_iter_get_line_readonly(nativePtr), Transfer.None);
    }

    @property bool atLastLine() {
        return cast(bool)pango_layout_iter_at_last_line(nativePtr);
    }

    @property Layout layout() {
        return getDObject!Layout(pango_layout_iter_get_layout(nativePtr), Transfer.None);
    }

    bool nextChar() {
        return cast(bool)pango_layout_iter_next_char(nativePtr);
    }

    bool nextCluster() {
        return cast(bool)pango_layout_iter_next_cluster(nativePtr);
    }

    bool nextRun() {
        return cast(bool)pango_layout_iter_next_run(nativePtr);
    }

    bool nextLine() {
        return cast(bool)pango_layout_iter_next_line(nativePtr);
    }

    void charExtents(out Rectangle logicalRect) {
        pango_layout_iter_get_char_extents(nativePtr, &logicalRect);
    }

    void clusterExtents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_iter_get_cluster_extents(nativePtr, &inkRect, &logicalRect);
    }

    void runExtents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_iter_get_run_extents(nativePtr, &inkRect, &logicalRect);
    }

    void lineExtents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_iter_get_line_extents(nativePtr, &inkRect, &logicalRect);
    }


    /* All the yranges meet, unlike the logical_rect's (i.e. the yranges
     * assign between-line spacing to the nearest line)
     */
    @property int[2] lineYRange() {
        int[2] res;
        pango_layout_iter_get_line_yrange(nativePtr, &res[0], &res[1]);
        return res;
    }

    void layoutExtents(out Rectangle inkRect, out Rectangle logicalRect) {
        pango_layout_iter_get_layout_extents(nativePtr, &inkRect, &logicalRect);
    }

    @property int baseline() {
        return pango_layout_iter_get_baseline(nativePtr);
    }

}
