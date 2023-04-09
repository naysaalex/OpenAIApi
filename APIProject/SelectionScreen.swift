//
//  SelectionScreen.swift
//  APIProject
//
//  Created by cashamirica on 4/9/23.
//

import SwiftUI

struct SelectionScreen: View {
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Text("Click the button you would like to use")
                //Spacer()
                NavigationLink(destination: ImageGenerator()) {
                    Text("Image Generator")
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(Color.black)
                        .cornerRadius(15)
                }
                //Spacer()
                NavigationLink(destination: TextGenerator()) {
                    Text("Text Generator")
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(Color.black)
                        .cornerRadius(15)
                }
                //Spacer()
                NavigationLink(destination: Sentiment()) {
                    Text("Sentiment Reader")
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(Color.black)
                        .cornerRadius(15)
                }
                Spacer()
            }
        }
    }
}

struct SelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectionScreen()
    }
}
