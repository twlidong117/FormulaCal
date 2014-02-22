//
//  TriangleCalViewController.h
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TriangleCalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *triangleLengthA;
@property (weak, nonatomic) IBOutlet UITextField *triangleLengthB;
@property (weak, nonatomic) IBOutlet UITextField *triangleLengthC;
@property (weak, nonatomic) IBOutlet UITextView *triangleOutput;
@property (weak, nonatomic) IBOutlet UIButton *show;


- (IBAction)calculate:(id)sender;
- (IBAction)showResults:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
