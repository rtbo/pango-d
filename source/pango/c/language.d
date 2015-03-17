/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.language;

import pango.c.script;

import glib;
import gobject;

extern(C):

struct PangoLanguage;


pure GType          pango_language_get_type    ();
PangoLanguage *pango_language_from_string (const(char) *language);

pure const(char)    *pango_language_to_string   (PangoLanguage *language);

pure const(char)    *pango_language_get_sample_string (PangoLanguage *language);
PangoLanguage *pango_language_get_default ();

pure gboolean      pango_language_matches  (PangoLanguage *language,
				       const(char) *range_list);


pure gboolean		    pango_language_includes_script (PangoLanguage *language,
							    PangoScript    script);
const(PangoScript)          *pango_language_get_scripts	   (PangoLanguage *language,
							    int           *num_scripts);

