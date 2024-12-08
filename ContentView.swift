//
//  ContentView.swift
//  SwiftUIBarChart
//
//  Created by Emre ARIK on 8.12.2024.
//

import SwiftUI

struct ContentView: View {
    let data = [
        BarChartData(title: "Jan\n2024", value: 110),
        BarChartData(title: "Feb\n2024", value: 490),
        BarChartData(title: "Mar\n2024", value: 510),
        BarChartData(title: "Apr\n2024", value: 124),
        BarChartData(title: "May\n2024", value: 176),
        BarChartData(title: "Jun\n2024", value: 188),
        BarChartData(title: "Jul\n2024", value: 192),
        BarChartData(title: "Aug\n2024", value: 382),
        BarChartData(title: "Sep\n2024", value: 134),
        BarChartData(title: "Oct\n2024", value: 245),
        BarChartData(title: "Nov\n2024", value: 276),
        BarChartData(title: "Dec\n2024", value: 471)
    ]
        
    var body: some View {
        BarChartView(data: data,
                    xValueKeyPath: \.title,
                    yValueKeyPath: \.value,
                    xAxisLabel: "Date",
                    yAxisLabel: "Value",
                    visibleLimit: 6)
    }
}

#Preview {
    ContentView()
}
