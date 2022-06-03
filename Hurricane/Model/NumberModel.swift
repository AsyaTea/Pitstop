//
//  NumberModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import Foundation
import CoreData

struct NumberState: Hashable {
    var title: String = ""
    var telephone: String = ""
}

struct NumberViewModel : Hashable {
    let number: Number
    
    var title: String {
        return number.title ?? ""
    }
    
    var telephone: String {
        return number.telephone ?? ""
    }
}

extension NumberState {
    
    static func fromNumberViewModel(vm:NumberViewModel ) -> NumberState{
        var numberS = NumberState()
        numberS.telephone = vm.telephone
        numberS.title = vm.title
        return numberS
    }
        
}
