/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.utils;

import pango.c.font;
import pango.c.types;

import glib;
import gobject;

import core.stdc.stdio;


extern(C):


enum PANGO_VERSION_MAJOR = 1;
enum PANGO_VERSION_MINOR = 36;
enum PANGO_VERSION_MICRO = 8;

enum PANGO_VERSION_STRING = "1.36.8";


char **  pango_split_file_list (const(char) *str);

char    *pango_trim_string     (const(char) *str);
gint     pango_read_line      (FILE        *stream,
			       GString     *str);
gboolean pango_skip_space     (const(char) **pos);
gboolean pango_scan_word      (const(char) **pos,
			       GString     *out_);
gboolean pango_scan_string    (const(char) **pos,
			       GString     *out_);
gboolean pango_scan_int       (const(char) **pos,
			       int         *out_);

char *   pango_config_key_get_system (const(char) *key);
char *   pango_config_key_get (const(char)  *key);
deprecated
void     pango_lookup_aliases (const(char)   *fontname,
			       char       ***families,
			       int          *n_families);

gboolean pango_parse_enum     (GType       type,
			       const(char) *str,
			       int        *value,
			       gboolean    warn,
			       char      **possible_values);

/* Functions for parsing textual representations
 * of PangoFontDescription fields. They return TRUE if the input string
 * contains a valid value, which then has been assigned to the corresponding
 * field in the PangoFontDescription. If the warn parameter is TRUE,
 * a warning is printed (with g_warning) if the string does not
 * contain a valid value.
 */
gboolean pango_parse_style   (const(char)   *str,
			      PangoStyle   *style,
			      gboolean      warn);
gboolean pango_parse_variant (const(char)   *str,
			      PangoVariant *variant,
			      gboolean      warn);
gboolean pango_parse_weight  (const(char)   *str,
			      PangoWeight  *weight,
			      gboolean      warn);
gboolean pango_parse_stretch (const(char)   *str,
			      PangoStretch *stretch,
			      gboolean      warn);

/* On Unix, return the name of the "pango" subdirectory of SYSCONFDIR
 * (which is set at compile time). On Win32, return the Pango
 * installation directory (which is set at installation time, and
 * stored in the registry). The returned string should not be
 * g_free'd.
 */
pure const(char) *   pango_get_sysconf_subdirectory ();

/* Ditto for LIBDIR/pango. On Win32, use the same Pango
 * installation directory. This returned string should not be
 * g_free'd either.
 */
pure const(char) *   pango_get_lib_subdirectory ();


/* Hint line position and thickness.
 */
void pango_quantize_line_geometry (int *thickness,
				   int *position);

/* A routine from fribidi that we either wrap or provide ourselves.
 */
guint8 * pango_log2vis_get_embedding_levels (const(gchar)    *text,
					     int             length,
					     PangoDirection *pbase_dir);

/* Unicode characters that are zero-width and should not be rendered
 * normally.
 */
pure gboolean pango_is_zero_width (gunichar ch);

/* Pango version checking */

/* Encode a Pango version as an integer */
/**
 * PANGO_VERSION_ENCODE:
 * @major: the major component of the version number
 * @minor: the minor component of the version number
 * @micro: the micro component of the version number
 *
 * This macro encodes the given Pango version into an integer.  The numbers
 * returned by %PANGO_VERSION and pango_version() are encoded using this macro.
 * Two encoded version numbers can be compared as integers.
 */
auto PANGO_VERSION_ENCODE(N)(N major, N minor, N micro)
{
    return major * 10000 + minor * 100 + micro;
}

/* Encoded version of Pango at compile-time */
/**
 * PANGO_VERSION:
 *
 * The version of Pango available at compile-time, encoded using PANGO_VERSION_ENCODE().
 */
/**
 * PANGO_VERSION_STRING:
 *
 * A string literal containing the version of Pango available at compile-time.
 */
/**
 * PANGO_VERSION_MAJOR:
 *
 * The major component of the version of Pango available at compile-time.
 */
/**
 * PANGO_VERSION_MINOR:
 *
 * The minor component of the version of Pango available at compile-time.
 */
/**
 * PANGO_VERSION_MICRO:
 *
 * The micro component of the version of Pango available at compile-time.
 */
enum PANGO_VERSION = PANGO_VERSION_ENCODE(PANGO_VERSION_MAJOR,
        PANGO_VERSION_MINOR, PANGO_VERSION_MICRO);

/* Check that compile-time Pango is as new as required */
/**
 * PANGO_VERSION_CHECK:
 * @major: the major component of the version number
 * @minor: the minor component of the version number
 * @micro: the micro component of the version number
 *
 * Checks that the version of Pango available at compile-time is not older than
 * the provided version number.
 */
bool PANGO_VERSION_CHECK(N)(N major, N minor, N micro)
{
    return PANGO_VERSION >= PANGO_VERSION_ENCODE(major, minor, micro);
}


/* Return encoded version of Pango at run-time */
pure int pango_version ();

/* Return run-time Pango version as an string */
pure const(char) * pango_version_string ();

/* Check that run-time Pango is as new as required */
pure const(char) * pango_version_check (int required_major,
                                  int required_minor,
                                  int required_micro);

