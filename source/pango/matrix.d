module pango.matrix;

import pango.utils;
import pango.types;
import pango.c.matrix;


/**
 * Matrix:
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

struct Matrix
{
    private PangoMatrix * nativePtr_;


    @disable this();
    package this(PangoMatrix *ptr) { nativePtr_ = ptr; }


    pure @property inout(PangoMatrix)* nativePtr() inout { return nativePtr_; }

    Matrix copy() const {
        return Matrix(pango_matrix_copy(nativePtr));
    }

    void free() {
        pango_matrix_free(nativePtr_);
        nativePtr_ = null;
    }

    void translate(double tx, double ty) {
        pango_matrix_translate(nativePtr, tx, ty);
    }

    void scale(double sx, double sy) {
        pango_matrix_scale(nativePtr, sx, sy);
    }

    void rotate(double degrees) {
        pango_matrix_rotate(nativePtr, degrees);
    }

    void concat(const(Matrix) newMatrix) {
        pango_matrix_concat(nativePtr, newMatrix.nativePtr);
    }

    void transformPoint(ref double x, ref double y) const {
        pango_matrix_transform_point(nativePtr, &x, &y);
    }

    void transformDistance(ref double dx, ref double dy) const {
        pango_matrix_transform_distance(nativePtr, &dx, &dy);
    }

    void transformRectangle(ref Rectangle rect) const {
        pango_matrix_transform_rectangle(nativePtr, &rect);
    }

    void transformPixelRectangle(ref Rectangle rect) const {
        pango_matrix_transform_pixel_rectangle(nativePtr, &rect);
    }

    pure @property double fontScaleFactor() const {
        return pango_matrix_get_font_scale_factor(nativePtr);
    }
}


