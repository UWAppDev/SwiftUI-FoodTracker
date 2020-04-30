//
//  ContentView.swift
//  FoodTracker
//
//  Created by Mobile Development Club on 4/30/20.
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import SwiftUI
import Introspect

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text("Meal Name")
            TextField("Enter meal name", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .introspectTextField { (textField) in
                    textField.returnKeyType = .done
                    textField.enablesReturnKeyAutomatically = true
            }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Set Default Label Text")
            }
            Spacer()
        }
        .padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
