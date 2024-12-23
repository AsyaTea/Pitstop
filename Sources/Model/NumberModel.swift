//
//  NumberModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import CoreData
import Foundation

struct NumberState: Hashable {
    var title: String = ""
    var telephone: String = ""
    var numberID: NSManagedObjectID?
}

struct NumberViewModel: Hashable {
    let number: Number

    var title: String {
        number.title ?? ""
    }

    var telephone: String {
        number.telephone ?? ""
    }

    var numberID: NSManagedObjectID {
        number.objectID
    }
}

extension NumberState {
    static func fromNumberViewModel(vm: NumberViewModel) -> NumberState {
        var numberS = NumberState()
        numberS.telephone = vm.telephone
        numberS.title = vm.title
        numberS.numberID = vm.numberID
        return numberS
    }
}
