//
//  HomeView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI
import PhotosUI
import Combine
import Foundation


struct HomeView: View {
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 11)
    ]
    
    let items = [
        ("Item 1", Color.blue),
        ("Item 2", Color.green),
        ("Item 3", Color.orange),
        ("Item 4", Color.purple)
    ]
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack {
                VStack{
                    HStack{
                        
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height * 0.1
                    )
                    VStack{
                        HStack{
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            .cornerRadius(40, corners: [.topLeft])
                            
                            ZStack {
                              
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            .cornerRadius(40, corners: [.topRight])
                        }
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height * 0.3
                    )
                    VStack{
                        HStack{
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            .clipShape(Circle())
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                        }
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height * 0.3
                    )
                    VStack{
                        HStack{
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            .cornerRadius(40, corners: [.bottomLeft])
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            ZStack{
                                
                            }
                            .frame(
                                width: geoProxy.size.width * 0.3,
                                height: geoProxy.size.height * 0.25
                            )
                            .background(.gray)
                            .cornerRadius(40, corners: [.bottomRight])
                        }
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height * 0.3
                    )
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: .constant(""), prompt: "Search Anything")
            }
        }
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// ViewModifier for rounding specific corners
struct CornerRadiusModifier: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// View extension for easy usage
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        modifier(CornerRadiusModifier(radius: radius, corners: corners))
    }
}


#Preview {
    HomeView()
}
