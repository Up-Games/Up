/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import <UPKit/POPDefines.h>
#import <UPKit/UPGeometry.h>

POP_EXTERN_C_BEGIN

NS_INLINE CGPoint values_to_point(const CGFloat values[])
{
  return CGPointMake(values[0], values[1]);
}

NS_INLINE CGSize values_to_size(const CGFloat values[])
{
  return CGSizeMake(values[0], values[1]);
}

NS_INLINE CGRect values_to_rect(const CGFloat values[])
{
  return CGRectMake(values[0], values[1], values[2], values[3]);
}

NS_INLINE UIEdgeInsets values_to_edge_insets(const CGFloat values[])
{
  return UIEdgeInsetsMake(values[0], values[1], values[2], values[3]);
}

NS_INLINE UPQuadOffsets values_to_quadOffsets(const CGFloat values[])
{
    return UPQuadOffsetsMake(
        UPOffsetMake(values[0], values[1]),
        UPOffsetMake(values[2], values[3]),
        UPOffsetMake(values[4], values[5]),
        UPOffsetMake(values[6], values[7]));
}

NS_INLINE void values_from_point(CGFloat values[], CGPoint p)
{
  values[0] = p.x;
  values[1] = p.y;
}

NS_INLINE void values_from_size(CGFloat values[], CGSize s)
{
  values[0] = s.width;
  values[1] = s.height;
}

NS_INLINE void values_from_rect(CGFloat values[], CGRect r)
{
  values[0] = r.origin.x;
  values[1] = r.origin.y;
  values[2] = r.size.width;
  values[3] = r.size.height;
}

NS_INLINE void values_from_edge_insets(CGFloat values[], UIEdgeInsets i)
{
  values[0] = i.top;
  values[1] = i.left;
  values[2] = i.bottom;
  values[3] = i.right;
}

NS_INLINE void values_from_quadOffsets(CGFloat values[], UPQuadOffsets i)
{
    values[0] = i.tl.dx;
    values[1] = i.tl.dy;
    values[2] = i.tr.dx;
    values[3] = i.tr.dy;
    values[4] = i.bl.dx;
    values[5] = i.bl.dy;
    values[6] = i.br.dx;
    values[7] = i.br.dy;
}

/**
 Takes a CGColorRef and converts it into RGBA components, if necessary.
 */
extern void POPCGColorGetRGBAComponents(CGColorRef color, CGFloat components[]);

/**
 Takes RGBA components and returns a CGColorRef.
 */
extern CGColorRef POPCGColorRGBACreate(const CGFloat components[]) CF_RETURNS_RETAINED;

/**
 Takes a color reference and returns a CGColor.
 */
extern CGColorRef POPCGColorWithColor(id color) CF_RETURNS_NOT_RETAINED;

/**
 Takes a UIColor and converts it into RGBA components, if necessary.
 */
extern void POPUIColorGetRGBAComponents(UIColor *color, CGFloat components[]);

/**
 Takes RGBA components and returns a UIColor.
 */
extern UIColor *POPUIColorRGBACreate(const CGFloat components[]) NS_RETURNS_RETAINED;

POP_EXTERN_C_END
