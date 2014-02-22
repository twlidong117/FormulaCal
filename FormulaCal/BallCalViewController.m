//
//  BallCalViewController.m
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//
//  球的表面积和体积

#import "BallCalViewController.h"

#define PI 3.1415927

@interface BallCalViewController ()

@end

@implementation BallCalViewController

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
    float r;    //球半径
    float s;
    float v;
    
    r = [self.ballRadius.text floatValue];
    
    s = 4 * PI * r * r;     //表面积
    v = 4 * PI * r * r * r / 3;     //体积
    
    self.ballOutput.text = [[NSString alloc] initWithFormat:
                            @"体积是 %.2f\n表面积是 %.2f",v,s];
    NSString *csvLine = [NSString stringWithFormat:@"半径%.2f,表面积%.2f,体积%.2f\n",r,s,v];
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resultFile = [docDir stringByAppendingPathComponent:@"ballresults.csv"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:resultFile]) {
        [[NSFileManager defaultManager] createFileAtPath:resultFile contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:resultFile];
    
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[csvLine dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    [self.ballRadius resignFirstResponder];
}
- (IBAction)showResults:(id)sender {
    //显示结果记录
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resultsFile = [docDir stringByAppendingPathComponent:@"ballresults.csv"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultsFile]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:resultsFile];
        NSString *ballResults = [[NSString alloc] initWithData:[fileHandle availableData]
                                                      encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        self.ballOutput.text = ballResults;
        [self.show setTitle:@"删除记录" forState:UIControlStateNormal];
    }
    
    //删除文件
    if ([self.show.titleLabel.text isEqualToString:@"删除记录"]) {
        [[NSFileManager defaultManager] removeItemAtPath:resultsFile error:nil];
        self.ballOutput.text = @"";
        [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
    }

    
}

- (IBAction)clear:(id)sender {
    //清除文本
    self.ballOutput.text = @"";
    self.ballRadius.text = @"";
    [self.ballRadius resignFirstResponder];
    [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
}

- (IBAction)hideKeyboard:(id)sender {
    //隐藏键盘
    [self.ballRadius resignFirstResponder];
}


@end
