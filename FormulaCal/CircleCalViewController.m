//
//  CircleCalViewController.m
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//
//  圆形的周长和面积

#import "CircleCalViewController.h"

#define PI 3.1415927

@interface CircleCalViewController ()

@end

@implementation CircleCalViewController

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
    //计算面积和周长
    float r;
    float p;
    float s;
    
    r = [self.circleRadius.text floatValue];
    p = 2 * PI * r;     //周长
    s = PI * r * r;     //面积
    
    self.circleOutput.text = [[NSString alloc] initWithFormat:
                              @"周长是 %.2f\n面积是 %.2f",p,s];
    NSString *csvLine = [NSString stringWithFormat:@"半径%.2f,周长%.2f,面积%.2f\n",r,p,s];
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
    NSString *resultFile = [docDir stringByAppendingPathComponent:@"circleresults.csv"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:resultFile]) {
        [[NSFileManager defaultManager] createFileAtPath:resultFile contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:resultFile];
    
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[csvLine dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    [self.circleRadius resignFirstResponder];
}
- (IBAction)showResults:(id)sender {
    //显示结果记录
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resultsFile = [docDir stringByAppendingPathComponent:@"circleresults.csv"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultsFile]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:resultsFile];
        NSString *circleResults = [[NSString alloc] initWithData:[fileHandle availableData]
                                                        encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        self.circleOutput.text = circleResults;
        [self.show setTitle:@"删除记录" forState:UIControlStateNormal];
    }
    
    //删除文件
    if ([self.show.titleLabel.text isEqualToString:@"删除记录"]) {
        [[NSFileManager defaultManager] removeItemAtPath:resultsFile error:nil];
        self.circleOutput.text = @"";
        [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
    }

    
}

- (IBAction)clear:(id)sender {
    //清除文本
    self.circleOutput.text = @"";
    self.circleRadius.text = @"";
    [self.circleRadius resignFirstResponder];
    [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
    
}

- (IBAction)hideKeyboard:(id)sender {
    //隐藏键盘
    [self.circleRadius resignFirstResponder];
}


@end
