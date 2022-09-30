//
//  OperatorsInRxSwiftViewController.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 28/09/2022.
//

import UIKit
import RxSwift

class OperatorsInRxSwiftViewController: UIViewController {

    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playWithOperatorsInRxSwift()
        // Do any additional setup after loading the view.
    }
    
}

extension OperatorsInRxSwiftViewController
{
    //MARK: Practice Concat
    
    private func playWithOperatorsInRxSwift()
    {
        
        //MARK: Start With Operator
        
        Observable.from(["🌩","🌨","❄️"])
            .startWith("🌤")
            .startWith("☀️")
            .startWith("💥").subscribe {
                debugPrint("Printed event for start with : \($0)")
            }.disposed(by: self.disposedBag) //💥☀️🌤🌩🌨❄️
        
        //MARK: Merge Operator
        
        let dummySubject1UsedForMergeOperator = PublishSubject<String>()
        let dummySubject2UsedForMergeOperator = PublishSubject<String>()
        
        Observable.of(dummySubject1UsedForMergeOperator,dummySubject2UsedForMergeOperator)
            .merge().subscribe {
                debugPrint("Printed event for merge : \($0)")
            }.disposed(by: self.disposedBag)
        
        dummySubject2UsedForMergeOperator.onNext("🍏")
        dummySubject1UsedForMergeOperator.onNext("🌙")
        dummySubject1UsedForMergeOperator.onNext("🍋")
        dummySubject2UsedForMergeOperator.onNext("✨") //🍏🌙🍋✨
        
        //MARK: Zip Operator
        
        let subject1UsedForZipOperator = PublishSubject<Int>()
        let subject2UsedForZipOperator = PublishSubject<String>()
        
       //MARK: First Subscriber
       Observable.zip(subject1UsedForZipOperator, subject2UsedForZipOperator).subscribe {
            switch $0
            {
            case.next((let dataFromFirstObserver, let dataFromSecondObserver)):
                debugPrint("\(dataFromFirstObserver)\(dataFromSecondObserver)")
            case.completed:
                debugPrint("Completed")
            case.error(let error):
                debugPrint(error.localizedDescription)
            }
       }.disposed(by: self.disposedBag)
        
        
        subject1UsedForZipOperator.onNext(1)
        subject1UsedForZipOperator.onNext(2)
        subject1UsedForZipOperator.onNext(3)
        
        subject2UsedForZipOperator.onNext("A")
        subject2UsedForZipOperator.onNext("B")
        subject2UsedForZipOperator.on(.next("C"))
        
       //MARK: Combine latest
        
        let subject1ForCombineLatest = PublishSubject<String>()
        let subject2ForCombineLatest = PublishSubject<String>()
        
        
        Observable.combineLatest(subject1ForCombineLatest, subject2ForCombineLatest)
            .subscribe {
                debugPrint("\($0) is the event that got emitted")
            }.disposed(by: self.disposedBag)
        
        subject1ForCombineLatest.onNext("🌸")
        subject1ForCombineLatest.onNext("🌦")
        subject1ForCombineLatest.onNext("💥")
        
        subject2ForCombineLatest.onNext("B")
        subject2ForCombineLatest.onNext("C")
        
       //MARK: Concat Operator from Maths Observable
        
       let subject1 = PublishSubject<String>()
       let subject2 = PublishSubject<String>()
        
       let subjectSubject = BehaviorSubject(value: subject1)
       
        subjectSubject.asObservable()
            .concat().subscribe {
                switch $0
                {
                    case.next(let element): debugPrint("Printed : \(element)")
                    case.error(let error): debugPrint(error.localizedDescription)
                    case.completed: debugPrint("The Sequence is completed, no more on next event")
                }
            }.disposed(by: self.disposedBag)
        
        subject1.on(.next("🌍"))
        subject1.on(.next("☔️"))
        
        subjectSubject.on(.next(subject2))
        subject2.onNext("🍑")
        
        subject1.onCompleted()
        subject2.onNext("🌫")
        subject2.onNext("🥥")
        
    }
    
    //Find the sum of the first 12 terms of the geometric series with first term 10 and common
    //ratio 4.
    
//    The sum of the first 3 terms of a geometric series is 37/ 8 . The sum of the first six terms is 3367/ 512 . Find the first term and common ratio.
    
//    How many terms in the GP 4, 3.6, 3.24, . . . are needed so that the sum exceeds 35?
    
}
