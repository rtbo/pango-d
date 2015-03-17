/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.bidi_type;

import glib;

extern (C):


/**
 * PangoBidiType:
 * @PANGO_BIDI_TYPE_L: Left-to-Right
 * @PANGO_BIDI_TYPE_LRE: Left-to-Right Embedding
 * @PANGO_BIDI_TYPE_LRO: Left-to-Right Override
 * @PANGO_BIDI_TYPE_R: Right-to-Left
 * @PANGO_BIDI_TYPE_AL: Right-to-Left Arabic
 * @PANGO_BIDI_TYPE_RLE: Right-to-Left Embedding
 * @PANGO_BIDI_TYPE_RLO: Right-to-Left Override
 * @PANGO_BIDI_TYPE_PDF: Pop Directional Format
 * @PANGO_BIDI_TYPE_EN: European Number
 * @PANGO_BIDI_TYPE_ES: European Number Separator
 * @PANGO_BIDI_TYPE_ET: European Number Terminator
 * @PANGO_BIDI_TYPE_AN: Arabic Number
 * @PANGO_BIDI_TYPE_CS: Common Number Separator
 * @PANGO_BIDI_TYPE_NSM: Nonspacing Mark
 * @PANGO_BIDI_TYPE_BN: Boundary Neutral
 * @PANGO_BIDI_TYPE_B: Paragraph Separator
 * @PANGO_BIDI_TYPE_S: Segment Separator
 * @PANGO_BIDI_TYPE_WS: Whitespace
 * @PANGO_BIDI_TYPE_ON: Other Neutrals
 *
 * The #PangoBidiType type represents the bidirectional character
 * type of a Unicode character as specified by the
 * <ulink url="http://www.unicode.org/reports/tr9/">Unicode bidirectional algorithm</ulink>.
 *
 * Since: 1.22
 **/
enum PangoBidiType {
  /* Strong types */
  PANGO_BIDI_TYPE_L,
  PANGO_BIDI_TYPE_LRE,
  PANGO_BIDI_TYPE_LRO,
  PANGO_BIDI_TYPE_R,
  PANGO_BIDI_TYPE_AL,
  PANGO_BIDI_TYPE_RLE,
  PANGO_BIDI_TYPE_RLO,

  /* Weak types */
  PANGO_BIDI_TYPE_PDF,
  PANGO_BIDI_TYPE_EN,
  PANGO_BIDI_TYPE_ES,
  PANGO_BIDI_TYPE_ET,
  PANGO_BIDI_TYPE_AN,
  PANGO_BIDI_TYPE_CS,
  PANGO_BIDI_TYPE_NSM,
  PANGO_BIDI_TYPE_BN,

  /* Neutral types */
  PANGO_BIDI_TYPE_B,
  PANGO_BIDI_TYPE_S,
  PANGO_BIDI_TYPE_WS,
  PANGO_BIDI_TYPE_ON
}

pure PangoBidiType pango_bidi_type_for_unichar (gunichar ch);

/**
 * PangoDirection:
 * @PANGO_DIRECTION_LTR: A strong left-to-right direction
 * @PANGO_DIRECTION_RTL: A strong right-to-left direction
 * @PANGO_DIRECTION_TTB_LTR: Deprecated value; treated the
 *   same as %PANGO_DIRECTION_RTL.
 * @PANGO_DIRECTION_TTB_RTL: Deprecated value; treated the
 *   same as %PANGO_DIRECTION_LTR
 * @PANGO_DIRECTION_WEAK_LTR: A weak left-to-right direction
 * @PANGO_DIRECTION_WEAK_RTL: A weak right-to-left direction
 * @PANGO_DIRECTION_NEUTRAL: No direction specified
 *
 * The #PangoDirection type represents a direction in the
 * Unicode bidirectional algorithm; not every value in this
 * enumeration makes sense for every usage of #PangoDirection;
 * for example, the return value of pango_unichar_direction()
 * and pango_find_base_dir() cannot be %PANGO_DIRECTION_WEAK_LTR
 * or %PANGO_DIRECTION_WEAK_RTL, since every character is either
 * neutral or has a strong direction; on the other hand
 * %PANGO_DIRECTION_NEUTRAL doesn't make sense to pass
 * to pango_itemize_with_base_dir().
 *
 * The %PANGO_DIRECTION_TTB_LTR, %PANGO_DIRECTION_TTB_RTL
 * values come from an earlier interpretation of this
 * enumeration as the writing direction of a block of
 * text and are no longer used; See #PangoGravity for how
 * vertical text is handled in Pango.
 **/
enum PangoDirection {
  PANGO_DIRECTION_LTR,
  PANGO_DIRECTION_RTL,
  PANGO_DIRECTION_TTB_LTR,
  PANGO_DIRECTION_TTB_RTL,
  PANGO_DIRECTION_WEAK_LTR,
  PANGO_DIRECTION_WEAK_RTL,
  PANGO_DIRECTION_NEUTRAL
}

pure PangoDirection pango_unichar_direction      (gunichar     ch);
PangoDirection pango_find_base_dir          (const(gchar) *text,
					     gint         length);

deprecated("use g_unichar_get_mirror_char")
gboolean       pango_get_mirror_char        (gunichar     ch,
					     gunichar    *mirrored_ch);

