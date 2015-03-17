/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.break_;

import pango.c.item;
import pango.c.language;

import glib;

import std.bitmanip;

extern(C):

/* Logical attributes of a character.
 */
/**
 * PangoLogAttr:
 * @is_line_break: if set, can break line in front of character
 * @is_mandatory_break: if set, must break line in front of character
 * @is_char_break: if set, can break here when doing character wrapping
 * @is_white: is whitespace character
 * @is_cursor_position: if set, cursor can appear in front of character.
 * i.e. this is a grapheme boundary, or the first character
 * in the text.
 * This flag implements Unicode's
 * <ulink url="http://www.unicode.org/reports/tr29/">Grapheme
 * Cluster Boundaries</ulink> semantics.
 * @is_word_start: is first character in a word
 * @is_word_end: is first non-word char after a word
 * Note that in degenerate cases, you could have both @is_word_start
 * and @is_word_end set for some character.
 * @is_sentence_boundary: is a sentence boundary.
 * There are two ways to divide sentences. The first assigns all
 * inter-sentence whitespace/control/format chars to some sentence,
 * so all chars are in some sentence; @is_sentence_boundary denotes
 * the boundaries there. The second way doesn't assign
 * between-sentence spaces, etc. to any sentence, so
 * @is_sentence_start/@is_sentence_end mark the boundaries of those sentences.
 * @is_sentence_start: is first character in a sentence
 * @is_sentence_end: is first char after a sentence.
 * Note that in degenerate cases, you could have both @is_sentence_start
 * and @is_sentence_end set for some character. (e.g. no space after a
 * period, so the next sentence starts right away)
 * @backspace_deletes_character: if set, backspace deletes one character
 * rather than the entire grapheme cluster. This
 * field is only meaningful on grapheme
 * boundaries (where @is_cursor_position is
 * set).  In some languages, the full grapheme
 * (e.g.  letter + diacritics) is considered a
 * unit, while in others, each decomposed
 * character in the grapheme is a unit. In the
 * default implementation of pango_break(), this
 * bit is set on all grapheme boundaries except
 * those following Latin, Cyrillic or Greek base characters.
 * @is_expandable_space: is a whitespace character that can possibly be
 * expanded for justification purposes. (Since: 1.18)
 * @is_word_boundary: is a word boundary.
 * More specifically, means that this is not a position in the middle
 * of a word.  For example, both sides of a punctuation mark are
 * considered word boundaries.  This flag is particularly useful when
 * selecting text word-by-word.
 * This flag implements Unicode's
 * <ulink url="http://www.unicode.org/reports/tr29/">Word
 * Boundaries</ulink> semantics. (Since: 1.22)
 *
 * The #PangoLogAttr structure stores information
 * about the attributes of a single character.
 */
struct PangoLogAttr
{
    mixin(bitfields!(
        guint, "is_line_break", 1,      /* Can break line in front of character */

        guint, "is_mandatory_break", 1, /* Must break line in front of character */

        guint, "is_char_break", 1,      /* Can break here when doing char wrap */

        guint, "is_white", 1,           /* Whitespace character */

        /* Cursor can appear in front of character (i.e. this is a grapheme
         * boundary, or the first character in the text).
         */
        guint, "is_cursor_position", 1,

        /* Note that in degenerate cases, you could have both start/end set on
         * some text, most likely for sentences (e.g. no space after a period, so
         * the next sentence starts right away).
         */

        guint, "is_word_start", 1,      /* first character in a word */
        guint, "is_word_end", 1,      /* is first non-word char after a word */

        /* There are two ways to divide sentences. The first assigns all
         * intersentence whitespace/control/format chars to some sentence,
         * so all chars are in some sentence; is_sentence_boundary denotes
         * the boundaries there. The second way doesn't assign
         * between-sentence spaces, etc. to any sentence, so
         * is_sentence_start/is_sentence_end mark the boundaries of those
         * sentences.
         */
        guint, "is_sentence_boundary", 1,
        guint, "is_sentence_start", 1,  /* first character in a sentence */
        guint, "is_sentence_end", 1,    /* first non-sentence char after a sentence */

        /* If set, backspace deletes one character rather than
         * the entire grapheme cluster.
         */
        guint, "backspace_deletes_character", 1,

        /* Only few space variants (U+0020 and U+00A0) have variable
         * width during justification.
         */
        guint, "is_expandable_space", 1,

        /* Word boundary as defined by UAX#29 */
        guint, "is_word_boundary", 1,	/* is NOT in the middle of a word */

        guint, "", 3));
};

/* Determine information about cluster/word/line breaks in a string
 * of Unicode text.
 */
void pango_break (const(gchar)   *text,
		  int            length,
		  PangoAnalysis *analysis,
		  PangoLogAttr  *attrs,
		  int            attrs_len);

void pango_find_paragraph_boundary (const(gchar) *text,
				    gint         length,
				    gint        *paragraph_delimiter_index,
				    gint        *next_paragraph_start);

void pango_get_log_attrs (const(char)    *text,
			  int            length,
			  int            level,
			  PangoLanguage *language,
			  PangoLogAttr  *log_attrs,
			  int            attrs_len);


/* This is the default break algorithm, used if no language
 * engine overrides it. Normally you should use pango_break()
 * instead; this function is mostly useful for chaining up
 * from a language engine override.
 */
void pango_default_break (const(gchar)   *text,
			  int            length,
			  PangoAnalysis *analysis,
			  PangoLogAttr  *attrs,
			  int            attrs_len);

