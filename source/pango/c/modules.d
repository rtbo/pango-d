/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.modules;

version (Backend)
{
    import pango.c.engine;
    import pango.c.language;
    import pango.c.script;

    import glib;
    import gobject;

    extern(C):

    struct PangoMap;
    struct PangoMapEntry;

    /**
     * PangoIncludedModule:
     * @list: a function that lists the engines defined in this module.
     * @init: a function to initialize the module.
     * @exit: a function to finalize the module.
     * @create: a function to create an engine, given the engine name.
     *
     * The #PangoIncludedModule structure for a statically linked module
     * contains the functions that would otherwise be loaded from a dynamically
     * loaded module.
     */
    struct PangoIncludedModule
    {
      void function (PangoEngineInfo **engines,
		    int              *n_engines) list;
      void function (GTypeModule      *mod) init;
      void function () exit;
      PangoEngine *function (const char       *id) create;
    }

    PangoMap *     pango_find_map        (PangoLanguage       *language,
				          guint                engine_type_id,
				          guint                render_type_id);
    PangoEngine *  pango_map_get_engine  (PangoMap            *map,
				          PangoScript          script);
    void           pango_map_get_engines (PangoMap            *map,
				          PangoScript          script,
				          GSList             **exact_engines,
				          GSList             **fallback_engines);
    void           pango_module_register (PangoIncludedModule *mod);

}
