/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.layout;

import pango.c.attributes;
import pango.c.context;
import pango.c.glyph_item;
import pango.c.tabs;
import pango.c.font;
import pango.c.types;
import pango.c.break_;

import glib;
import gobject;

import std.bitmanip;

extern (C):

struct PangoLayout;
struct PangoLayoutClass;

/**
 * PangoLayoutRun:
 *
 * The #PangoLayoutRun structure represents a single run within
 * a #PangoLayoutLine; it is simply an alternate name for
 * #PangoGlyphItem.
 * See the #PangoGlyphItem docs for details on the fields.
 */
alias PangoLayoutRun = PangoGlyphItem;

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
enum PangoAlignment {
  PANGO_ALIGN_LEFT,
  PANGO_ALIGN_CENTER,
  PANGO_ALIGN_RIGHT
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
enum PangoWrapMode {
  PANGO_WRAP_WORD,
  PANGO_WRAP_CHAR,
  PANGO_WRAP_WORD_CHAR
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
enum PangoEllipsizeMode {
  PANGO_ELLIPSIZE_NONE,
  PANGO_ELLIPSIZE_START,
  PANGO_ELLIPSIZE_MIDDLE,
  PANGO_ELLIPSIZE_END
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
struct PangoLayoutLine
{
  PangoLayout *layout;
  gint         start_index;     /* start of line as byte index into layout->text */
  gint         length;		/* length of line in bytes */
  GSList      *runs;
  mixin(bitfields!(
        guint, "is_paragraph_start", 1,  /* TRUE if this is the first line of the paragraph */
        guint, "resolved_dir", 3,  /* Resolved PangoDirection of line */
        guint, "", 4));
};


/* The PangoLayout and PangoLayoutClass structs are private; if you
 * need to create a subclass of these, file a bug.
 */

pure GType        pango_layout_get_type       ();
PangoLayout *pango_layout_new            (PangoContext   *context);
PangoLayout *pango_layout_copy           (PangoLayout    *src);

PangoContext  *pango_layout_get_context    (PangoLayout    *layout);

void           pango_layout_set_attributes (PangoLayout    *layout,
					    PangoAttrList  *attrs);
PangoAttrList *pango_layout_get_attributes (PangoLayout    *layout);

void           pango_layout_set_text       (PangoLayout    *layout,
					    const(char)     *text,
					    int             length);
const(char)    *pango_layout_get_text       (PangoLayout    *layout);

gint           pango_layout_get_character_count (PangoLayout *layout);

void           pango_layout_set_markup     (PangoLayout    *layout,
					    const(char)     *markup,
					    int             length);

void           pango_layout_set_markup_with_accel (PangoLayout    *layout,
						   const(char)     *markup,
						   int             length,
						   gunichar        accel_marker,
						   gunichar       *accel_char);

void           pango_layout_set_font_description (PangoLayout                *layout,
						  const(PangoFontDescription) *desc);

const(PangoFontDescription) *pango_layout_get_font_description (PangoLayout *layout);

void           pango_layout_set_width            (PangoLayout                *layout,
						  int                         width);
int            pango_layout_get_width            (PangoLayout                *layout);
void           pango_layout_set_height           (PangoLayout                *layout,
						  int                         height);
int            pango_layout_get_height           (PangoLayout                *layout);
void           pango_layout_set_wrap             (PangoLayout                *layout,
						  PangoWrapMode               wrap);
PangoWrapMode  pango_layout_get_wrap             (PangoLayout                *layout);
gboolean       pango_layout_is_wrapped           (PangoLayout                *layout);
void           pango_layout_set_indent           (PangoLayout                *layout,
						  int                         indent);
int            pango_layout_get_indent           (PangoLayout                *layout);
void           pango_layout_set_spacing          (PangoLayout                *layout,
						  int                         spacing);
int            pango_layout_get_spacing          (PangoLayout                *layout);
void           pango_layout_set_justify          (PangoLayout                *layout,
						  gboolean                    justify);
gboolean       pango_layout_get_justify          (PangoLayout                *layout);
void           pango_layout_set_auto_dir         (PangoLayout                *layout,
						  gboolean                    auto_dir);
gboolean       pango_layout_get_auto_dir         (PangoLayout                *layout);
void           pango_layout_set_alignment        (PangoLayout                *layout,
						  PangoAlignment              alignment);
PangoAlignment pango_layout_get_alignment        (PangoLayout                *layout);

void           pango_layout_set_tabs             (PangoLayout                *layout,
						  PangoTabArray              *tabs);

PangoTabArray* pango_layout_get_tabs             (PangoLayout                *layout);

void           pango_layout_set_single_paragraph_mode (PangoLayout                *layout,
						       gboolean                    setting);
gboolean       pango_layout_get_single_paragraph_mode (PangoLayout                *layout);

void               pango_layout_set_ellipsize (PangoLayout        *layout,
					       PangoEllipsizeMode  ellipsize);
PangoEllipsizeMode pango_layout_get_ellipsize (PangoLayout        *layout);
gboolean           pango_layout_is_ellipsized (PangoLayout        *layout);

int      pango_layout_get_unknown_glyphs_count (PangoLayout    *layout);

void     pango_layout_context_changed (PangoLayout    *layout);
guint    pango_layout_get_serial      (PangoLayout    *layout);

void     pango_layout_get_log_attrs (PangoLayout    *layout,
				     PangoLogAttr  **attrs,
				     gint           *n_attrs);

const(PangoLogAttr) *pango_layout_get_log_attrs_readonly (PangoLayout *layout,
							 gint        *n_attrs);

void     pango_layout_index_to_pos         (PangoLayout    *layout,
					    int             index_,
					    PangoRectangle *pos);
void     pango_layout_index_to_line_x      (PangoLayout    *layout,
					    int             index_,
					    gboolean        trailing,
					    int            *line,
					    int            *x_pos);
void     pango_layout_get_cursor_pos       (PangoLayout    *layout,
					    int             index_,
					    PangoRectangle *strong_pos,
					    PangoRectangle *weak_pos);
void     pango_layout_move_cursor_visually (PangoLayout    *layout,
					    gboolean        strong,
					    int             old_index,
					    int             old_trailing,
					    int             direction,
					    int            *new_index,
					    int            *new_trailing);
gboolean pango_layout_xy_to_index          (PangoLayout    *layout,
					    int             x,
					    int             y,
					    int            *index_,
					    int            *trailing);
void     pango_layout_get_extents          (PangoLayout    *layout,
					    PangoRectangle *ink_rect,
					    PangoRectangle *logical_rect);
void     pango_layout_get_pixel_extents    (PangoLayout    *layout,
					    PangoRectangle *ink_rect,
					    PangoRectangle *logical_rect);
void     pango_layout_get_size             (PangoLayout    *layout,
					    int            *width,
					    int            *height);
void     pango_layout_get_pixel_size       (PangoLayout    *layout,
					    int            *width,
					    int            *height);
int      pango_layout_get_baseline         (PangoLayout    *layout);

int              pango_layout_get_line_count       (PangoLayout    *layout);
PangoLayoutLine *pango_layout_get_line             (PangoLayout    *layout,
						    int             line);
PangoLayoutLine *pango_layout_get_line_readonly    (PangoLayout    *layout,
						    int             line);
GSList *         pango_layout_get_lines            (PangoLayout    *layout);
GSList *         pango_layout_get_lines_readonly   (PangoLayout    *layout);



pure GType    pango_layout_line_get_type     ();

PangoLayoutLine *pango_layout_line_ref   (PangoLayoutLine *line);
void             pango_layout_line_unref (PangoLayoutLine *line);

gboolean pango_layout_line_x_to_index   (PangoLayoutLine  *line,
					 int               x_pos,
					 int              *index_,
					 int              *trailing);
void     pango_layout_line_index_to_x   (PangoLayoutLine  *line,
					 int               index_,
					 gboolean          trailing,
					 int              *x_pos);
void     pango_layout_line_get_x_ranges (PangoLayoutLine  *line,
					 int               start_index,
					 int               end_index,
					 int             **ranges,
					 int              *n_ranges);
void     pango_layout_line_get_extents  (PangoLayoutLine  *line,
					 PangoRectangle   *ink_rect,
					 PangoRectangle   *logical_rect);
void     pango_layout_line_get_pixel_extents (PangoLayoutLine *layout_line,
					      PangoRectangle  *ink_rect,
					      PangoRectangle  *logical_rect);

struct PangoLayoutIter;


pure GType            pango_layout_iter_get_type ();

PangoLayoutIter *pango_layout_get_iter  (PangoLayout     *layout);
PangoLayoutIter *pango_layout_iter_copy (PangoLayoutIter *iter);
void             pango_layout_iter_free (PangoLayoutIter *iter);

int              pango_layout_iter_get_index  (PangoLayoutIter *iter);
PangoLayoutRun  *pango_layout_iter_get_run    (PangoLayoutIter *iter);
PangoLayoutRun  *pango_layout_iter_get_run_readonly   (PangoLayoutIter *iter);
PangoLayoutLine *pango_layout_iter_get_line   (PangoLayoutIter *iter);
PangoLayoutLine *pango_layout_iter_get_line_readonly  (PangoLayoutIter *iter);
gboolean         pango_layout_iter_at_last_line (PangoLayoutIter *iter);
PangoLayout     *pango_layout_iter_get_layout (PangoLayoutIter *iter);

gboolean pango_layout_iter_next_char    (PangoLayoutIter *iter);
gboolean pango_layout_iter_next_cluster (PangoLayoutIter *iter);
gboolean pango_layout_iter_next_run     (PangoLayoutIter *iter);
gboolean pango_layout_iter_next_line    (PangoLayoutIter *iter);

void pango_layout_iter_get_char_extents    (PangoLayoutIter *iter,
					    PangoRectangle  *logical_rect);
void pango_layout_iter_get_cluster_extents (PangoLayoutIter *iter,
					    PangoRectangle  *ink_rect,
					    PangoRectangle  *logical_rect);
void pango_layout_iter_get_run_extents     (PangoLayoutIter *iter,
					    PangoRectangle  *ink_rect,
					    PangoRectangle  *logical_rect);
void pango_layout_iter_get_line_extents    (PangoLayoutIter *iter,
					    PangoRectangle  *ink_rect,
					    PangoRectangle  *logical_rect);
/* All the yranges meet, unlike the logical_rect's (i.e. the yranges
 * assign between-line spacing to the nearest line)
 */
void pango_layout_iter_get_line_yrange     (PangoLayoutIter *iter,
					    int             *y0_,
					    int             *y1_);
void pango_layout_iter_get_layout_extents  (PangoLayoutIter *iter,
					    PangoRectangle  *ink_rect,
					    PangoRectangle  *logical_rect);
int  pango_layout_iter_get_baseline        (PangoLayoutIter *iter);

