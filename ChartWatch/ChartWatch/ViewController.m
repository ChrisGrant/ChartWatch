//
//  ViewController.m
//  ChartWatch
//
//  Copyright (c) 2014 Scott Logic Ltd. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiCharts.h>
#import <ShinobiCharts/ShinobiCharts.h>
#import <ShinobiCharts/SChartCanvas.h>
#import <ShinobiCharts/SChartGLView.h>
#import "SChartGLView+Screenshot.h"

typedef NS_ENUM(NSUInteger, ChartType) {
    ChartTypeLine,
    ChartTypeColumn,
    ChartTypeBar,
};

@interface ViewController () <SChartDatasource>

@property (nonatomic, strong) ShinobiChart *chart;
@property (nonatomic, assign) ChartType chartType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chart = [[ShinobiChart alloc] initWithFrame:CGRectMake(-600, -600, 300, 300)];
    self.chart.datasource = self;
    
    SChartNumberAxis *xAxis = [SChartNumberAxis new];
    xAxis.title = @"X Value";
    self.chart.xAxis = xAxis;
    
    SChartNumberAxis *yAxis = [SChartNumberAxis new];
    yAxis.title = @"Y Value";
    yAxis.rangePaddingLow = @(0.1);
    yAxis.rangePaddingHigh = @(0.1);
    self.chart.yAxis = yAxis;
    
    [self.view addSubview:self.chart];
}

- (IBAction)generateLineChartTapped:(UIButton *)sender {
    self.chartType = ChartTypeLine;
    [self prepareForScreenshot];
    [self performSelector:@selector(screenshot) withObject:nil afterDelay:0.1];
}

- (IBAction)generateColumnChartTapped:(UIButton *)sender {
    self.chartType = ChartTypeColumn;
    [self prepareForScreenshot];
    [self performSelector:@selector(screenshot) withObject:nil afterDelay:0.1];
}

- (IBAction)generateBarChartTapped:(UIButton *)sender {
    self.chartType = ChartTypeBar;
    [self prepareForScreenshot];
    [self performSelector:@selector(screenshot) withObject:nil afterDelay:0.1];
}

/**
 *  Prepare for a screenshot to be taken by reloading the data and redrawing the chart.
 */
- (void)prepareForScreenshot {
    [self.chart reloadData];
    [self.chart redrawChart];
}

/**
 *  Take a screenshot of the chart's GLView and save it to the shared application group directory.
 */
- (void)screenshot {
    // Generate a UIImage from the chart's GLView.
    // (See http://www.shinobicontrols.com/blog/posts/2012/03/26/taking-a-shinobichart-screenshot-from-your-app)
    UIImage *chartImage = [self.chart.canvas.glView snapshot];
    
    // Find the baseURL for the shared app group, and then append chartImageData.png to it to give us the file path.
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSURL *baseUrl = [defaultManager containerURLForSecurityApplicationGroupIdentifier:@"group.ShareAlike"];
    NSURL *fileUrl = [baseUrl URLByAppendingPathComponent:@"chartImageData.png" isDirectory:NO];
    
    // Convert the image to PNG file data.
    NSData *fileData = UIImagePNGRepresentation(chartImage);
    
    // Write the file, and display an alert if the file fails to write.
    NSError *writeError;
    if (![fileData writeToURL:fileUrl options:NSDataWritingAtomic error:&writeError]) {
        // Writing to a file failed. Show why.
        UIAlertController *alert;
        alert = [UIAlertController alertControllerWithTitle:@"File write failed"
                                                    message:writeError.debugDescription
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (id<SChartData>)sChart:(ShinobiChart *)chart
        dataPointAtIndex:(NSInteger)dataIndex
        forSeriesAtIndex:(NSInteger)seriesIndex
{
    SChartDataPoint *dp = [SChartDataPoint new];
    dp.xValue = @(dataIndex);
    if (self.chartType == ChartTypeLine) {
        dp.yValue = @(cos(dataIndex / 10.0));
    }
    else if (self.chartType == ChartTypeColumn) {
        dp.yValue = @(cos(dataIndex));
    }
    else {
        dp.yValue = @(dataIndex);
    }
    return dp;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    if (self.chartType == ChartTypeLine) {
        return 100;
    }
    return 10;
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    if (self.chartType == ChartTypeLine) {
        SChartLineSeries *series = [SChartLineSeries new];
        series.style.lineWidth = @3;
        return series;
    }
    else if (self.chartType == ChartTypeColumn) {
        return [SChartColumnSeries new];
    }
    else if (self.chartType == ChartTypeBar) {
        return [SChartBarSeries new];
    }
    return nil;
}

@end
