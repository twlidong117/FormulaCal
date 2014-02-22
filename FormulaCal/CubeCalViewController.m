//
//  CubeCalViewController.m
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//
//  四棱柱的表面积和体积

#import "CubeCalViewController.h"

@interface CubeCalViewController ()

@end

@implementation CubeCalViewController

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
    //计算表面积体积
    float l;    //length
    float w;    //width
    float h;    //height
    float s;
    float v;
    
    l = [self.cubeLength.text floatValue];
    w = [self.cubeWidth.text floatValue];
    h = [self.cubeHeight.text floatValue];
    
    s = l * w * 4 + w * h * 2;      //表面积
    v = l * w * h;      //体积
    
    self.cubeOutput.text = [[NSString alloc] initWithFormat:
                            @"体积是 %.2f\n表面积是 %.2f",v,s];
    NSString *csvLine = [NSString stringWithFormat:@"长%.2f,宽%.2f,高%.2f,表面积%.2f,体积%.2f\n",l,w,h,s,v];
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
    NSString *resultFile = [docDir stringByAppendingPathComponent:@"cuberesults.csv"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:resultFile]) {
        [[NSFileManager defaultManager] createFileAtPath:resultFile contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:resultFile];
    
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[csvLine dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    [self.cubeLength resignFirstResponder];
    [self.cubeWidth resignFirstResponder];
    [self.cubeHeight resignFirstResponder];
}
- (IBAction)showResults:(id)sender {
    //显示结果记录
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resultsFile = [docDir stringByAppendingPathComponent:@"cuberesults.csv"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultsFile]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:resultsFile];
        NSString *cubeResults = [[NSString alloc] initWithData:[fileHandle availableData]
                                                      encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        self.cubeOutput.text = cubeResults;
        [self.show setTitle:@"删除记录" forState:UIControlStateNormal];
    }
    
    //删除文件
    if ([self.show.titleLabel.text isEqualToString:@"删除记录"]) {
        [[NSFileManager defaultManager] removeItemAtPath:resultsFile error:nil];
        self.cubeOutput.text = @"";
        [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
    }

    
}

- (IBAction)clear:(id)sender {
    //清除文本
    self.cubeLength.text = @"";
    self.cubeWidth.text = @"";
    self.cubeHeight.text = @"";
    self.cubeOutput.text = @"";
    [self.cubeLength resignFirstResponder];
    [self.cubeWidth resignFirstResponder];
    [self.cubeHeight resignFirstResponder];
    [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
}

- (IBAction)hideKeyboard:(id)sender {
    //隐藏键盘
    [self.cubeLength resignFirstResponder];
    [self.cubeWidth resignFirstResponder];
    [self.cubeHeight resignFirstResponder];
}


@end
