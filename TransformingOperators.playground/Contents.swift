//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

var button:UIButton
func exampleName(_ name:String) {
    print("\n-------\(name)-----------\n")
}

let bag = DisposeBag()

exampleName("toArray")

Observable.of(1,2,3,4,5)
    .toArray()
    .subscribe(onNext:{print($0)})

exampleName("Map")
PublishSubject<Int>.create { (observer) -> Disposable in
    observer.onNext(10)
    observer.onNext(20)
    return Disposables.create()
}
 .enumerated()
 .map({ $0 == 0 ? $1 : $0 * $1 })
 .subscribe(onNext:{print($0)})

exampleName("FlatMap - Tranforming Inner Observables")

struct Student {
    var score : BehaviorSubject<Int>
}

let subject = PublishSubject<Student>()
subject
    .flatMap( { (student) in student.score })
    .subscribe(onNext:{print($0)})

let student1 = Student(score: BehaviorSubject<Int>(value:10))
let student2 = Student(score: BehaviorSubject<Int>(value:20))

subject.onNext(student1)
subject.onNext(student2)

student1.score.onNext(100)
student2.score.onNext(200)

exampleName("FlatMap Latest")

let latestSubject = PublishSubject<Student>()
latestSubject
    .flatMapLatest( { (student) in student.score })
    .subscribe(onNext:{print($0)})

let student3 = Student(score: BehaviorSubject<Int>(value:10))
let student4 = Student(score: BehaviorSubject<Int>(value:20))

latestSubject.onNext(student3)
latestSubject.onNext(student4)

student3.score.onNext(100) // it is not going to emit, if we use the flatMapLatest
student4.score.onNext(200)

// flatmap


let a = ["1","2","3","4","5"]

struct Emp {
    var empNumber:Int
    init? (value:String) {
        if let v1 = Int(value) {
            self.empNumber = v1
            return
        }
        return nil
    }
}

let b = a.flatMap{Emp.init(value: $0)}
print(b)

