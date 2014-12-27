UIColor-HTMLColors
==================

Read and write HTML/CSS colors, with support for RGB hex triplets, RGB and RGBA, HSL and HSLA and CSS3 named colors.

Reading
-------

```objective-c
#import "UIColor+HTMLColors.h"

UIColor *red   = [UIColor colorWithCSS:@"hsla(0, 100%, 50%, 1.0)"];
UIColor *green = [UIColor colorWithCSS:@"#00FF00"];
UIColor *blue  = [UIColor colorWithCSS:@"rgb(0, 0, 255)"];
UIColor *clear = [UIColor colorWithCSS:@"transparent"];
UIColor *cyan  = [UIColor colorWithCSS:@"cyan"];
```

The parsing is based on NSScanner, so scanning methods are available for easy integration with your larger scanning needs.

```objective-c
NSScanner *scanner; // Defined elsewhere

UIColor *color;
if ([scanner scanCSSColor:&color]) {
    // Congratulations, you've got a color
}
```

Writing
-------

Everyone likes a bit of symmetry, and it's nice to be able to write out colors in the formats you can read. Methods are provided for writing all but the named colors, because they cover such a small subset of all possible colors.

```objective-c
UIColor *color = [UIColor colorWithCSS:@"DarkOliveGreen"];
NSString *hsl = [color hslStringValue];
// => @"hsl(82, 39%, 30%)"
```

Converting between representations may incur a small error, as components are rounded (eg. hue to the nearest degree, percentages to the nearest 1%).

License
-------

Copyright (c) 2012, James Lawton
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

