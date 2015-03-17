module pango.fontmap;

import pango.utils;
import pango.font;
import pango.fontset;
import pango.context;
import pango.language;
import pango.c.fontmap;

import gobject;
import glib;


/**
* PangoFontMap:
*
* The #PangoFontMap represents the set of fonts available for a
* particular rendering system. This is a virtual object with
* implementations being specific to particular rendering systems.  To
* create an implementation of a #PangoFontMap, the rendering-system
* specific code should allocate a larger structure that contains a nested
* #PangoFontMap, fill in the <structfield>klass</structfield> member of the nested #PangoFontMap with a
* pointer to a appropriate #PangoFontMapClass, then call
* pango_font_map_init() on the structure.
*
* The #PangoFontMap structure contains one member which the implementation
* fills in.
*/
abstract class FontMap : D_GObject
{
    mixin GObjectHolder!PangoFontMap;

    package this(PangoFontMap *ptr, Transfer transfer) {
        super(cast(GObject*)ptr, transfer);
    }

    abstract Context createContext();

    abstract Font loadFont(Context context, const(FontDescription) desc);

    abstract FontSet loadFontSet(Context context, const(FontDescription) desc, Language language);


    FontFamily[] listFamilies()
    {
        return listGObjects!(FontFamily, pango_font_map_list_families)(nativePtr, Transfer.None);
    }


    @property uint serial() {
        return pango_font_map_get_serial(nativePtr);
    }

    version (Backend) {
        void changed() {
            pango_font_map_changed(nativePtr);
        }
    }

}


