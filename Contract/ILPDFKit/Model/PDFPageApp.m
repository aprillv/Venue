// PDFPageApp.m
//
// Copyright (c) 2015 Iwe Labs
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PDFPageApp.h"
#import "PDFDictionary.h"


@interface PDFPageApp(Private)
- (CGRect)rotateBox:(CGRect)box;
@end

@implementation PDFPageApp {
    CGPDFPageRef _page;
    PDFDictionary *_dictionary;
    PDFDictionary *_resources;
}

#pragma mark - Initialization
- (instancetype)init{
    return [self initWithPage:nil];
}
- (instancetype)initWithPage:(CGPDFPageRef)pg {
    self = [super init];
    if (self != nil) {
        _page = pg;
    }
    return self;
}

#pragma mark - Getter

- (PDFDictionary *)dictionary {
    if (_dictionary == nil) {
        _dictionary = [[PDFDictionary alloc] initWithDictionary:CGPDFPageGetDictionary(_page)];
    }
    return _dictionary;
}

- (PDFDictionary *)resources {
    if (_resources == nil) {
        _resources = [self.dictionary inheritableValueForKey:@"Resources"];
    }
    return _resources;
}

- (UIImage *)thumbNailImage {
    NSData *dat = [self.dictionary[@"Thumb"] data];
    if (dat) {
        return [UIImage imageWithData:dat];
    }
    return nil;
}

- (NSUInteger)pageNumber {
    return CGPDFPageGetPageNumber(_page);
}

- (NSInteger)rotationAngle {
    return CGPDFPageGetRotationAngle(_page);
}

- (CGRect)mediaBox {
    return [self rotateBox:CGPDFPageGetBoxRect(_page, kCGPDFMediaBox)];
}

- (CGRect)cropBox {
    return [self rotateBox:CGPDFPageGetBoxRect(_page, kCGPDFCropBox)];
}

- (CGRect)bleedBox {
    return [self rotateBox:CGPDFPageGetBoxRect(_page, kCGPDFBleedBox)];
}

- (CGRect)trimBox {
    return [self rotateBox:CGPDFPageGetBoxRect(_page, kCGPDFTrimBox)];
}

- (CGRect)artBox {
    return [self rotateBox:CGPDFPageGetBoxRect(_page, kCGPDFArtBox)];
}

#pragma mark - Private

- (CGRect)rotateBox:(CGRect)box {
    CGRect ret= box;
    switch ([self rotationAngle]%360) {
        case 0:
            break;
        case 90:
            ret = CGRectMake(ret.origin.x,ret.origin.y,ret.size.height,ret.size.width);
            break;
        case 180:
            break;
        case 270:
            ret = CGRectMake(ret.origin.x,ret.origin.y,ret.size.height,ret.size.width);
        default:
            break;
    }
    return ret;
}

-(void)createPDFfromUIView:(UIWebView*)webView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSString *heightStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    
    int height = [heightStr intValue];
    //  CGRect screenRect = [[UIScreen mainScreen] bounds];
    //  CGFloat screenHeight = (self.contentWebView.hidden)?screenRect.size.width:screenRect.size.height;
    CGFloat screenHeight = webView.bounds.size.height;
    int pages = ceil(height / screenHeight);
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, webView.bounds, nil);
    CGRect frame = [webView frame];
    for (int i = 0; i < pages; i++) {
        // Check to screenHeight if page draws more than the height of the UIWebView
        if ((i+1) * screenHeight  > height) {
            CGRect f = [webView frame];
            f.size.height -= (((i+1) * screenHeight) - height);
            [webView setFrame: f];
        }
        
        UIGraphicsBeginPDFPage();
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        //      CGContextTranslateCTM(currentContext, 72, 72); // Translate for 1" margins
        
        [[[webView subviews] lastObject] setContentOffset:CGPointMake(0, screenHeight * i) animated:NO];
        [webView.layer renderInContext:currentContext];
    }
    
    UIGraphicsEndPDFContext();
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    [webView setFrame:frame];
}


@end
