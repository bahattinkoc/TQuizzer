//
//  Array+Extension.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 24.03.2024.
//

extension Array {
    func get(at index: Index?) -> Iterator.Element? {
        guard let index, index >= startIndex, index < endIndex else { return nil }
        return self[index]
    }
}
