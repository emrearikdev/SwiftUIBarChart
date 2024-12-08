//
//  BarChartData.swift
//  SwiftUIBarChart
//
//  Created by Emre ARIK on 8.12.2024.
//

import Foundation

struct BarChartData: Hashable, Identifiable {
    var id: UUID = UUID()
    let title: String
    let value: Double
}
