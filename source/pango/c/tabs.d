/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.tabs;

import glib;
import gobject;

extern(C):

struct PangoTabArray;

/**
 * PangoTabAlign:
 * @PANGO_TAB_LEFT: the tab stop appears to the left of the text.
 *
 * A #PangoTabAlign specifies where a tab stop appears relative to the text.
 */
enum PangoTabAlign
{
  PANGO_TAB_LEFT

  /* These are not supported now, but may be in the
   * future.
   *
   *  PANGO_TAB_RIGHT,
   *  PANGO_TAB_CENTER,
   *  PANGO_TAB_NUMERIC
   */
}

/**
 * PANGO_TYPE_TAB_ARRAY:
 *
 * The #GObject type for #PangoTabArray.
 */

PangoTabArray *pango_tab_array_new (gint initial_size,
						     gboolean positions_in_pixels);
PangoTabArray *pango_tab_array_new_with_positions (gint size,
						     gboolean       positions_in_pixels,
						     PangoTabAlign  first_alignment,
						     gint           first_position,
						     ...);
pure GType           pango_tab_array_get_type            ();
PangoTabArray  *pango_tab_array_copy                (PangoTabArray *src);
void            pango_tab_array_free                (PangoTabArray *tab_array);
gint            pango_tab_array_get_size            (PangoTabArray *tab_array);
void            pango_tab_array_resize              (PangoTabArray *tab_array,
						     gint           new_size);
void            pango_tab_array_set_tab             (PangoTabArray *tab_array,
						     gint           tab_index,
						     PangoTabAlign  alignment,
						     gint           location);
void            pango_tab_array_get_tab             (PangoTabArray *tab_array,
						     gint           tab_index,
						     PangoTabAlign *alignment,
						     gint          *location);
void            pango_tab_array_get_tabs            (PangoTabArray *tab_array,
						     PangoTabAlign **alignments,
						     gint          **locations);

gboolean        pango_tab_array_get_positions_in_pixels (PangoTabArray *tab_array);

