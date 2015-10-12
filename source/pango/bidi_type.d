module pango.bidi_type;

import pango.utils;
import pango.c.bidi_type;

import glib;

/**
 * PangoBidiType:
 * L: Left-to-Right
 * LRE: Left-to-Right Embedding
 * LRO: Left-to-Right Override
 * R: Right-to-Left
 * AL: Right-to-Left Arabic
 * RLE: Right-to-Left Embedding
 * RLO: Right-to-Left Override
 * PDF: Pop Directional Format
 * EN: European Number
 * ES: European Number Separator
 * ET: European Number Terminator
 * AN: Arabic Number
 * CS: Common Number Separator
 * NSM: Nonspacing Mark
 * BN: Boundary Neutral
 * B: Paragraph Separator
 * S: Segment Separator
 * WS: Whitespace
 * ON: Other Neutrals
 *
 * The #PangoBidiType type represents the bidirectional character
 * type of a Unicode character as specified by the
 * <ulink url="http://www.unicode.org/reports/tr9/">Unicode bidirectional algorithm</ulink>.
 *
 * Since: 1.22
 **/
enum BidiType {
  /* Strong types */
  L     = PangoBidiType.PANGO_BIDI_TYPE_L,
  LRE   = PangoBidiType.PANGO_BIDI_TYPE_LRE,
  LRO   = PangoBidiType.PANGO_BIDI_TYPE_LRO,
  R     = PangoBidiType.PANGO_BIDI_TYPE_R,
  AL    = PangoBidiType.PANGO_BIDI_TYPE_AL,
  RLE   = PangoBidiType.PANGO_BIDI_TYPE_RLE,
  RLO   = PangoBidiType.PANGO_BIDI_TYPE_RLO,

  /* Weak types */
  PDF   = PangoBidiType.PANGO_BIDI_TYPE_PDF,
  EN    = PangoBidiType.PANGO_BIDI_TYPE_EN,
  ES    = PangoBidiType.PANGO_BIDI_TYPE_ES,
  ET    = PangoBidiType.PANGO_BIDI_TYPE_ET,
  AN    = PangoBidiType.PANGO_BIDI_TYPE_AN,
  CS    = PangoBidiType.PANGO_BIDI_TYPE_CS,
  NSM   = PangoBidiType.PANGO_BIDI_TYPE_NSM,
  BN    = PangoBidiType.PANGO_BIDI_TYPE_BN,

  /* Neutral types */
  B     = PangoBidiType.PANGO_BIDI_TYPE_B,
  S     = PangoBidiType.PANGO_BIDI_TYPE_S,
  WS    = PangoBidiType.PANGO_BIDI_TYPE_WS,
  ON    = PangoBidiType.PANGO_BIDI_TYPE_ON
}


pure BidiType bidiTypeForUnichar(dchar ch)
{
    return cast(BidiType)pango_bidi_type_for_unichar(ch);
}

/**
 * PangoDirection:
 * LTR: A strong left-to-right direction
 * RTL: A strong right-to-left direction
 * TTB_LTR: Deprecated value; treated the
 *   same as %PANGO_DIRECTION_RTL.
 * TTB_RTL: Deprecated value; treated the
 *   same as %PANGO_DIRECTION_LTR
 * Weak_LTR: A weak left-to-right direction
 * Weak_RTL: A weak right-to-left direction
 * Neutral: No direction specified
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
enum Direction {
  LTR       = PangoDirection.PANGO_DIRECTION_LTR,
  RTL       = PangoDirection.PANGO_DIRECTION_RTL,
  TTB_LTR   = PangoDirection.PANGO_DIRECTION_TTB_LTR,
  TTB_RTL   = PangoDirection.PANGO_DIRECTION_TTB_RTL,
  Weak_LTR  = PangoDirection.PANGO_DIRECTION_WEAK_LTR,
  Weak_RTL  = PangoDirection.PANGO_DIRECTION_WEAK_RTL,
  Neutral   = PangoDirection.PANGO_DIRECTION_NEUTRAL
}

pure Direction unicharDirection(dchar ch) {
    return cast(Direction)pango_unichar_direction(ch);
}

Direction findBaseDir(string text) {
    return cast(Direction)pango_find_base_dir(text.ptr, cast(int)text.length);
}


//deprecated("use g_unichar_get_mirror_char")
//gboolean       pango_get_mirror_char        (gunichar     ch,
//                         gunichar    *mirrored_ch);

