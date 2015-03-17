/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.glyph_item;

import pango.c.attributes;
import pango.c.break_;
import pango.c.item;
import pango.c.glyph;

import glib;
import gobject;

extern (C):

/**
 * PangoGlyphItem:
 *
 * A #PangoGlyphItem is a pair of a #PangoItem and the glyphs
 * resulting from shaping the text corresponding to an item.
 * As an example of the usage of #PangoGlyphItem, the results
 * of shaping text with #PangoLayout is a list of #PangoLayoutLine,
 * each of which contains a list of #PangoGlyphItem.
 */
struct PangoGlyphItem
{
  PangoItem        *item;
  PangoGlyphString *glyphs;
}


pure GType pango_glyph_item_get_type ();

PangoGlyphItem *pango_glyph_item_split        (PangoGlyphItem *orig,
					       const(char)     *text,
					       int             split_index);
PangoGlyphItem *pango_glyph_item_copy         (PangoGlyphItem *orig);
void            pango_glyph_item_free         (PangoGlyphItem *glyph_item);
GSList *        pango_glyph_item_apply_attrs  (PangoGlyphItem *glyph_item,
					       const(char)     *text,
					       PangoAttrList  *list);
void            pango_glyph_item_letter_space (PangoGlyphItem *glyph_item,
					       const(char)     *text,
					       PangoLogAttr   *log_attrs,
					       int             letter_spacing);
void 	  pango_glyph_item_get_logical_widths (PangoGlyphItem *glyph_item,
					       const(char)     *text,
					       int            *logical_widths);


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
struct PangoGlyphItemIter
{
  PangoGlyphItem *glyph_item;
  const(gchar) *text;

  int start_glyph;
  int start_index;
  int start_char;

  int end_glyph;
  int end_index;
  int end_char;
}


pure GType               pango_glyph_item_iter_get_type ();
PangoGlyphItemIter *pango_glyph_item_iter_copy (PangoGlyphItemIter *orig);
void                pango_glyph_item_iter_free (PangoGlyphItemIter *iter);

gboolean pango_glyph_item_iter_init_start   (PangoGlyphItemIter *iter,
					     PangoGlyphItem     *glyph_item,
					     const(char)         *text);
gboolean pango_glyph_item_iter_init_end     (PangoGlyphItemIter *iter,
					     PangoGlyphItem     *glyph_item,
					     const(char)         *text);
gboolean pango_glyph_item_iter_next_cluster (PangoGlyphItemIter *iter);
gboolean pango_glyph_item_iter_prev_cluster (PangoGlyphItemIter *iter);

