//
//  TriangleCalViewController.m
//  FormulaCal
//
//  Created by wp on 14-2-21.
//  Copyright (c) 2014年 wp. All rights reserved.
//
//  三角形周长和面积

#import "TriangleCalViewController.h"

@interface TriangleCalViewController ()

@end

@implementation TriangleCalViewController

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
    float a;
    float b;
    float c;    //三边长
    float p;
    float temp;
    float s;
    
    a = [self.triangleLengthA.text floatValue];
    b = [self.triangleLengthB.text floatValue];
    c = [self.triangleLengthC.text floatValue];
    
    
    if ((a + b) <= c || (a + c) <= b || (b + c) <= a) {    //判断是否为三角形
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"错误"
                                  message:@"不是三角形，请重新输入！"
                                  delegate:self
                                  cancelButtonTitle:@"好"
                                  otherButtonTitles: nil];
        [alertView show];
    } else {
        p = a + b + c;  //周长
        temp = p / 2;
        s = sqrtf(temp * (temp - a) * (temp - b) * (temp - c));     //面积采用海伦公式计算
        
        self.triangleOutput.text = [[NSString alloc] initWithFormat:
                                    @"周长是 %.2f\n面积是 %.2f",p,s];
        NSString *csvLine = [NSString stringWithFormat:@"三边%.2f、%.2f、%.2f,周长%.2f,面积%.2f\n",a,b,c,p,s];
        NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
        NSString *resultFile = [docDir stringByAppendingPathComponent:@"triangleresults.csv"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:resultFile]) {
            [[NSFileManager defaultManager] createFileAtPath:resultFile contents:nil attributes:nil];
        }
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:resultFile];
        
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[csvLine dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
        
        [self.triangleLengthA resignFirstResponder];
        [self.triangleLengthB resignFirstResponder];
        [self.triangleLengthC resignFirstResponder];
    }
}
- (IBAction)showResults:(id)sender {
    //显示结果记录
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resultsFile = [docDir stringByAppendingPathComponent:@"triangleresults.csv"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultsFile]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:resultsFile];
        NSString *triangleResults = [[NSString alloc] initWithData:[fileHandle availableData]
                                                          encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        self.triangleOutput.text = triangleResults;
        [self.show setTitle:@"删除记录" forState:UIControlStateNormal];
    }
    
    //删除文件
    if ([self.show.titleLabel.text isEqualToString:@"删除记录"]) {
        [[NSFileManager defaultManager] removeItemAtPath:resultsFile error:nil];
        self.triangleOutput.text = @"";
        [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
    }

    
}

- (IBAction)hideKeyboard:(id)sender {
    //隐藏键盘
    [self.triangleLengthA resignFirstResponder];
    [self.triangleLengthB resignFirstResponder];
    [self.triangleLengthC resignFirstResponder];
}

- (IBAction)clear:(id)sender {
    //清除文本
    self.triangleLengthA.text = @"";
    self.triangleLengthB.text = @"";
    self.triangleLengthC.text = @"";
    self.triangleOutput.text = @"";
    [self.triangleLengthA resignFirstResponder];
    [self.triangleLengthB resignFirstResponder];
    [self.triangleLengthC resignFirstResponder];
    [self.show setTitle:@"读取记录" forState:UIControlStateNormal];
}
@end
