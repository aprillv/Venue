//
//  MyView.h
//  DrawWall
//
//  Created by gll on 13-1-2.
//  Copyright (c) 2013年 gll. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyView : UIView
// get point  in view
-(UIView *)Signature;
-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)revocation;
-(void)refrom;
-(void)clear;
-(void)setLineColor:(NSInteger)color;
-(void)setLineArray1:(NSArray *)lineArray;
-(void)setlineWidth:(NSInteger)width;
@end