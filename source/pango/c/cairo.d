/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.cairo;

import pango.c.attributes;
import pango.c.bidi_type;
import pango.c.break_;
import pango.c.context;
import pango.c.coverage;
import pango.c.engine;
import pango.c.font;
import pango.c.fontmap;
import pango.c.fontset;
import pango.c.glyph_item;
import pango.c.glyph;
import pango.c.gravity;
import pango.c.item;
import pango.c.language;
import pango.c.layout;
import pango.c.matrix;
import pango.c.modules;
import pango.c.renderer;
import pango.c.script;
import pango.c.tabs;
import pango.c.types;
import pango.c.utils;
import pango.c.win32;

import glib;
import gobject;
import cairo.c.cairo;


extern (C):

/**
 * PangoCairoFont:
 *
 * #PangoCairoFont is an interface exported by fonts for
 * use with Cairo. The actual type of the font will depend
 * on the particular font technology Cairo was compiled to use.
 *
 * Since: 1.18
 **/
struct PangoCairoFont;

/**
 * PangoCairoFontMap:
 *
 * #PangoCairoFontMap is an interface exported by font maps for
 * use with Cairo. The actual type of the font map will depend
 * on the particular font technology Cairo was compiled to use.
 *
 * Since: 1.10
 **/
struct PangoCairoFontMap;

/**
 * PangoCairoShapeRendererFunc:
 * @cr: a Cairo context with current point set to where the shape should
 * be rendered
 * @attr: the %PANGO_ATTR_SHAPE to render
 * @do_path: whether only the shape path should be appended to current
 * path of @cr and no filling/stroking done.  This will be set
 * to %TRUE when called from pango_cairo_layout_path() and
 * pango_cairo_layout_line_path() rendering functions.
 * @data: user data passed to pango_cairo_context_set_shape_renderer()
 *
 * Function type for rendering attributes of type %PANGO_ATTR_SHAPE
 * with Pango's Cairo renderer.
 */
alias PangoCairoShapeRendererFunc = void function (cairo_t        *cr,
					      PangoAttrShape *attr,
					      gboolean        do_path,
					      gpointer        data);

/*
 * PangoCairoFontMap
 */
pure GType         pango_cairo_font_map_get_type          ();

PangoFontMap *pango_cairo_font_map_new               ();
PangoFontMap *pango_cairo_font_map_new_for_font_type (cairo_font_type_t fonttype);
PangoFontMap *pango_cairo_font_map_get_default       ();
void          pango_cairo_font_map_set_default       (PangoCairoFontMap *fontmap);
cairo_font_type_t pango_cairo_font_map_get_font_type (PangoCairoFontMap *fontmap);

void          pango_cairo_font_map_set_resolution (PangoCairoFontMap *fontmap,
						   double             dpi);
double        pango_cairo_font_map_get_resolution (PangoCairoFontMap *fontmap);

/*
 * PangoCairoFont
 */
pure GType         pango_cairo_font_get_type               ();

cairo_scaled_font_t *pango_cairo_font_get_scaled_font (PangoCairoFont *font);

/* Update a Pango context for the current state of a cairo context
 */
void         pango_cairo_update_context (cairo_t      *cr,
					 PangoContext *context);

void                        pango_cairo_context_set_font_options (PangoContext               *context,
								  const(cairo_font_options_t) *options);
const(cairo_font_options_t) *pango_cairo_context_get_font_options (PangoContext               *context);

void               pango_cairo_context_set_resolution     (PangoContext       *context,
							   double              dpi);
double             pango_cairo_context_get_resolution     (PangoContext       *context);

void                        pango_cairo_context_set_shape_renderer (PangoContext                *context,
								    PangoCairoShapeRendererFunc  func,
								    gpointer                     data,
								    GDestroyNotify               dnotify);
PangoCairoShapeRendererFunc pango_cairo_context_get_shape_renderer (PangoContext                *context,
								    gpointer                    *data);

/* Convenience
 */
PangoContext *pango_cairo_create_context (cairo_t   *cr);
PangoLayout *pango_cairo_create_layout (cairo_t     *cr);
void         pango_cairo_update_layout (cairo_t     *cr,
					PangoLayout *layout);

/*
 * Rendering
 */
void pango_cairo_show_glyph_string (cairo_t          *cr,
				    PangoFont        *font,
				    PangoGlyphString *glyphs);
void pango_cairo_show_glyph_item   (cairo_t          *cr,
				    const(char)       *text,
				    PangoGlyphItem   *glyph_item);
void pango_cairo_show_layout_line  (cairo_t          *cr,
				    PangoLayoutLine  *line);
void pango_cairo_show_layout       (cairo_t          *cr,
				    PangoLayout      *layout);

void pango_cairo_show_error_underline (cairo_t       *cr,
				       double         x,
				       double         y,
				       double         width,
				       double         height);

/*
 * Rendering to a path
 */
void pango_cairo_glyph_string_path (cairo_t          *cr,
				    PangoFont        *font,
				    PangoGlyphString *glyphs);
void pango_cairo_layout_line_path  (cairo_t          *cr,
				    PangoLayoutLine  *line);
void pango_cairo_layout_path       (cairo_t          *cr,
				    PangoLayout      *layout);

void pango_cairo_error_underline_path (cairo_t       *cr,
				       double         x,
				       double         y,
				       double         width,
				       double         height);

