/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.glyph_item;

import pango.utils;
import pango.attributes;
import pango.item;
import pango.glyph;
import pango.break_;
import pango.c.glyph_item;

import glib;
import gobject;

import std.string;


/**
 * PangoGlyphItem:
 *
 * A #PangoGlyphItem is a pair of a #PangoItem and the glyphs
 * resulting from shaping the text corresponding to an item.
 * As an example of the usage of #PangoGlyphItem, the results
 * of shaping text with #PangoLayout is a list of #PangoLayoutLine,
 * each of which contains a list of #PangoGlyphItem.
 */

class GlyphItem
{
    mixin NativePtrHolder!(PangoGlyphItem, pango_glyph_item_free);
    bool owned_ = true;

    package this(PangoGlyphItem *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    //PangoGlyphItem *pango_glyph_item_copy         (PangoGlyphItem *orig);

    @property Item item() {
        return getDObject!Item(nativePtr.item, Transfer.None);
    }

    @property GlyphString glyphs() {
        return getDObject!GlyphString(nativePtr.glyphs, Transfer.None);
    }

    GlyphItem split(string text, int splitIndex) {
        return getDObject!GlyphItem(pango_glyph_item_split(nativePtr, toStringz(text), splitIndex), Transfer.Full);
    }

    GlyphItem[] applyAttrs(string text, AttrList attrs)
    {
        GSList *list = pango_glyph_item_apply_attrs(nativePtr, toStringz(text), attrs.nativePtr);
        if (!list) return [];
        scope(exit) g_slist_free(list); // not free_full as we transfer ownership to GlyphItem objects

        GlyphItem[] res;
        while (list) {
            res ~= getDObject!GlyphItem(cast(PangoGlyphItem*)list.data, Transfer.Full);
            list = list.next;
        }
        return res;
    }


    void letterSpace(string text, LogAttr[] logAttrs, int letterSpacing)
    {
        pango_glyph_item_letter_space(nativePtr, text.ptr, logAttrs.ptr, letterSpacing);
    }


    int[] logicalWidths(string text) {
        if (!nativePtr || !nativePtr.item) return [];
        assert(text.length >= nativePtr.item.offset);
        int[] res = new int[nativePtr.item.num_chars];
        pango_glyph_item_get_logical_widths(nativePtr, toStringz(text), res.ptr);
        return res;
    }
}



/**
 * PangoGlyphItemIter:
 *
 * A #PangoGlyphItemIter is an iterator over the clusters in a
 * #PangoGlyphItem.  The <firstterm>forward direction</firstterm> of the
 * iterator is the logical direction of text.  That is, with increasing
 * @start_index and @start_char values.  If @glyph_item is right-to-left
 * (that is, if <literal>@glyph_item->item->analysis.level</literal> is odd),
 * then @start_glyph decreases as the iterator moves forward.  Moreover,
 * in right-to-left cases, @start_glyph is greater than @end_glyph.
 *
 * An iterator should be initialized using either of
 * pango_glyph_item_iter_init_start() and
 * pango_glyph_item_iter_init_end(), for forward and backward iteration
 * respectively, and walked over using any desired mixture of
 * pango_glyph_item_iter_next_cluster() and
 * pango_glyph_item_iter_prev_cluster().  A common idiom for doing a
 * forward iteration over the clusters is:
 * <programlisting>
 * PangoGlyphItemIter cluster_iter;
 * gboolean have_cluster;
 *
 * for (have_cluster = pango_glyph_item_iter_init_start (&amp;cluster_iter,
 *                                                       glyph_item, text);
 *      have_cluster;
 *      have_cluster = pango_glyph_item_iter_next_cluster (&amp;cluster_iter))
 * {
 *   ...
 * }
 * </programlisting>
 *
 * Note that @text is the start of the text for layout, which is then
 * indexed by <literal>@glyph_item->item->offset</literal> to get to the
 * text of @glyph_item.  The @start_index and @end_index values can directly
 * index into @text.  The @start_glyph, @end_glyph, @start_char, and @end_char
 * values however are zero-based for the @glyph_item.  For each cluster, the
 * item pointed at by the start variables is included in the cluster while
 * the one pointed at by end variables is not.
 *
 * None of the members of a #PangoGlyphItemIter should be modified manually.
 *
 * Since: 1.22
 */
struct GlyphItemIter
{
    PangoGlyphItemIter pangoStruct;

    @property string text() { return fromStringz(pangoStruct.text).idup; }
    @property void text(string text) { pangoStruct.text = toStringz(text); }

    alias startGlyph = pangoStruct.start_glyph;
    alias startIndex = pangoStruct.start_index;
    alias startChar = pangoStruct.start_char;

    alias endGlyph = pangoStruct.end_glyph;
    alias endIndex = pangoStruct.end_index;
    alias endChar = pangoStruct.end_char;


    bool initStart(GlyphItem item, string text) {
        return cast(bool)pango_glyph_item_iter_init_start(&pangoStruct, item.nativePtr, toStringz(text));
    }

    bool initEnd(GlyphItem item, string text) {
        return cast(bool)pango_glyph_item_iter_init_end(&pangoStruct, item.nativePtr, toStringz(text));
    }

    bool nextCluster() {
        return cast(bool)pango_glyph_item_iter_next_cluster(&pangoStruct);
    }

    bool prevCluster() {
        return cast(bool)pango_glyph_item_iter_prev_cluster(&pangoStruct);
    }
}

