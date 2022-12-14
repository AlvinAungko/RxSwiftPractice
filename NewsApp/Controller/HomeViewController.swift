//
//  ViewController.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import UIKit
import RxSwift

enum NewsSections:Int
{
   case appleNews = 0
   case topHeadLines = 1
}

class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var listOfAppleArticles:Array<Article>?
    {
        didSet {
            if let _ = listOfAppleArticles
            {
                self.tableView.reloadData()
            } else {
                debugPrint("The data doesn't get in")
            }
        }
    }
    
    private var listOfTopHeadLinesArticles : Array<Article>?
    {
        didSet {
            if let _ = listOfAppleArticles
            {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    private let homeViewModel = HomeViewModel.shared
    private let fireBaseShared = FireBasePractice.shared
    
    private var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HeadLineTableViewCell.self, forCellReuseIdentifier: HeadLineTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(self.tableView)
        setDataSourceAndDelegate()
        getNewsArticle(network: .appleWebsite(query: "apple", from: "2022-09-30", to: "2022-09-30", sortBy: "popularity"))
        getNewsArticle(network: .topHeadLines(country: "us", category: "business"))
        fireBaseShared.retrieveDocumentsFromFireStore()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = view.bounds
    }
    
}

extension HomeViewController
{
    private func setDataSourceAndDelegate()
    {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension HomeViewController
{
    private func getNewsArticle(network:NewsNetwork)
    {
        switch network {
        case .appleWebsite(let query, let from, let to, let sortBy):
            homeViewModel.fetchNewsFromAPI(networkCall: .appleWebsite(query: query, from: from, to: to, sortBy: sortBy), decoder: NewsDataResponse.self) { [weak self] in
                switch $0 {
                case.success(let appleNews):
                    self?.listOfAppleArticles = appleNews.articles ?? Array<Article>()
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        case .topHeadLines(let country, let category):
            homeViewModel.fetchNewsFromAPI(networkCall: .topHeadLines(country: country, category: category), decoder: NewsDataResponse.self) { [weak self] in
                switch $0
                {
                case.success(let topArticles):
                    self?.listOfTopHeadLinesArticles = topArticles.articles ?? Array<Article>()
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
        
        Observable.of("????","????","????").subscribe {
            debugPrint($0)
        } onError: { debugPrint($0.localizedDescription)
        } onCompleted: {
            debugPrint("Completed")
        } onDisposed: {
            debugPrint("Disposed")
        }.disposed(by: self.disposeBag)
        
        //MARK: from can create a observable sequence of elements
        
        Observable.from(["????","????","????"]).subscribe(onNext:{
            debugPrint($0)
        },onCompleted: {
            debugPrint("Completed")
        }).disposed(by: self.disposeBag)
        
    }
    
    private func createObservable()
    {
        let myObservable = Observable<String>.create { observer in
            observer.onNext("????")
            observer.onNext("????")
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
        
        deferedObservable.subscribe { debugPrint("Number ???? \($0)")
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
        
        mySubject.onNext("????")
        mySubject.onNext("????")
        
        firstSubscriberToMySubject.disposed(by: self.disposeBag)
        
        let secondSubscriberToMySubject = mySubject.subscribe { event in
            debugPrint("Print : \(event.element ?? "") and \(event)")
        }
        
        mySubject.onNext("????")
        mySubject.onNext("????")
        
        secondSubscriberToMySubject.disposed(by: self.disposeBag)
        
    }
    
    private func testReplaySubject()
    {
        let myObservable = ReplaySubject<String>.create(bufferSize: 2)
        
        let firstObserver = myObservable.subscribe {
            debugPrint("Printed : \($0.element!) and \($0)")
        }
        
        myObservable.onNext("????")
        myObservable.onNext("????")
        
        firstObserver.disposed(by: self.disposeBag)
        
        let secondObserver = myObservable.subscribe {
            debugPrint("Printed : \($0.element!) and \($0)")
        }
        
        myObservable.onNext("????")
        myObservable.onNext("????")
        
        secondObserver.disposed(by: self.disposeBag)
        
    }
    
    private func testBehaviorSubject()
    {
        let behaviorSubject = BehaviorSubject<String>(value:"????")
        
        let firstObserver = behaviorSubject.subscribe({
            debugPrint("Printed : \($0.element ?? "") : and event : \($0)")
        })
        
        behaviorSubject.onNext("????")
        behaviorSubject.onNext("????")
        
        firstObserver.disposed(by: self.disposeBag)
        
        let secondObserver = behaviorSubject.subscribe {
            debugPrint("Printed : \($0.element ?? "") : and event : \($0)")
        }
        
        behaviorSubject.onNext("????")
        behaviorSubject.onNext("????")
        
        secondObserver.disposed(by: self.disposeBag)
        
        let thirdObserver = behaviorSubject.subscribe {
            debugPrint("Printed : \($0.element ?? "") : and event : \($0)")
        }
        
        behaviorSubject.onNext("????")
        
        
        thirdObserver.disposed(by: self.disposeBag)
        
    }
    
}


extension HomeViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section
        {
        case NewsSections.appleNews.rawValue:
            let cell = self.tableView.dequeReusableCells(identifier: HeadLineTableViewCell.identifier, indexPath: indexPath) as HeadLineTableViewCell
            
            cell.setArticles(articles: self.listOfAppleArticles ?? Array<Article>())
            
            return cell
            
        case NewsSections.topHeadLines.rawValue:
            let cell = self.tableView.dequeReusableCells(identifier: HeadLineTableViewCell.identifier, indexPath: indexPath) as HeadLineTableViewCell
            
            cell.setArticles(articles: self.listOfTopHeadLinesArticles ?? [])
         
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section
        {
        case 0: return 350
        case 1: return 350
        default:return 0
        }
    }
    
    
}

enum SampleError:Error
{
    case someKindOfError(errorSample:String)
}

extension HomeViewController
{
    private func doSomeRxSwift()
    {
        var count = 0
        //MARK: Create a custom Observable<List Of Strings>
        
        let myCustomObservable = Observable<[String]>.create { subscriber in
            subscriber.onNext(["????","????","????"])
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

extension HomeViewController
{
    private func playMathsWithObservables()
    {
        let subject1 = BehaviorSubject<String>(value:"????") //The First Item
        let subject2 = BehaviorSubject<String>(value: "????")
        let subjectSubject = BehaviorSubject(value: subject1)
        
        subjectSubject.asObservable().concat().subscribe {
            debugPrint("Printed : \($0)")
        }.disposed(by: self.disposeBag)
        
        subject1.onNext("????") // The Second Item
        subjectSubject.onNext(subject2)
        subject2.onNext("????") // This won't be extracted
        subject2.onNext("????")
        subject1.onNext("????") // The Third Item
        subject1.onCompleted()
        subject2.onNext("????") // The Fifth Item
        
    }
    
    private func playBehaviorSubject()
    {
        let behaviorSubject = BehaviorSubject(value: "????")
        
        
        //MARK: First Subscriber
        behaviorSubject.subscribe {
            debugPrint("Event : \($0)")
        }.disposed(by: self.disposeBag)
        
        //MARK: Emitting event to the Current Subscriber
        
        behaviorSubject.onNext("????")
        behaviorSubject.onNext("????")
        behaviorSubject.onCompleted()
        behaviorSubject.onNext("????") // This won't be pushed as an on next event
        //MARK: This is the end point for the first observer
        
        //MARK: Second Subscriber
        
        behaviorSubject.subscribe {
            debugPrint("Event : \($0)")
        }.disposed(by: self.disposeBag)
        
        behaviorSubject.onNext("????")
        behaviorSubject.onNext("????")
        behaviorSubject.onCompleted()
        
        //MARK: This will be the endpoint for second subscriber
    }
    
}

