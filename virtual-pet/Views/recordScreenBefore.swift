import SwiftUI

struct VirtualPetView: View {
    @State private var petHappiness: Double = 0.5
    @State private var petEnergy: Double = 0.5
    @State private var isShowingActionSheet = false
    
    var body: some View {
        ZStack {
            // Background
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                // Pet Status
                HStack(spacing: 4) {
                    StatusBar(value: petHappiness, label: "Happy")
                    StatusBar(value: petEnergy, label: "Energy")
                }
                .padding(.horizontal, 4)
                
                // Pet Image
                Image("pet_placeholder") // Replace with your pet asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
                
                // Action Buttons
                HStack(spacing: 8) {
                    ActionButton(title: "Feed", systemImage: "fork.knife") {
                        petEnergy = min(petEnergy + 0.2, 1.0)
                    }
                    
                    ActionButton(title: "Play", systemImage: "gamecontroller") {
                        petHappiness = min(petHappiness + 0.2, 1.0)
                        petEnergy = max(petEnergy - 0.1, 0.0)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
            ActionSheet(
                title: Text("Pet Actions"),
                buttons: [
                    .default(Text("Pet")) {
                        petHappiness = min(petHappiness + 0.1, 1.0)
                    },
                    .default(Text("Next Screen")) {
                        // Add navigation action here
                    },
                    .cancel()
                ]
            )
        }
    }
}

// Status Bar Component
struct StatusBar: View {
    let value: Double
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 10))
            ProgressView(value: value)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 4)
        }
    }
}

// Action Button Component
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
    VirtualPetView()
} 