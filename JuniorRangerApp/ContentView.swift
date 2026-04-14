import SwiftUI
import UIKit

enum AppScreen {
    case home
    case mission
    case completed
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .home
    @State private var selectedImage: Image?
    @State private var isLoading = false

    @State private var showImagePicker = false
    @State private var showSourceDialog = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        VStack {
            switch currentScreen {
            case .home:
                homeView
            case .mission:
                missionView
            case .completed:
                completedView
            }
        }
        .padding()
    }

    var homeView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Junior Ranger App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Button("Welcome") {
                currentScreen = .mission
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
    }

    var missionView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "camera.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)

            Text("Take a photo of a recycling bottle")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text("Complete this mission by taking or selecting a photo.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 220)
                    .overlay(
                        VStack(spacing: 10) {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No image selected")
                                .foregroundColor(.secondary)
                        }
                    )
            }

            Button {
                showSourceDialog = true
            } label: {
                Label("Take / Select Photo", systemImage: "camera")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .confirmationDialog("Choose Image Source", isPresented: $showSourceDialog, titleVisibility: .visible) {
                Button("Take Photo") {
                    imageSource = .camera
                    showImagePicker = true
                }

                Button("Choose from Library") {
                    imageSource = .photoLibrary
                    showImagePicker = true
                }

                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: imageSource) { image in
                    selectedImage = Image(uiImage: image)

                    Task {
                        isLoading = true
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        isLoading = false
                        currentScreen = .completed
                    }
                }
            }

            if isLoading {
                ProgressView("Checking mission...")
            }

            Spacer()
        }
    }

    var completedView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 90))
                .foregroundColor(.green)

            Text("Mission Completed")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Great job! You completed the recycling bottle mission.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Back to Home") {
                selectedImage = nil
                isLoading = false
                currentScreen = .home
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
