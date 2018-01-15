import UIKit
import RxSwift

func exampleName(_ name:String) {
    print("\n-------\(name)-----------\n")
}

enum AppError : Error {
    case SimpleError
}

let bag = DisposeBag()

//ignoreElements
exampleName("Ignore Elements")

PublishSubject<String>.create { (observer) -> Disposable in
    observer.onNext("India")
    observer.onError(AppError.SimpleError) // or observer.onCompleted()
    return Disposables.create()
}
    .ignoreElements() // the return value is completeable Traits. It ignores all the elements, so it is Completable. either success or error(_:)
    .subscribe(onCompleted:{print("completed")},onError:{print($0)})
    .disposed(by: bag)

exampleName("Element At")

PublishSubject<String>.create { (observer) -> Disposable in
    observer.onNext("Swift")
    observer.on(Event.next("RxSwift"))
    return Disposables.create()
}
    .elementAt(1) // pick the elements at speciified position.
    .subscribe(onNext:{print($0)},onError:{print($0)})
    .disposed(by: bag)

exampleName("Filter")

PublishSubject<String>.create { (observer) -> Disposable in
    observer.onNext("Swift")
    observer.onNext("ExSwift")
    observer.onNext("objective-c")
    return Disposables.create()
}
    .filter({$0.hasSuffix("Swift")}) // if it true, then it will let through otherwise it will skip it.
    .subscribe(onNext:{print($0)})

exampleName("Skip")

PublishSubject<String>.create { (observer) -> Disposable in
    observer.onNext("Java")
    observer.onNext("Swift")
    observer.onNext("RxSwift")
    return Disposables.create()
}
    .skip(2) // it will skip the count mentioned in the skip. here it will skip 2 event.
    .subscribe(onNext:{print($0)},onError:{print($0)})

exampleName("Skip While")

PublishSubject<String>.create { (observer) -> Disposable in
    observer.onNext("Swift")
    observer.onNext("C")
    observer.onNext("Java")
    observer.onNext("RxSwift")
    return Disposables.create()
}
    .skipWhile { $0.hasSuffix("Swift") }// skip the element if it is true. Whenver it is false, then it will let through all the elements from then.
    .subscribe(onNext:{print($0)})

exampleName("Skip Until")

let skipUntilTrigger = PublishSubject<String>()
let skipUntilSubject = PublishSubject<String>()
skipUntilSubject.onNext("Java")
skipUntilSubject.skipUntil(skipUntilTrigger).subscribe(onNext:{print($0)}) // skip the events until the trigger observable emits the events
skipUntilTrigger.onNext("Triggered")
skipUntilSubject.onNext("RxSwift")

exampleName("Take")

PublishSubject<String>.create { (observer) -> Disposable in
    observer.onNext("Swift")
    observer.onNext("RxSwift")
    observer.onNext("Objective-C")
    return Disposables.create()
}
    .skip(1)
    .take(1)
    .subscribe(onNext:{print($0)})

exampleName("Distinct")

let distinctSubject = PublishSubject<String>()
distinctSubject
    .distinctUntilChanged()
    .subscribe(onNext:{print($0)})
distinctSubject.onNext("Swift")
distinctSubject.onNext("Swift")
distinctSubject.onNext("RxSwift")
distinctSubject.onNext("Swift")
distinctSubject.onNext("Swift")


