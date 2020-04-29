/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "POPCGUtils.h"

#import <objc/runtime.h>

void POPCGColorGetRGBAComponents(CGColorRef color, CGFloat components[])
{
  if (color) {
    const CGFloat *colors = CGColorGetComponents(color);
    size_t count = CGColorGetNumberOfComponents(color);

    if (4 == count) {
      // RGB colorspace
      components[0] = colors[0];
      components[1] = colors[1];
      components[2] = colors[2];
      components[3] = colors[3];
    } else if (2 == count) {
      // Grey colorspace
      components[0] = components[1] = components[2] = colors[0];
      components[3] = colors[1];
    } else {
      // Use CI to convert
      CIColor *ciColor = [CIColor colorWithCGColor:color];
      components[0] = ciColor.red;
      components[1] = ciColor.green;
      components[2] = ciColor.blue;
      components[3] = ciColor.alpha;
    }
  } else {
    memset(components, 0, 4 * sizeof(components[0]));
  }
}

CGColorRef POPCGColorRGBACreate(const CGFloat components[])
{
  CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
  CGColorRef color = CGColorCreate(space, components);
  CGColorSpaceRelease(space);
  return color;
}

CGColorRef POPCGColorWithColor(id color)
{
  if (CFGetTypeID((__bridge CFTypeRef)color) == CGColorGetTypeID()) {
    return ((__bridge CGColorRef)color);
  }
  else if ([color isKindOfClass:[UIColor class]]) {
    return [color CGColor];
  }
  return nil;
}

void POPUIColorGetRGBAComponents(UIColor *color, CGFloat components[])
{
  return POPCGColorGetRGBAComponents(POPCGColorWithColor(color), components);
}

UIColor *POPUIColorRGBACreate(const CGFloat components[])
{
  CGColorRef colorRef = POPCGColorRGBACreate(components);
  UIColor *color = [[UIColor alloc] initWithCGColor:colorRef];
  CGColorRelease(colorRef);
  return color;
}
