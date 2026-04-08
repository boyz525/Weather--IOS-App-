//
//  InfoStackView.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation
import SwiftUI

struct GroupCellView: View {
    @State var vm = SearchViewModel()
    var body: some View {
        VStack{
            ForEach(vm.searchRes) { city in
                CityCellView(city: city)
            }
        }
    }
}


#Preview {
    GroupCellView()
}
