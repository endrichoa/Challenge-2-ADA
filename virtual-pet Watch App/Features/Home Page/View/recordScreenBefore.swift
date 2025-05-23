//
//  recordScreenBefore.swift
//  virtual-pet Watch App
//
//  Created by Endricho Abednego on 21/05/25.
//


import SwiftUI

struct RecordScreenBeforeView: View {
    @State private var stepsRemaining: Int = 4833
    @State private var progress: Double = 0.65 // Example progress (0.0 to 1.0)
    @State private var navigateToWorkout = false
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("home-background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer().frame(height: 24)
                    Text("READY TO WALK?")
                        .font(.custom("dogica pixel", size: 20))
                        .kerning(-2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#1A0F23"))
                        .padding(.bottom, 6)
                        .padding(.horizontal, 8)
                    Text("TOUCH TO RECORD")
                        .font(.custom("dogica", size: 14))
                        .kerning(-2)
                        .foregroundColor(Color(hex: "#1A0F23"))
                        .padding(.bottom, 18)
                        .padding(.horizontal, 8)
                    Spacer()
                    Image("dogChar")
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 90, height: 45)
                        .padding(.bottom, 24)
                    Text("4,833 STEPS REMAINING")
                        .font(.custom("dogica", size: 10))
                        .lineLimit(1)
                        .foregroundColor(Color(hex: "#1A0F23"))
                        .padding(.bottom, 8)
                        .padding(.horizontal, 8)
                        .kerning(-2)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 0.33, green: 0.18, blue: 0.13), lineWidth: 3)
                            .frame(height: 14)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.33, green: 0.18, blue: 0.13))
                            .frame(width: CGFloat(progress) * 140, height: 14)
                    }
                    .frame(width: 140, height: 14)
                    .padding(.bottom, 24)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    showConfirmation = true
                }
                .confirmationDialog("Start your walk?", isPresented: $showConfirmation, titleVisibility: .visible) {
                    Button("Start", role: .none) {
                        navigateToWorkout = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
                NavigationLink(destination: StartWorkoutView(), isActive: $navigateToWorkout) {
                    EmptyView()
                }
                .opacity(0)
            }
        }
    }
}

struct StatusBar: View {
    let value: Double
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.system(size: 15))
            ProgressView(value: value)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 4)
        }
        .position(x: 45, y: 130)
    }
}

struct ActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: systemImage)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(size: 10))
            }
            .padding(4)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

#Preview {
    RecordScreenBeforeView()
}
