//
//  DocumentView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-08.
//

import SwiftUI

struct DocumentView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 12)
                Text("Back")
                Spacer()
            }
            .onTapGesture {
                isPresented = false
            }
            .padding([.leading, .trailing], 20)
            DocumentPDFView(url: Bundle.main.url(forResource: "-O9-mNJolBCjdEXdTQWI", withExtension: "pdf")!)
                .navigationTitle("Book")
        }
    }
}

//#Preview {
//    DocumentView()
//}
