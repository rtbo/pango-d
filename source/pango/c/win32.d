/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.win32;


version (Win32) {

    import pango.c.font;
    import pango.c.layout;
    import pango.c.matrix;
    import pango.c.fontmap;
    import pango.c.glyph;

    import glib;

    import win32.windef;
    import win32.wingdi;

    extern(C):
    /* Calls for applications
     */

    void           pango_win32_render             (HDC               hdc,
					           PangoFont        *font,
					           PangoGlyphString *glyphs,
					           gint              x,
					           gint              y);
    void           pango_win32_render_layout_line (HDC               hdc,
					           PangoLayoutLine  *line,
					           int               x,
					           int               y);
    void           pango_win32_render_layout      (HDC               hdc,
					           PangoLayout      *layout,
					           int               x,
					           int               y);

    void           pango_win32_render_transformed (HDC         hdc,
					           const(PangoMatrix) *matrix,
					           PangoFont         *font,
					           PangoGlyphString  *glyphs,
					           int                x,
					           int                y);


    /* For shape engines
     */

    gint	      pango_win32_font_get_glyph_index(PangoFont        *font,
					           gunichar          wc);

    HDC            pango_win32_get_dc             ();

    gboolean       pango_win32_get_debug_flag     ();

    gboolean pango_win32_font_select_font        (PangoFont *font,
					          HDC        hdc);
    void     pango_win32_font_done_font          (PangoFont *font);
    double   pango_win32_font_get_metrics_factor (PangoFont *font);


    /* API for libraries that want to use PangoWin32 mixed with classic
     * Win32 fonts.
     */
    struct PangoWin32FontCache;

    PangoWin32FontCache *pango_win32_font_cache_new          ();
    void                 pango_win32_font_cache_free         (PangoWin32FontCache *cache);

    HFONT                pango_win32_font_cache_load         (PangoWin32FontCache *cache,
							      const(LOGFONTA)      *logfont);
    HFONT                pango_win32_font_cache_loadw        (PangoWin32FontCache *cache,
							      const(LOGFONTW)      *logfont);
    void                 pango_win32_font_cache_unload       (PangoWin32FontCache *cache,
							      HFONT                hfont);

    PangoFontMap        *pango_win32_font_map_for_display    ();
    void                 pango_win32_shutdown_display        ();
    PangoWin32FontCache *pango_win32_font_map_get_font_cache (PangoFontMap       *font_map);

    LOGFONTA            *pango_win32_font_logfont            (PangoFont          *font);
    LOGFONTW            *pango_win32_font_logfontw           (PangoFont          *font);

    PangoFontDescription *pango_win32_font_description_from_logfont (const(LOGFONTA) *lfp);

    PangoFontDescription *pango_win32_font_description_from_logfontw (const(LOGFONTW) *lfp);

}
