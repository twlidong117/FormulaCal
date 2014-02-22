//
//  RectangleCalViewController.m
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//
//  矩形周长和面积

#import "RectangleCalViewController.h"

@interface RectangleCalViewController ()

@end

@implementation RectangleCalViewController

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

- (void)calculate:(id)sender {
    //计算面积和周长
    float l;    //length
    float w;    //width
    float p;    //perimeter
    float s;    //square
    
    l = [self.rectangleLength.text floatValue];
    w = [self.rectangleWidth.text floatValue];
    p = (l + w) * 2;    //求周长
    s = l * w;          //求面积
    
    self.rectangleOutput.text = [[NSString alloc] initWithFormat:@"周长是 %.2f\n面积是 %.2f",p,s];
    
    //保存计算结果
    NSString *csvLine = [NSString stringWithFormat:@"长%.2f,宽%.2f,周长%.2f,面积%.2f\n",l,w,p,s];
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
    NSString *resultFile = [docDir stringByAppendingPathComponent:@"rectangleresults.csv"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:resultFile]) {
        [[NSFileManager defaultManager] createFileAtPath:resultFile contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:resultFile];
    
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[csvLine dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    [self.rectangleLength resignFirstResponder];
    [self.rectangleWidth resignFirstResponder];
}

- (void)showResults:(id)sender {
    //显示计算结果记录
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
    NSString *resultsFile = [docDir stringByAppendingPathComponent:@"rectangleresults.csv"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultsFile]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:resultsFile];
        NSString *rectangleResults = [[NSString alloc] initWithData:[fileHandle availableData]
                                                           encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        self.rectangleOutput.text = rectangleResults;
        [self.show setTitle:@"删除记录" forState:UIControlStateNormal];
    }
    
    //删除文件
    if ([self.show.titleLabel.text isEqualToString:@"删除记录"]) {
        [[NSFileManager defaultManager] removeItemAtPath:resultsFile error:nil];
        self.rectangleOutput.text = @"";
        [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
    }
}

- (IBAction)clear:(id)sender {
    //清除文本
    self.rectangleLength.text = @"";
    self.rectangleWidth.text = @"";
    self.rectangleOutput.text = @"";
    [self.rectangleLength resignFirstResponder];
    [self.rectangleWidth resignFirstResponder];
    [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
}

- (IBAction)hideKeyboard:(id)sender {
    //隐藏键盘
    [self.rectangleLength resignFirstResponder];
    [self.rectangleWidth resignFirstResponder];
}
@end
