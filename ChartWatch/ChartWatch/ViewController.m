//
//  ViewController.m
//  ChartWatch
//
//  Created by Chris Grant on 21/11/2014.
//  Copyright (c) 2014 Scott Logic Ltd. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiCharts.h>
#import <ShinobiCharts/ShinobiCharts.h>
#import <ShinobiCharts/SChartCanvas.h>
#import <ShinobiCharts/SChartGLView.h>
//#import "SChartGLView+Screenshot.h"

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
    
    self.chart = [[ShinobiChart alloc] initWithFrame:CGRectMake(0, 300, 300, 300)];
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
    if (self.chartType != ChartTypeLine) {
        self.chartType = ChartTypeLine;
        [self screenshot];
    }
}

- (IBAction)generateColumnChartTapped:(UIButton *)sender {
    if (self.chartType != ChartTypeColumn) {
        self.chartType = ChartTypeColumn;
        [self screenshot];
    }
}

- (IBAction)generateBarChartTapped:(UIButton *)sender {
    if (self.chartType != ChartTypeBar) {
        self.chartType = ChartTypeBar;
        [self screenshot];
    }
}

- (void)screenshot {
    [self.chart reloadData];
    [self.chart redrawChart];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
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
