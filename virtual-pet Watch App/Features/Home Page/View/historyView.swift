//
//  historyView.swift
//  virtual-pet Watch App
//
//  Created by Endricho Abednego on 22/05/25.
//

import SwiftUI

struct HistoryView: View {
    // Placeholder/mock data for now
    let currentStreak = 9
    let goalsReached = 17
    let avgSteps = 8972
    // Each tuple is (date, steps)
    let weeklyData: [(date: String, steps: Int)] = [
        ("01/05", 5000), ("03/05", 7000), ("05/05", 8000), ("07/05", 12000), ("09/05", 6000), ("11/05", 9000), ("13/05", 11000)
    ]
    var maxSteps: Int { weeklyData.map { $0.steps }.max() ?? 1 }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Spacer().frame(height: 8)
                // Title
                Text("YOUR HISTORY")
                    .font(.custom("dogica", size: 20))
                    .foregroundColor(Color(hex: "#DE1A1B"))
                    .padding(.bottom, 8)
                // Streaks and Goals
                HStack {
                    VStack {
                        Text("\(currentStreak)")
                            .font(.custom("dogica", size: 24))
                            .foregroundColor(Color(hex: "#DE1A1B"))
                        Text("current\nstreak")
                            .font(.custom("dogica", size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Text("\(goalsReached)")
                            .font(.custom("dogica", size: 24))
                            .foregroundColor(Color(hex: "#DE1A1B"))
                        Text("goals reached\nthis month")
                            .font(.custom("dogica", size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 8)
                // Average Steps
                Text("\(avgSteps) avg steps")
                    .font(.custom("dogica", size: 16))
                    .foregroundColor(Color(hex: "#DE1A1B"))
                    .padding(.bottom, 4)
                // Weekly Chart
                ChartView(data: weeklyData, maxSteps: maxSteps)
                    .frame(height: 90)
                    .padding(.horizontal, 8)
                Spacer()
            }
            .padding()
        }
    }
}

// Simple line chart for weekly steps
struct ChartView: View {
    let data: [(date: String, steps: Int)]
    let maxSteps: Int
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let pointSpacing = width / CGFloat(max(data.count - 1, 1))
            let stepPoints = data.enumerated().map { idx, entry in
                CGPoint(x: CGFloat(idx) * pointSpacing, y: height - (CGFloat(entry.steps) / CGFloat(maxSteps)) * height)
            }
            ZStack {
                // Chart line
                Path { path in
                    guard let first = stepPoints.first else { return }
                    path.move(to: first)
                    for pt in stepPoints.dropFirst() {
                        path.addLine(to: pt)
                    }
                }
                .stroke(Color(hex: "#DE1A1B"), lineWidth: 2)
                // Chart points
                ForEach(stepPoints.indices, id: \.self) { idx in
                    let pt = stepPoints[idx]
                    Circle()
                        .fill(Color(hex: "#DE1A1B"))
                        .frame(width: 6, height: 6)
                        .position(pt)
                }
                // Y-axis labels
                VStack {
                    Text("\(maxSteps, specifier: "%.0f")")
                        .font(.custom("dogica", size: 10))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("0")
                        .font(.custom("dogica", size: 10))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                // X-axis labels (dates)
                HStack {
                    ForEach(data.indices, id: \.self) { idx in
                        Text(data[idx].date)
                            .font(.custom("dogica", size: 10))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

#Preview {
    HistoryView()
}
