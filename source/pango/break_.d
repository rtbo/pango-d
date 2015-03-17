/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.break_;

import pango.utils;
import pango.item;
import pango.language;
import pango.c.break_;
import pango.c.language;

import glib;


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
alias LogAttr = PangoLogAttr;


/* Determine information about cluster/word/line breaks in a string
 * of Unicode text.
 */
LogAttr[] pangoBreak(string text, Analysis *analysis)
{
    int len = g_utf8_strlen(text.ptr, text.length)+1;
    if (!len) return [];
    LogAttr[] res = new LogAttr[len];
    pango_break(text.ptr, text.length, &analysis.pangoStruct, res.ptr, len);
    return res;
}

void pangoFindParagraphBoundary(string text, out int paragraphDelimiterIndex, out int nextParagraphStart) {
    pango_find_paragraph_boundary(text.ptr, text.length, &paragraphDelimiterIndex, &nextParagraphStart);
}

LogAttr[] pangoGetLogAttrs(string text, int level, Language language)
{
    int len = g_utf8_strlen(text.ptr, text.length)+1;
    if (!len) return [];
    LogAttr[] res = new LogAttr[len];
    pango_get_log_attrs(text.ptr, text.length, level, language.nativePtr, res.ptr, len);
    return res;
}

/* This is the default break algorithm, used if no language
 * engine overrides it. Normally you should use pango_break()
 * instead; this function is mostly useful for chaining up
 * from a language engine override.
 */
LogAttr[] pangoDefaultBreak(string text, Analysis *analysis)
{
    int len = g_utf8_strlen(text.ptr, text.length)+1;
    if (!len) return [];
    LogAttr[] res = new LogAttr[len];
    pango_default_break(text.ptr, text.length, &analysis.pangoStruct, res.ptr, len);
    return res;
}
