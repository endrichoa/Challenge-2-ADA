//
//  historyView.swift
//  virtual-pet Watch App
//
//  Created by Endricho Abednego on 22/05/25.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var vm: HistoryViewModel
    var dailyGoal: Int
    
    var body: some View {
        ZStack {
            Color(hex: "#2e2c3d").ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: 8)
                    // Title
                    Text("REPORT")
                        .font(.custom("Dogica Pixel", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    // Streaks and Goals
                    HStack(alignment: .top) {
                        VStack(spacing: 2) {
                            Text("\(vm.currentStreak)")
                                .font(.custom("Dogica Pixel", size: 28))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("CURRENT\nSTREAK")
                                .font(.custom("Dogica Pixel", size: 10))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        VStack(spacing: 2) {
                            Text("\(vm.goalsReached)")
                                .font(.custom("Dogica Pixel", size: 28))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("GOALS\nTHIS MONTH")
                                .font(.custom("Dogica Pixel", size: 10))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    HStack(spacing: 8) {
                        Text("AVG. STEPS")
                            .font(.custom("Dogica Pixel", size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .kerning(1)
                        Text("\(vm.avgSteps.formatted())")
                            .font(.custom("Dogica Pixel", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .kerning(1)
                    }
                    // Weekly Chart
                    ChartView(data: vm.weeklyData, maxSteps: vm.weeklyData.map{$0.steps}.max() ?? 1)
                        .frame(height: 90)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            HealthKitHelper.shared.fetchStepsForLast7Days { days in
                DispatchQueue.main.async {
                    vm.updateData(dailyGoal: dailyGoal, last7Days: days)
                }
            }
        }
    }
}

struct ChartView: View {
    let data: [(date: String, steps: Int)]
    let maxSteps: Int
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let pointSpacing = width / CGFloat(max(data.count - 1, 1))
                let yTicks: [CGFloat] = [0, 0.666, 1.0] // 0, 4k, 6k (normalized)
                let yLabels: [String] = ["0", "4.000", "6.000"]
                let yMax: CGFloat = max(CGFloat(maxSteps), 6000)
                let stepPoints = data.enumerated().map { idx, entry in
                    CGPoint(
                        x: CGFloat(idx) * pointSpacing,
                        y: height - (CGFloat(entry.steps) / yMax) * height
                    )
                }
                ZStack {
                    // Chart box
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(hex: "#FDFEFE").opacity(0.3), lineWidth: 1)
                    // Grid lines
                    ForEach(0..<yTicks.count, id: \ .self) { i in
                        let y = height - yTicks[i] * height
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: width, y: y))
                        }
                        .stroke(Color(hex: "#FDFEFE").opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    }
                    ForEach(data.indices, id: \ .self) { i in
                        let x = CGFloat(i) * pointSpacing
                        Path { path in
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: height))
                        }
                        .stroke(Color(hex: "#FDFEFE").opacity(0.1), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    }
                    // White line
                    Path { path in
                        guard let first = stepPoints.first else { return }
                        path.move(to: first)
                        for pt in stepPoints.dropFirst() {
                            path.addLine(to: pt)
                        }
                    }
                    .stroke(Color(hex: "#FDFEFE"), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                    // White dots
                    ForEach(stepPoints.indices, id: \ .self) { idx in
                        let pt = stepPoints[idx]
                        Circle()
                            .fill(Color(hex: "#FDFEFE"))
                            .frame(width: 6, height: 6)
                            .position(pt)
                    }
                    // Y-axis labels (right, outside)
                    VStack {
                        ForEach(yTicks.indices.reversed(), id: \ .self) { i in
                            Spacer(minLength: i == yTicks.count-1 ? 0 : nil)
                            Text(yLabels[i])
                                .font(.custom("Dogica Pixel", size: 10))
                                .foregroundColor(Color(hex: "#FDFEFE").opacity(0.7))
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                    .frame(width: width + 40, height: height, alignment: .trailing)
                }
            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            HStack(spacing: 0) {
                ForEach(data.indices, id: \ .self) { idx in
                    let weekdayInitial = weekdayInitialFromDateString(data[idx].date)
                    Text(weekdayInitial)
                        .font(.custom("Dogica Pixel", size: 12))
                        .foregroundColor(Color(hex: "#FDFEFE"))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 2)
            .frame(maxWidth: .infinity)
        }
    }
    func weekdayInitialFromDateString(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        if let date = formatter.date(from: dateString) {
            let calendar = Calendar.current
            var symbols = calendar.shortWeekdaySymbols
            let firstWeekday = calendar.firstWeekday
            if firstWeekday != 2 {
                symbols.append(symbols.removeFirst())
            }
            let weekday = calendar.component(.weekday, from: date)
            let index = (weekday + 5) % 7
            let initial = symbols[index].prefix(1)
            return String(initial)
        }
        return "?"
    }
}

#Preview {
    let today = Date()
    let calendar = Calendar.current
    let mockData = (0..<7).map { i in
        StepDay(date: calendar.date(byAdding: .day, value: -i, to: today)!, steps: Int.random(in: 4000...12000))
    }.reversed()
    HistoryView(vm: HistoryViewModel(dailyGoal: 8000, last7Days: Array(mockData)), dailyGoal: 8000)
}
