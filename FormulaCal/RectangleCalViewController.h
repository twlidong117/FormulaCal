//
//  RectangleCalViewController.h
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectangleCalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *rectangleLength;
@property (weak, nonatomic) IBOutlet UITextField *rectangleWidth;
@property (weak, nonatomic) IBOutlet UITextView *rectangleOutput;
@property (weak, nonatomic) IBOutlet UIButton *show;





- (IBAction)calculate:(id)sender;
- (IBAction)showResults:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
