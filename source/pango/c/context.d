/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.context;

import pango.c.font;
import pango.c.fontmap;
import pango.c.attributes;
import pango.c.matrix;
import pango.c.types;
import pango.c.fontset;

import glib;
import gobject;

extern(C):


/* Sort of like a GC - application set information about how
 * to handle scripts
 */

struct PangoContext;
struct PangoContextClass;
/* The PangoContext and PangoContextClass structs are private; if you
 * need to create a subclass of these, file a bug.
 */

pure GType         pango_context_get_type      ();

PangoContext *pango_context_new           ();
void          pango_context_changed       (PangoContext                 *context);
void          pango_context_set_font_map  (PangoContext                 *context,
					   PangoFontMap                 *font_map);
PangoFontMap *pango_context_get_font_map  (PangoContext                 *context);
guint         pango_context_get_serial    (PangoContext                 *context);
void          pango_context_list_families (PangoContext                 *context,
					   PangoFontFamily            ***families,
					   int                          *n_families);
PangoFont *   pango_context_load_font     (PangoContext                 *context,
					   const(PangoFontDescription)   *desc);
PangoFontset *pango_context_load_fontset  (PangoContext                 *context,
					   const(PangoFontDescription)   *desc,
					   PangoLanguage                *language);

PangoFontMetrics *pango_context_get_metrics   (PangoContext                 *context,
					       const(PangoFontDescription)   *desc,
					       PangoLanguage                *language);

void                      pango_context_set_font_description (PangoContext               *context,
							      const(PangoFontDescription) *desc);
PangoFontDescription *    pango_context_get_font_description (PangoContext               *context);
PangoLanguage            *pango_context_get_language         (PangoContext               *context);
void                      pango_context_set_language         (PangoContext               *context,
							      PangoLanguage              *language);
void                      pango_context_set_base_dir         (PangoContext               *context,
							      PangoDirection              direction);
PangoDirection            pango_context_get_base_dir         (PangoContext               *context);
void                      pango_context_set_base_gravity     (PangoContext               *context,
							      PangoGravity                gravity);
PangoGravity              pango_context_get_base_gravity     (PangoContext               *context);
PangoGravity              pango_context_get_gravity          (PangoContext               *context);
void                      pango_context_set_gravity_hint     (PangoContext               *context,
							      PangoGravityHint            hint);
PangoGravityHint          pango_context_get_gravity_hint     (PangoContext               *context);

void                      pango_context_set_matrix           (PangoContext      *context,
						              const(PangoMatrix) *matrix);
const(PangoMatrix) *       pango_context_get_matrix           (PangoContext      *context);

/* Break a string of Unicode characters into segments with
 * consistent shaping/language engine and bidrectional level.
 * Returns a #GList of #PangoItem's
 */
GList *pango_itemize                (PangoContext      *context,
				     const(char)        *text,
				     int                start_index,
				     int                length,
				     PangoAttrList     *attrs,
				     PangoAttrIterator *cached_iter);

GList *pango_itemize_with_base_dir  (PangoContext      *context,
				     PangoDirection     base_dir,
				     const(char)        *text,
				     int                start_index,
				     int                length,
				     PangoAttrList     *attrs,
				     PangoAttrIterator *cached_iter);

