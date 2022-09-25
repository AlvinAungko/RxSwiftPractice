//
//  ViewController.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import UIKit
import RxSwift


class HomeViewController: UIViewController {
    
    
    private let disposeBag = DisposeBag()
    private var listOfArticles:Array<Article>?
    {
        didSet {
            if let _ = listOfArticles
            {
                self.tableView.reloadData()
            }
        }
    }
    
    private let homeViewModel = HomeViewModel.shared
    
    private var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HeadLineTableViewCell.self, forCellReuseIdentifier: HeadLineTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        getNewsArticle(network: .appleWebsite(query: "apple", from: "2022-09-22", to: "2022-09-22", sortBy: "popularity"))
        getNewsArticle(network: .topHeadLines(country: "us", category: "business"))
//        testingObservables()
//        doSomeRealMExercises()
//        testingSubject()
        testBehaviorSubject()
    }
    
}

extension HomeViewController
{
    private func getNewsArticle(network:NewsNetwork)
    {
        switch network {
        case .appleWebsite(let query, let from, let to, let sortBy):
            homeViewModel.fetchNewsFromAPI(networkCall: .appleWebsite(query: query, from: from, to: to, sortBy: sortBy), decoder: NewsDataResponse.self) {
                switch $0 {
                case.success(let appleNews):
                    self.listOfArticles = appleNews.articles ?? Array<Article>()
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        case .topHeadLines(let country, let category):
            homeViewModel.fetchNewsFromAPI(networkCall: .topHeadLines(country: country, category: category), decoder: NewsDataResponse.self) {
                switch $0
                {
                case.success(let topArticles):
                    self.listOfArticles = topArticles.articles ?? Array<Article>()
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        }
        
    }
    
    private func testingObservables()
    {
        //MARK: Just can create only one single element
        
        Observable.just("Testing")
            .subscribe { data in
                debugPrint(data)
            } onError: { error in
                debugPrint(error.localizedDescription)
            } onCompleted: {
                debugPrint("The event is completed")
            } onDisposed: {
                debugPrint("The event is disposed")
            }.disposed(by: DisposeBag())
        
        //MARK: of can create a fixed number of observable elements
        
        Observable.of("🐶","🐱","🐭").subscribe {
            debugPrint($0)
        } onError: { debugPrint($0.localizedDescription)
        } onCompleted: {
            debugPrint("Completed")
        } onDisposed: {
            debugPrint("Disposed")
        }.disposed(by: self.disposeBag)
        
        //MARK: from can create a observable sequence of elements
        
        Observable.from(["🐭","🦊","🐼"]).subscribe(onNext:{
            debugPrint($0)
        },onCompleted: {
            debugPrint("Completed")
        }).disposed(by: self.disposeBag)
        
    }
    
    private func createObservable()
    {
        let myObservable = Observable<String>.create { observer in
            observer.onNext("🦄")
            observer.onNext("🐸")
            observer.onError(SampleError.someKindOfError(errorSample: "Error Did Happen"))
            observer.onCompleted()
            return Disposables.create()
        }
        
        myObservable.subscribe { event in
            debugPrint(event)
        }.disposed(by: self.disposeBag)
    }
    
    private func createDifferentObservable()
    {
        let deferedObservable = Observable<Int>.deferred {
            return Observable.create { subscriber in
                subscriber.onNext(1)
                subscriber.onNext(3)
                subscriber.onCompleted()
                return Disposables.create()
            }
        }
        
        deferedObservable.subscribe { debugPrint("Number 🐶 \($0)")
        } onError: {
            debugPrint($0.localizedDescription)
        } onCompleted: {
            debugPrint("Completed")
        } onDisposed: {
            debugPrint("Disposed")
        }.disposed(by: self.disposeBag)

    }
    
    private func testingSubject()
    {
        let mySubject = PublishSubject<String>()
        
        
       let firstSubscriberToMySubject = mySubject.subscribe { event in
            debugPrint("Print : \(event.element ?? "") and \(event)")
        }
        
        mySubject.onNext("🐒")
        mySubject.onNext("🐹")
        
        firstSubscriberToMySubject.disposed(by: self.disposeBag)
        
        let secondSubscriberToMySubject = mySubject.subscribe { event in
            debugPrint("Print : \(event.element ?? "") and \(event)")
        }
        
        mySubject.onNext("🐮")
        mySubject.onNext("🪳")
        
        secondSubscriberToMySubject.disposed(by: self.disposeBag)
        
    }
    
    private func testReplaySubject()
    {
        let myObservable = ReplaySubject<String>.create(bufferSize: 2)
        
       let firstObserver = myObservable.subscribe {
            debugPrint("Printed : \($0.element!) and \($0)")
        }
        
        myObservable.onNext("🐶")
        myObservable.onNext("🐷")
        
        firstObserver.disposed(by: self.disposeBag)
        
        let secondObserver = myObservable.subscribe {
            debugPrint("Printed : \($0.element!) and \($0)")
        }
        
        myObservable.onNext("🪲")
        myObservable.onNext("🐤")
        
        secondObserver.disposed(by: self.disposeBag)
        
    }
    
    private func testBehaviorSubject()
    {
        let behaviorSubject = BehaviorSubject<String>(value:"🦑")
        
        let firstObserver = behaviorSubject.subscribe({
            debugPrint("Printed : \($0.element ?? "") : and event : \($0)")
        })
        
        behaviorSubject.onNext("🐨")
        behaviorSubject.onNext("🐗")
        
        firstObserver.disposed(by: self.disposeBag)
        
        let secondObserver = behaviorSubject.subscribe {
            debugPrint("Printed : \($0.element ?? "") : and event : \($0)")
        }
        
        behaviorSubject.onNext("🐯")
        behaviorSubject.onNext("🐝")
        
        secondObserver.disposed(by: self.disposeBag)
        
        let thirdObserver = behaviorSubject.subscribe {
            debugPrint("Printed : \($0.element ?? "") : and event : \($0)")
        }
        
        behaviorSubject.onNext("🙉")
        
        
        thirdObserver.disposed(by: self.disposeBag)
        
    }
    
}

extension HomeViewController
{
    private func setDataSourceAndDelegate()
    {
        self.tableView.dataSource = self
    }
    
}

extension HomeViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section
        {
        case 0:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HeadLineTableViewCell.identifier, for: indexPath) as? HeadLineTableViewCell  else
            {
                return UITableViewCell()
            }
            
            return cell
            
        default: return UITableViewCell()
        }
    }
}

enum SampleError:Error
{
    case someKindOfError(errorSample:String)
}

extension HomeViewController
{
    private func doSomeRealMExercises()
    {
        
         var count = 0
        //MARK: Create a custom Observable<List Of Strings>
        
        let myCustomObservable = Observable<[String]>.create { subscriber in
            subscriber.onNext(["🦁","🐯","🐝"])
            subscriber.onCompleted()
            return Disposables.create()
        }
        
        myCustomObservable.subscribe {
            $0.forEach {
                debugPrint($0)
            }
        } onError: { error in
            debugPrint(error.localizedDescription)
        } onCompleted: {
            debugPrint("Completed")
        } onDisposed: {
            debugPrint("Disposed")
        }.disposed(by: self.disposeBag)
        
        //MARK: Create a defered Observable Sequence of data
        
        let deferedObservable = Observable<Array<Int>>.deferred {
            count += 1
            return Observable<Array<Int>>.create {
                $0.onNext([1,2,3])
                $0.onCompleted()
                return Disposables.create()
            }
        }
        
        deferedObservable.subscribe { data in
            data.forEach {
                debugPrint("Count => \(count) == \($0)")
            }
        }  onCompleted: {
            debugPrint("Completed")
        } onDisposed: {
            debugPrint("Disposed")
        }.disposed(by: self.disposeBag)
        
        deferedObservable.subscribe { data in
            data.forEach {
                debugPrint("Count => \(count) == \($0)")
            }
        }  onCompleted: {
            debugPrint("Completed")
        } onDisposed: {
            debugPrint("Disposed")
        }.disposed(by: self.disposeBag)

    }
}

