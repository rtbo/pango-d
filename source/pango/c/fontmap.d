/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.fontmap;

import pango.c.font;
import pango.c.fontmap;
import pango.c.context;
import pango.c.fontset;
import pango.c.language;

import glib;
import gobject;

extern(C):

version (Backend) {}
else {
    struct PangoFontMap;
}

pure GType         pango_font_map_get_type       ();
PangoContext * pango_font_map_create_context (PangoFontMap               *fontmap);
PangoFont *   pango_font_map_load_font     (PangoFontMap                 *fontmap,
					    PangoContext                 *context,
					    const(PangoFontDescription)   *desc);
PangoFontset *pango_font_map_load_fontset  (PangoFontMap                 *fontmap,
					    PangoContext                 *context,
					    const(PangoFontDescription)   *desc,
					    PangoLanguage                *language);
void          pango_font_map_list_families (PangoFontMap                 *fontmap,
					    PangoFontFamily            ***families,
					    int                          *n_families);
guint         pango_font_map_get_serial    (PangoFontMap                 *fontmap);
void          pango_font_map_changed       (PangoFontMap                 *fontmap);



version (Backend) {

    /**
     * PangoFontMap:
     *
     * The #PangoFontMap represents the set of fonts available for a
     * particular rendering system. This is a virtual object with
     * implementations being specific to particular rendering systems.  To
     * create an implementation of a #PangoFontMap, the rendering-system
     * specific code should allocate a larger structure that contains a nested
     * #PangoFontMap, fill in the <structfield>klass</structfield> member of the nested #PangoFontMap with a
     * pointer to a appropriate #PangoFontMapClass, then call
     * pango_font_map_init() on the structure.
     *
     * The #PangoFontMap structure contains one member which the implementation
     * fills in.
     */
    struct PangoFontMap
    {
      GObject parent_instance;
    }

    /**
     * PangoFontMapClass:
     * @parent_class: parent #GObjectClass.
     * @load_font: a function to load a font with a given description. See
     * pango_font_map_load_font().
     * @list_families: A function to list available font families. See
     * pango_font_map_list_families().
     * @load_fontset: a function to load a fontset with a given given description
     * suitable for a particular language. See pango_font_map_load_fontset().
     * @shape_engine_type: the type of rendering-system-dependent engines that
     * can handle fonts of this fonts loaded with this fontmap.
     * @get_serial: a function to get the serial number of the fontmap.
     * See pango_font_map_get_serial().
     * @changed: See pango_font_map_changed()
     *
     * The #PangoFontMapClass structure holds the virtual functions for
     * a particular #PangoFontMap implementation.
     */
    struct PangoFontMapClass
    {
      GObjectClass parent_class;

      /*< public >*/

      PangoFont *   function     (PangoFontMap               *fontmap,
				      PangoContext               *context,
				      const(PangoFontDescription) *desc) load_font;
      void          function (PangoFontMap               *fontmap,
				      PangoFontFamily          ***families,
				      int                        *n_families) list_families;
      PangoFontset *function  (PangoFontMap               *fontmap,
				      PangoContext               *context,
				      const(PangoFontDescription) *desc,
				      PangoLanguage              *language) load_fontset;

      const(char)     *shape_engine_type;

      guint         function    (PangoFontMap               *fontmap) get_serial;
      void          function       (PangoFontMap               *fontmap) changed;

      /*< private >*/

      /* Padding for future expansion */
      void function () _pango_reserved1;
      void function () _pango_reserved2;
    }

    const(char)   *pango_font_map_get_shape_engine_type (PangoFontMap *fontmap);

}

