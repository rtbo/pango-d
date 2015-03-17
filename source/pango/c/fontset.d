/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.fontset;

import pango.c.coverage;
import pango.c.types;
import pango.c.font;

import glib;
import gobject;

extern (C):

/*
 * PangoFontset
 */

version (Backend) {}
else {
    struct PangoFontset;
}

pure GType pango_fontset_get_type ();

/**
 * PangoFontsetForeachFunc:
 * @fontset: a #PangoFontset
 * @font: a font from @fontset
 * @user_data: callback data
 *
 * A callback function used by pango_fontset_foreach() when enumerating
 * the fonts in a fontset.
 *
 * Returns: if %TRUE, stop iteration and return immediately.
 *
 * Since: 1.4
 **/
alias PangoFontsetForeachFunc = gboolean function (PangoFontset  *fontset,
					     PangoFont     *font,
					     gpointer       user_data);

PangoFont *       pango_fontset_get_font    (PangoFontset           *fontset,
					     guint                   wc);
PangoFontMetrics *pango_fontset_get_metrics (PangoFontset           *fontset);
void              pango_fontset_foreach     (PangoFontset           *fontset,
					     PangoFontsetForeachFunc func,
					     gpointer                data);


version (Backend)
{
    /**
     * PangoFontset:
     *
     * A #PangoFontset represents a set of #PangoFont to use
     * when rendering text. It is the result of resolving a
     * #PangoFontDescription against a particular #PangoContext.
     * It has operations for finding the component font for
     * a particular Unicode character, and for finding a composite
     * set of metrics for the entire fontset.
     */
    struct PangoFontset
    {
      GObject parent_instance;
    };

    /**
     * PangoFontsetClass:
     * @parent_class: parent #GObjectClass.
     * @get_font: a function to get the font in the fontset that contains the
     * best glyph for the given Unicode character; see pango_fontset_get_font().
     * @get_metrics: a function to get overall metric information for the fonts
     * in the fontset; see pango_fontset_get_metrics().
     * @get_language: a function to get the language of the fontset.
     * @foreach: a function to loop over the fonts in the fontset. See
     * pango_fontset_foreach().
     *
     * The #PangoFontsetClass structure holds the virtual functions for
     * a particular #PangoFontset implementation.
     */
    struct PangoFontsetClass
    {
      GObjectClass parent_class;

      /*< public >*/

      PangoFont *       function     (PangoFontset     *fontset,
				         guint             wc) get_font;

      PangoFontMetrics *function  (PangoFontset     *fontset) get_metrics;
      PangoLanguage *   function (PangoFontset     *fontset) get_language;
      void              function      (PangoFontset           *fontset,
				         PangoFontsetForeachFunc func,
				         gpointer                data) foreach_;

      /*< private >*/

      /* Padding for future expansion */
      void function () _pango_reserved1;
      void function () _pango_reserved2;
      void function () _pango_reserved3;
      void function () _pango_reserved4;
    };

    /*
     * PangoFontsetSimple
     */

    struct PangoFontsetSimple;
    struct PangoFontsetSimpleClass;

    pure GType pango_fontset_simple_get_type ();

    PangoFontsetSimple * pango_fontset_simple_new    (PangoLanguage      *language);
    void                 pango_fontset_simple_append (PangoFontsetSimple *fontset,
						      PangoFont          *font);
    int                  pango_fontset_simple_size   (PangoFontsetSimple *fontset);

}
