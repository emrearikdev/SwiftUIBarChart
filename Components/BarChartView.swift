//
//  BarChartView.swift
//  SwiftUIBarChart
//
//  Created by Emre ARIK on 8.12.2024.
//

import SwiftUI
import Charts

struct BarChartView<Data: Identifiable & Hashable>: View {
    let data: [Data]
    let xValueKeyPath: KeyPath<Data, String>
    let yValueKeyPath: KeyPath<Data, Double>
    let xAxisLabel: String
    let yAxisLabel: String
    let visibleLimit: Int
    
    @State private var chartContentContainerWidth: CGFloat = 0
    @State private var yAxisWidth: CGFloat = 0
    
    init(data: [Data],
         xValueKeyPath: KeyPath<Data, String>,
         yValueKeyPath: KeyPath<Data, Double>,
         xAxisLabel: String,
         yAxisLabel: String,
         visibleLimit: Int) {
        self.data = data
        self.xValueKeyPath = xValueKeyPath
        self.yValueKeyPath = yValueKeyPath
        self.xAxisLabel = xAxisLabel
        self.yAxisLabel = yAxisLabel
        self.visibleLimit = visibleLimit
        self.chartContentContainerWidth = chartContentContainerWidth
        self.yAxisWidth = yAxisWidth
    }
    
    var body: some View {
        VStack {
            mainView
        }
        .padding(.horizontal, 8)
    }
}

extension BarChartView {
    var mainView: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                // Y Axis Chart
                chartYAxis
                
                // Main Chart
                VStack(spacing: 0) {
                    chartContent
                }
                .clipped()
            }
        }
        .frame(height: 260)
    }
}

extension BarChartView {
    var chartYAxis: some View {
        Chart(data) { item in
            BarMark(
                x: .value(xAxisLabel, item[keyPath: xValueKeyPath]),
                y: .value(yAxisLabel, item[keyPath: yValueKeyPath]),
                width: .fixed(0)
            )
        }
        .chartYAxis {
            let strideValue = (yMax - yMin) == 0 ? 100 : (yMax - yMin) / 5
            AxisMarks(position: .leading, values: .stride(by: strideValue)) { value in
                if let yValue = value.as(Double.self), yValue >= 0 {
                    AxisGridLine(
                        stroke: StrokeStyle(lineWidth: 1, dash: [5, 3])
                    )
                    AxisValueLabel {
                        Text("\(yValue, specifier: "%.1f")")
                    }
                }
            }
        }
        .chartYScale(domain: max(0, yMin)...yMax)
        .chartPlotStyle { plot in
            plot
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 1)
                            .offset(x: 0, y: 0)
                    }
                )
                .frame(width: 0)
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(label)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .opacity(0)
                    }
                }
            }
        }
    }
    
    var chartContent: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack {
                    Chart(data) { item in
                        BarMark(
                            x: .value(xAxisLabel, item[keyPath: xValueKeyPath]),
                            y: .value(yAxisLabel, item[keyPath: yValueKeyPath]),
                            width: .fixed(20)
                        )
                        .annotation(position: .top) {
                            if !data.allSatisfy({ $0[keyPath: yValueKeyPath] == 0 }) {
                                Text("\(item[keyPath: yValueKeyPath], specifier: "%.1f")")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                            } else {
                                Text("\(0, specifier: "%.1f")")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .chartYScale(domain: yMin...yMax)
                    .chartYAxis {
                        let strideValue = (yMax - yMin) == 0 ? 100 : (yMax - yMin) / 5
                        AxisMarks(position: .leading, values: .stride(by: strideValue)) { value in
                            AxisGridLine(
                                stroke: StrokeStyle(lineWidth: 1, dash: [5, 3])
                            )
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            AxisValueLabel {
                                if let label = value.as(String.self) {
                                    Text(label)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .frame(minWidth: data.count > visibleLimit ? CGFloat(data.count) * 55 : UIScreen.main.bounds.width)
                    .frame(height: 260)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

extension BarChartView {
    private var yMin: Double {
        0
    }
    
    private var yMax: Double {
        let value = data.map { $0[keyPath: yValueKeyPath ]}.max() ?? 0
        return value == 0 ? 600 : value * 1.1
    }
}

#Preview {
    let data = [
        BarChartData(title: "Jan\n2024", value: 110),
        BarChartData(title: "Feb\n2024", value: 490),
        BarChartData(title: "Mar\n2024", value: 510),
        BarChartData(title: "Apr\n2024", value: 124),
        BarChartData(title: "May\n2024", value: 176),
        BarChartData(title: "Jun\n2024", value: 188),
        BarChartData(title: "Jul\n2024", value: 192)
    ]
    
    return BarChartView(data: data,
                 xValueKeyPath: \.title,
                 yValueKeyPath: \.value,
                 xAxisLabel: "Date",
                 yAxisLabel: "Value",
                 visibleLimit: 6)
}
