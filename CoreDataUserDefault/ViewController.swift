import UIKit
import CoreData

class ViewController: UIViewController {

    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        createData(name: "Adam", phoneNumber: "010-1111-2222")
        
        readAllData()
        
        UpdateData(currentName: "Adam", updateName: "Abel")
        
        readAllData()
        
        deleteData(name: "Abel")
        
        readAllData()
    }

    // AdamCoreData 에 데이터 Create.
    func createData(name: String, phoneNumber: String) {
        // NSEntityDescription.entity는 entity를 새롭게 하나 정의 하겠다  // container.viewContext= container의 맥락에
        guard let entity = NSEntityDescription.entity(forEntityName: PhoneBook.className, in: self.container.viewContext) else { return }
        // 새롭게 저장할 PhoneBook entity를 생성 // NSManagedObject는 coredata에서 관리하는 객체
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        // newPhoneBook에 attribute(속성)을 지정
        // name에 phoneBook에 저장한 "name"에 저장 하겠다
        newPhoneBook.setValue(name, forKey: PhoneBook.Key.name)
        newPhoneBook.setValue(phoneNumber, forKey: PhoneBook.Key.phoneNumber)
        
        // self.container.viewContext.save() 가 throwable한 메서드이기 때문에 do-try-catch문 작성
        do {
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch {
            print("문맥 저장 실패")
        }
    }
    
    // AdamCoreData 에서 데이터 Read.
    func readAllData() {
        do {                                    // fetchRequest는 데이터 접근하는데 도움을 주는 메서드
            let phoneBooks = try self.container.viewContext.fetch(PhoneBook.fetchRequest())
            // [NSManagedobject]로 타입 캐스팅한 이유 NSmanagedobject가 가지고있는 key를 사용하기위해
            // key는 PhoneBook+CoreDataProperties가 가지고있는 것
            for phoneBook in phoneBooks as [NSManagedObject] {
                if let name = phoneBook.value(forKey: PhoneBook.Key.name) as? String,
                   let phoneNumber = phoneBook.value(forKey: PhoneBook.Key.phoneNumber) as? String {
                    print("name: \(name), phoneNumber: \(phoneNumber)")
                }
            }
            
        } catch {
            print("데이터 읽기 실패")
        }
    }
    
    // CoreDataUserDefault에서 데이터 Name Update
    // currentName: 현재 데이터 베이스에 저장되어있는 name을 어떤 name으로 업데이트 할껀지
    func UpdateData(currentName: String, updateName: String) {
        // PhoneBook에 있는 데이터를 조회
        let fetchRequest = PhoneBook.fetchRequest()
        // predicate(조건문) name이 currentName인 데이터를 찾는다
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                //data중 name의 값을 updteName 으로 update 한다
                data.setValue(updateName, forKey: PhoneBook.Key.name)
            }
            
            try self.container.viewContext.save()
            
            print("데이터 수정 성공")
       } catch {
           print("데이터 수정 실패")
        }
    }
    // CoreDataUserDefault에서 데이터 Delete
    func deleteData(name: String) {
        
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            
            try self.container.viewContext.save()
            
            print("데이터 삭제 성공")
            
        } catch {
            print("데이터 삭제 실패")
        }
    }
    
}

