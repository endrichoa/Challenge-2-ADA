//
//  WeeklyStepsChart.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 01/06/25.
//

import Charts
import SwiftUI

struct WeeklyStepsChart: View {
    @Binding var stepData: [StepModel]?
    
    var body: some View {
        if stepData == nil {
            Text("No data available")
        }
        Chart(stepData ?? []) { item in
            LineMark(
                x: .value("Day", item.date, unit: .day),
                y: .value("Steps", item.stepCount)
            )
            PointMark(
                x: .value("Day", item.date, unit: .day),
                y: .value("Steps", item.stepCount)
            )
        }
        .foregroundStyle(Color("AppWhite"))
        .chartXAxis {
            AxisMarks { _ in
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisTick()
                AxisValueLabel {
                    if let y = value.as(Int.self) {
                        Text("\(y)")
                            .font(.custom("Dogica Pixel", size: 8, relativeTo: .caption))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("AppWhite"))
                    }
                }
            }
        }
        .padding()
        .chartOverlay { proxy in
            GeometryReader { geo in
                if let plotFrameAnchor = proxy.plotFrame {
                    let plotFrame = geo[plotFrameAnchor]
                    Rectangle()
                        .stroke(Color("AppWhite"), lineWidth: 2)
                        .frame(width: plotFrame.width, height: plotFrame.height)
                        .position(x: plotFrame.midX, y: plotFrame.midY)
                }
            }
        }
    }
}

#Preview {
    WeeklyStepsChart(stepData: .constant(StepModel.sampleData))
        .background(Color("AppBlack"))
}
