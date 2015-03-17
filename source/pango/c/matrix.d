/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.c.matrix;

import pango.c.types;

import glib;
import gobject;


extern(C):

/**
 * PangoMatrix:
 * @xx: 1st component of the transformation matrix
 * @xy: 2nd component of the transformation matrix
 * @yx: 3rd component of the transformation matrix
 * @yy: 4th component of the transformation matrix
 * @x0: x translation
 * @y0: y translation
 *
 * A structure specifying a transformation between user-space
 * coordinates and device coordinates. The transformation
 * is given by
 *
 * <programlisting>
 * x_device = x_user * matrix->xx + y_user * matrix->xy + matrix->x0;
 * y_device = x_user * matrix->yx + y_user * matrix->yy + matrix->y0;
 * </programlisting>
 *
 * Since: 1.6
 **/
struct PangoMatrix
{
  double xx=1;
  double xy=0;
  double yx=0;
  double yy=1;
  double x0=0;
  double y0=0;
}



pure GType pango_matrix_get_type ();

PangoMatrix *pango_matrix_copy   (const(PangoMatrix) *matrix);
void         pango_matrix_free   (PangoMatrix *matrix);

void pango_matrix_translate (PangoMatrix *matrix,
			     double       tx,
			     double       ty);
void pango_matrix_scale     (PangoMatrix *matrix,
			     double       scale_x,
			     double       scale_y);
void pango_matrix_rotate    (PangoMatrix *matrix,
			     double       degrees);
void pango_matrix_concat    (PangoMatrix       *matrix,
			     const(PangoMatrix) *new_matrix);
void pango_matrix_transform_point    (const(PangoMatrix) *matrix,
				      double            *x,
				      double            *y);
void pango_matrix_transform_distance (const(PangoMatrix) *matrix,
				      double            *dx,
				      double            *dy);
void pango_matrix_transform_rectangle (const(PangoMatrix) *matrix,
				       PangoRectangle    *rect);
void pango_matrix_transform_pixel_rectangle (const(PangoMatrix) *matrix,
					     PangoRectangle    *rect);
pure double pango_matrix_get_font_scale_factor (const(PangoMatrix) *matrix);

