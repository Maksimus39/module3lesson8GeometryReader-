import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    func getNews(){ print("1: onAppear") }
} // <- old variant

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel() // <- old variant
    
    var body: some View {
        NavigationStack {  // ← NavigationStack на верхнем уровне
            VStack {
                NavigationLink("Second Page", destination: SecondPage())
                    .onAppear{
                        print("2: onAppear")
                    }
            }
            .padding()
            .onAppear {
                viewModel.getNews()
            }
        }
    }
}

struct SecondPage: View {
    var body: some View {
        VStack{
            Text("Second Page")
            
        }
        .onAppear{
            print("3: onAppear")
        }
    }
}



#Preview {
    ContentView()
}
