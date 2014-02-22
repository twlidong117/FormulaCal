//
//  CylinderViewController.m
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//
//  圆柱的表面积和体积

#import "CylinderViewController.h"

#define PI 3.1415927

@interface CylinderViewController ()

@end

@implementation CylinderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculate:(id)sender {
    //计算表面积和体积
    float r;    //底面半径
    float h;    //高
    float s;
    float v;
    
    r = [self.cylinderRadius.text floatValue];
    h = [self.cylinderHeight.text floatValue];
    
    s = 4 * PI * r * r + 2 * PI * r * h;    //表面积
    v = 2 * PI * r * r * h;     //体积
    
    self.cylinderOutput.text = [[NSString alloc] initWithFormat:
                                @"体积是 %.2f\n表面积是 %.2f",v,s];
    NSString *csvLine = [NSString stringWithFormat:@"半径%.2f,高%.2f,表面积%.2f,体积%.2f\n",r,h,s,v];
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
    NSString *resultFile = [docDir stringByAppendingPathComponent:@"cylinderresults.csv"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:resultFile]) {
        [[NSFileManager defaultManager] createFileAtPath:resultFile contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:resultFile];
    
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[csvLine dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    [self.cylinderRadius resignFirstResponder];
    [self.cylinderHeight resignFirstResponder];
    
}
- (IBAction)showResults:(id)sender {
    //显示结果记录
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resultsFile = [docDir stringByAppendingPathComponent:@"cylinderresults.csv"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultsFile]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:resultsFile];
        NSString *cylinderResults = [[NSString alloc] initWithData:[fileHandle availableData]
                                                          encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        self.cylinderOutput.text = cylinderResults;
        [self.show setTitle:@"删除记录" forState:UIControlStateNormal];
    }
    
    //删除文件
    if ([self.show.titleLabel.text isEqualToString:@"删除记录"]) {
        [[NSFileManager defaultManager] removeItemAtPath:resultsFile error:nil];
        self.cylinderOutput.text = @"";
        [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
    }

    
}

- (IBAction)clear:(id)sender {
    //清除文本
    self.cylinderRadius.text = @"";
    self.cylinderHeight.text = @"";
    self.cylinderOutput.text = @"";
    [self.cylinderRadius resignFirstResponder];
    [self.cylinderHeight resignFirstResponder];
    [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
}

- (IBAction)hideKeyboard:(id)sender {
    //隐藏键盘
    [self.cylinderRadius resignFirstResponder];
    [self.cylinderHeight resignFirstResponder];
}



@end
