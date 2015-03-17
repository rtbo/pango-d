/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.renderer;

import pango.c.layout;
import pango.c.font;
import pango.c.types;
import pango.c.attributes;
import pango.c.glyph_item;
import pango.c.glyph;

import glib;
import gobject;

extern(C):

struct PangoRendererPrivate;

/**
 * PangoRenderPart:
 * @PANGO_RENDER_PART_FOREGROUND: the text itself
 * @PANGO_RENDER_PART_BACKGROUND: the area behind the text
 * @PANGO_RENDER_PART_UNDERLINE: underlines
 * @PANGO_RENDER_PART_STRIKETHROUGH: strikethrough lines
 *
 * #PangoRenderPart defines different items to render for such
 * purposes as setting colors.
 *
 * Since: 1.8
 **/
/* When extending, note N_RENDER_PARTS #define in pango-renderer.c */
enum PangoRenderPart
{
  PANGO_RENDER_PART_FOREGROUND,
  PANGO_RENDER_PART_BACKGROUND,
  PANGO_RENDER_PART_UNDERLINE,
  PANGO_RENDER_PART_STRIKETHROUGH
}

/**
 * PangoRenderer:
 * @matrix: the current transformation matrix for the Renderer; may
 *    be %NULL, which should be treated the same as the identity matrix.
 *
 * #PangoRenderer is a base class for objects that are used to
 * render Pango objects such as #PangoGlyphString and
 * #PangoLayout.
 *
 * Since: 1.8
 **/
struct PangoRenderer
{
  /*< private >*/
  GObject parent_instance;

  PangoUnderline underline;
  gboolean strikethrough;
  int active_count;

  /*< public >*/
  PangoMatrix *matrix;		/* May be NULL */

  /*< private >*/
  PangoRendererPrivate *priv;
}

/**
 * PangoRendererClass:
 * @draw_glyphs: draws a #PangoGlyphString
 * @draw_rectangle: draws a rectangle
 * @draw_error_underline: draws a squiggly line that approximately
 * covers the given rectangle in the style of an underline used to
 * indicate a spelling error.
 * @draw_shape: draw content for a glyph shaped with #PangoAttrShape.
 *   @x, @y are the coordinates of the left edge of the baseline,
 *   in user coordinates.
 * @draw_trapezoid: draws a trapezoidal filled area
 * @draw_glyph: draws a single glyph
 * @part_changed: do renderer specific processing when rendering
 *  attributes change
 * @begin: Do renderer-specific initialization before drawing
 * @end: Do renderer-specific cleanup after drawing
 * @prepare_run: updates the renderer for a new run
 * @draw_glyph_item: draws a #PangoGlyphItem
 *
 * Class structure for #PangoRenderer.
 *
 * Since: 1.8
 **/
struct PangoRendererClass
{
  /*< private >*/
  GObjectClass parent_class;

  /* vtable - not signals */
  /*< public >*/

  /* All of the following have default implementations
   * and take as coordinates user coordinates in Pango units
   */
  void function (PangoRenderer     *renderer,
		       PangoFont         *font,
		       PangoGlyphString  *glyphs,
		       int                x,
		       int                y) draw_glyphs;
  void function (PangoRenderer     *renderer,
			  PangoRenderPart    part,
			  int                x,
			  int                y,
			  int                width,
			  int                height) draw_rectangle;
  void function (PangoRenderer     *renderer,
				int                x,
				int                y,
				int                width,
				int                height) draw_error_underline;

  /* Nothing is drawn for shaped glyphs unless this is implemented */
  void function (PangoRenderer  *renderer,
		      PangoAttrShape *attr,
		      int             x,
		      int             y) draw_shape;

  /* These two must be implemented and take coordinates in
   * device space as doubles.
   */
  void function (PangoRenderer  *renderer,
			  PangoRenderPart part,
			  double          y1_,
			  double          x11,
			  double          x21,
			  double          y2,
			  double          x12,
			  double          x22) draw_trapezoid;
  void function (PangoRenderer *renderer,
		      PangoFont     *font,
		      PangoGlyph     glyph,
		      double         x,
		      double         y) draw_glyph;

  /* Notification of change in rendering attributes
   */
  void function (PangoRenderer   *renderer,
			PangoRenderPart  part) part_changed;

  /* Paired around drawing operations
   */
  void function (PangoRenderer *renderer) begin;
  void function   (PangoRenderer *renderer) end;

  /* Hooks into the details of layout rendering
   */
  void function (PangoRenderer  *renderer,
		       PangoLayoutRun *run) prepare_run;

  /* All of the following have default implementations
   * and take as coordinates user coordinates in Pango units
   */
  void function (PangoRenderer     *renderer,
			   const(char)        *text,
			   PangoGlyphItem    *glyph_item,
			   int                x,
			   int                y) draw_glyph_item;

  /*< private >*/

  /* Padding for future expansion */
  void function() _pango_reserved2;
  void function() _pango_reserved3;
  void function() _pango_reserved4;
}

pure GType pango_renderer_get_type    ();

void pango_renderer_draw_layout          (PangoRenderer    *renderer,
					  PangoLayout      *layout,
					  int               x,
					  int               y);
void pango_renderer_draw_layout_line     (PangoRenderer    *renderer,
					  PangoLayoutLine  *line,
					  int               x,
					  int               y);
void pango_renderer_draw_glyphs          (PangoRenderer    *renderer,
					  PangoFont        *font,
					  PangoGlyphString *glyphs,
					  int               x,
					  int               y);
void pango_renderer_draw_glyph_item      (PangoRenderer    *renderer,
					  const(char)       *text,
					  PangoGlyphItem   *glyph_item,
					  int               x,
					  int               y);
void pango_renderer_draw_rectangle       (PangoRenderer    *renderer,
					  PangoRenderPart   part,
					  int               x,
					  int               y,
					  int               width,
					  int               height);
void pango_renderer_draw_error_underline (PangoRenderer    *renderer,
					  int               x,
					  int               y,
					  int               width,
					  int               height);
void pango_renderer_draw_trapezoid       (PangoRenderer    *renderer,
					  PangoRenderPart   part,
					  double            y1_,
					  double            x11,
					  double            x21,
					  double            y2,
					  double            x12,
					  double            x22);
void pango_renderer_draw_glyph           (PangoRenderer    *renderer,
					  PangoFont        *font,
					  PangoGlyph        glyph,
					  double            x,
					  double            y);

void pango_renderer_activate             (PangoRenderer    *renderer);
void pango_renderer_deactivate           (PangoRenderer    *renderer);

void        pango_renderer_part_changed (PangoRenderer   *renderer,
					 PangoRenderPart  part);

void        pango_renderer_set_color (PangoRenderer    *renderer,
				      PangoRenderPart   part,
				      const(PangoColor) *color);
PangoColor *pango_renderer_get_color (PangoRenderer    *renderer,
				      PangoRenderPart   part);

void                        pango_renderer_set_matrix (PangoRenderer     *renderer,
						       const(PangoMatrix) *matrix);
const(PangoMatrix)          *pango_renderer_get_matrix (PangoRenderer     *renderer);

PangoLayout     *pango_renderer_get_layout      (PangoRenderer     *renderer);
PangoLayoutLine *pango_renderer_get_layout_line (PangoRenderer     *renderer);

