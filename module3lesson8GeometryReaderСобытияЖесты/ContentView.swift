import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    func getNews(){ print("1: onAppear") }
    func vpnOn(isOn: Bool){print(isOn)}
} // <- old variant

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel() // <- old variant
    @State var name: String = ""
    @State var searchText = ""
    @State var isOn: Bool = false
    @State var opacity: CGFloat = 0
    @State private var tappedItem: Int? = nil  // Храним индекс нажатой ячейки
    @State var point: CGPoint = .zero
    
    var body: some View {
        NavigationStack {  // ← NavigationStack на верхнем уровне
            ZStack(alignment: .top) {
                HStack {
                    Text("Header")
                        .padding()
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .background(.blue)
                .zIndex(1)
                .opacity(opacity)
                
                ScrollView {
                    //                VStack(alignment: .center, spacing: 10) {
                    //                    NavigationLink("Second Page", destination: SecondPage())
                    //                    TextField("user name", text: $name)
                    //                        .onSubmit({
                    //                            print(name)
                    //                        })
                    //                        .onAppear{
                    //                            print("2: onAppear")
                    //                        }
                    //
                    //                    Toggle(isOn: $isOn) {
                    //                        Text("Toggle")
                    //                    }
                    //                    .onChange(of: isOn) { newValue  in
                    //                        viewModel.vpnOn(isOn: newValue)
                    //                    }
                    //                }
                    //                .padding()
                    //                .onAppear {
                    //                    viewModel.getNews()
                    //                }
                    
                    VStack {
                        GeometryReader { proxy in
                            let minY = proxy.frame(in: .global).minY
                            Image(.banner)
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width)
                                .frame(height: 300 + (minY > 0 ? minY : 0))
                                .offset(y: -minY < 0 ? -minY : 0)
                                .onChange(of: minY) { _, newValue in
                                    withAnimation {
                                        opacity = -minY / 200
                                    }
                                }
                        }
                        .frame(height: 300)
                        
                        Circle()
                            .frame(width: 75, height: 75)
                            .offset(x: point.x, y: point.y)
                            .gesture(
                                DragGesture()
                                    .onChanged({ g in
                                        withAnimation {
                                            print(g.location)
                                            point = g.location
                                        }
                                    })
                                    .onEnded({ g in
                                        withAnimation {
                                            print(g.location)
                                            point = .zero
                                        }
                                    })
                            )
                            .zIndex(2)
                        
                        VStack{
                            ForEach(0...30, id: \.self){ item in
                                Rectangle()
                                    .frame(height: 50)
                                    .cornerRadius(10)
                                    .foregroundStyle(tappedItem == item ? .green : .orange.opacity(0.9))  // Меняем цвет
                                    .overlay {
                                        Text("\(item)")
                                    }
                                    .gesture(
                                        TapGesture()
                                            .onEnded({ _ in
                                                print(item)
                                            })
                                    )
                                
                                    .onTapGesture {
                                        tappedItem = item  // Запоминаем какой элемент нажали
                                        print(item)
                                        //
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            tappedItem = nil
                                        }
                                    }
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
            
            //            .refreshable(action: {
            //                print("refreshable")
            //            })
            
            //            .searchable(text: $searchText)
            //            .onSubmit(of: .search){
            //                print(searchText)
            //            }
        }
    }
}

//struct SecondPage: View {
//    var body: some View {
//        VStack{
//            Text("Second Page")
//
//        }
//        .onAppear{
//            print("3: onAppear")
//        }
//        // viewDidDisappear
//        .onDisappear{
//            print("4: onDisappear")
//        }
//    }
//}



#Preview {
    ContentView()
}
