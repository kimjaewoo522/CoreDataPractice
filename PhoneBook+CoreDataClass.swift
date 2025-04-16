//
//  PhoneBook+CoreDataClass.swift
//  CoreDataUserDefault
//
//  Created by 김재우 on 4/16/25.
//
//

import Foundation
import CoreData

@objc(PhoneBook)
public class PhoneBook: NSManagedObject {
    public static let className = "PhoneBook"
    public enum Key {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        //static 프로퍼티는 타입에 대해 호출할 수 있음
    }
}

// 이렇게 하는 이유 인스턴스 생성 없이 PhoneBook.className로 호출할 수 있다.
