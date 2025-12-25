//
//  SearchView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI

struct SearchView: View {
    
    @State private var searchText : String = ""
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack{
                ScrollView(.vertical){
                    VStack{
                        ForEach(1...10,id: \.self){int in
                            postComponent(geoProxy: geoProxy)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search something" )
                    .navigationTitle("Search")
                }
            }
        }
    }
}

private func postComponent(geoProxy : GeometryProxy) -> some View {
    HStack{
        VStack{
            ZStack{
                
            }
            .frame(
                width: geoProxy.size.width * 0.8,
                height: geoProxy.size.height * 0.25
            )
            .background(.gray.opacity(0.3))
            HStack{
                Text("Buraya ne yazılacak okuyamadım ama böyle bir alan var")
            }
        }
        VStack{
            Spacer()
            Button {} label: {
                Image(systemName: "gear")
            }
            Spacer()
            Button {} label: {
                Image(systemName: "heart")
            }
            Spacer()
            Button {} label: {
                Image(systemName: "archivebox")
            }
            Spacer()
            Button {} label: {
                Image(systemName: "trash")
            }
            Spacer()
        }
        .frame(
            height: geoProxy.size.height * 0.3
        )
    }
    .padding()
    .frame(
        width: geoProxy.size.width,
        height: geoProxy.size.height * 0.35
    )
    .background(.gray.opacity(0.2))
}


#Preview {
    SearchView()
}
