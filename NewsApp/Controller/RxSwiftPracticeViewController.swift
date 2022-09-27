//
//  RxSwiftPracticeViewController.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 25/09/2022.
//

import UIKit
import RxSwift

class RxSwiftPracticeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       playSkipUntil()
        // Do any additional setup after loading the view.
    }
    
}

extension RxSwiftPracticeViewController
{
    private func playCustomObservable()
    {
        let dummyObjectObservable = Observable<DummyObjects>.create{
            $0.onNext(DummyObjects(name: "🐶", tag: .simpleTag(tag: "Simple Tag")))
            $0.onNext(DummyObjects(name: "🦄", tag: .advanceTag(tag: "Advance Tag", advanceTag: "AdvTag")))
            return Disposables.create()
        }
        
        let firstObserver = dummyObjectObservable.subscribe {
            debugPrint("Printed Name : \($0.element?.getName() ?? "") and event \($0)")
        }
        
        let secondObserver = dummyObjectObservable.subscribe({
            debugPrint("Printed : \($0.element?.getName() ?? "") and event \($0)")
        }
        )
        
        firstObserver.disposed(by: self.disposeBag)
        secondObserver.disposed(by: self.disposeBag)
    }
    
    private func playDeferedObservable()
    {
        
        let deferedObservable = Observable<String>.deferred {
            return Observable.create {
                $0.onNext("🐔")
                return Disposables.create()
            }
        }
        
        let firstObserver = deferedObservable.subscribe { event in
            debugPrint(event.element!)
        }
        
        let secondObserver = deferedObservable.subscribe { event in
            debugPrint(event.element!)
        }
        
        firstObserver.disposed(by: self.disposeBag)
        secondObserver.disposed(by: self.disposeBag)
    }
    
    private func playPublisherSubject()
    {
        let subject = PublishSubject<String>()
        
        let firstSubscriber = subject.subscribe {
            debugPrint("Printed : \($0.element ?? "") and event \($0)")
        }
        
        subject.onNext("🐡")
        subject.onNext("🐠")
        subject.onNext("🦞")
        
        firstSubscriber.disposed(by: self.disposeBag)
        
        let secondSubscriber = subject.subscribe {
            debugPrint("Printed : \($0.element ?? "") and event \($0)")
        }
        
        subject.onNext("🐬")
        
        secondSubscriber.disposed(by: self.disposeBag)
    }
    
    private func playReplaySubject()
    {
        let replaySubject = ReplaySubject<String>.create(bufferSize: 1)
        
        let firstSubscriber = replaySubject.subscribe {
            guard let data = $0.element else {
                return
            }
            
            debugPrint("The data is \(data)")
        }
        
        replaySubject.on(.next("🦅"))
        replaySubject.on(.next("🦖"))
        
        firstSubscriber.disposed(by: self.disposeBag)
        
        let secondSubscriber = replaySubject.subscribe {
            if $0.isCompleted {
                debugPrint("Completed 🐏")
            } else {
                debugPrint("33🐿 It's not completed yet \($0.element ?? "")")
            }
        }
        
        replaySubject.on(.next("🐕"))
        replaySubject.on(.completed)
        
        secondSubscriber.disposed(by: self.disposeBag)
        
        let thirdSubscriber = replaySubject.subscribe {
            
            switch $0
            {
                case.next(let data): debugPrint("\(data) is returned")
                case.error(let error):debugPrint(error.localizedDescription)
                case.completed:debugPrint("Completed")
            }
            
        }
        
        replaySubject.on(.next("🐳"))
        replaySubject.on(.next("🐋"))
        replaySubject.on(.next("🐁"))
        replaySubject.onCompleted()
        
        thirdSubscriber.disposed(by: self.disposeBag)
    }
    
    public func playBehaviorSubject()
    {
        let behaviorSubject = BehaviorSubject<String>(value: "🦐")
        
        let firstSubscriber = behaviorSubject.subscribe {
            debugPrint("\($0.element!) is the data that You Have Received for FirstSubscriber.")
        }
        
        behaviorSubject.onNext("🦃")
        behaviorSubject.onNext("🐃")
        
        firstSubscriber.disposed(by: self.disposeBag)
        
        let secondSubscriber = behaviorSubject.subscribe {
            debugPrint("\($0.element!) is the data that You Have Received for Second Subscriber.")
        }
        
        
        debugPrint("")
        behaviorSubject.onNext("🦧")
        behaviorSubject.onNext("🐇")
        
        secondSubscriber.disposed(by: self.disposeBag)
        
        let thirdSubscriber = behaviorSubject.subscribe {
            debugPrint("\($0.element!) is the data that You Have Received for Third Subscriber.")
        }
        
        behaviorSubject.onNext("🕊")
        behaviorSubject.onNext("🦔")
        
        thirdSubscriber.disposed(by: self.disposeBag)
    }
    
    private func playPublishSubject()
    {
        let publishSubject = PublishSubject<String>()
        
        let firstObserver = publishSubject.subscribe {
            switch $0
            {
                case.next(let data): debugPrint(data)
                case.completed: debugPrint("Completed.")
                case.error(let error):debugPrint(error.localizedDescription)
            }
        }
        
        publishSubject.on(.next("🦩"))
        
        firstObserver.disposed(by: self.disposeBag)
    }
    
    private func playFilteringWithObservables()
    {
        let dummyObservale = Observable<String>.from(["🦘","🦒","🦦","🐬"]).filter {
            $0 == "🐬"
        }
        
        let firstObserver = dummyObservale.subscribe {
            switch $0
            {
                case.next(let filteredData):
                debugPrint("Filtered Data => \(filteredData)")
                case.completed:
                debugPrint("Complted")
                case.error(let error):
                debugPrint(error.localizedDescription)
            }
        }
        
        firstObserver.disposed(by: self.disposeBag)
        
        let dummyObservableForDistinct = Observable<String>.from(["🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱"]).distinctUntilChanged()
        
        let observerToThatObservable = dummyObservableForDistinct.subscribe {
            debugPrint("Printed : \($0.element ?? "") and event \($0)")
        }
        
        observerToThatObservable.disposed(by: self.disposeBag)
    }
    
    private func playUntil()
    {
       let customSubject = PublishSubject<[String]>()
       let referenceSubject = PublishSubject<String>()
        
       let fistSubscriber = customSubject.take(until: referenceSubject).subscribe {
           $0.element?.forEach({
               debugPrint("Printed : \($0) at first Subscriber")
           })
           
           if $0.isCompleted {
               debugPrint($0)
           } else {
               debugPrint("Not Completed Yet")
           }
        }
        
        customSubject.onNext(["🦜","🐿","🐁"])
        referenceSubject.onNext("🦔")
        customSubject.onNext(["🦜","🐿","🐁"])
        
        fistSubscriber.disposed(by: self.disposeBag)
        
        let secondObserver = customSubject.take(until: referenceSubject).subscribe(onNext:{
            $0.forEach { data in
                debugPrint("Printed : \(data) at second Subscriber")
            }
        })
        
        customSubject.onNext(["🐇","🐇"])
        customSubject.onNext(["🐇","🐈"])
        
        referenceSubject.onNext("🐃")
        
        customSubject.onNext(["🐓"])
        
        secondObserver.disposed(by: self.disposeBag)
        
    }
    
    private func playSkipUntil()
    {
        let customSubject = ReplaySubject<String>.create(bufferSize: 1)
        let referencedSubject = PublishSubject<String>()
        
        //MARK: First Subscriber
        customSubject.skip(until: referencedSubject).subscribe {
            switch $0
            {
            case.next(let data):
                debugPrint(data)
            case.completed:
                debugPrint("Completed")
            case.error(let error):
                debugPrint(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
        
        customSubject.onNext("🌝 This will not be emitted")
        referencedSubject.onNext("🎍")
        customSubject.onNext("🍀 for First Subscriber of customObject")
        
        //MARK:Second Subscriber
        customSubject.subscribe(onNext:{
            debugPrint($0)
        }).disposed(by: self.disposeBag)
        
        customSubject.onNext("🌼 for Second SubScriber but it will broadcast to first subscriber")
    
    }
    
}

enum DummyError:Error
{
    case sampleError(error:String)
}
