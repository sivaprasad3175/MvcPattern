//
//  ViewController.swift
//  MVC pattern
//
//  Created by siva prasad on 24/08/18.
//  Copyright © 2018 SIVA PRASAD. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var manageObjectContext: NSManagedObjectContext!
    var resultArray = [ItuneResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // tableview methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let eventArrayItem = resultArray[indexPath.row]
        
        if editingStyle == .delete {
            manageObjectContext.delete(eventArrayItem)
            
            do {
                try manageObjectContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        self.loadSaveData()

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = resultArray[indexPath.row].name
        cell.detailTextLabel?.text = resultArray[indexPath.row].artworkUrl100
        return cell
    }
    
    
    
    
    func fetchItunesData() {
        let url = "https://rss.itunes.apple.com/api/v1/tr/movies/top-movies/all/25/explicit.json"
        WebService.requestGETURL(url, success: { (json) in
            self.getData(jsonData: json)
        }) { (error) in
            print(error , "eroor in fetcehing josn")
        }
    }

    func getData(jsonData: Data){
        do{
            let appleData = try JSONDecoder().decode(ItunesModel.appleApi.self, from: jsonData)
            let appData = appleData.feed.results
            for name in appData{
                let eventItem = ItuneResult(context: manageObjectContext)
                eventItem.name = name.name
                eventItem.artworkUrl100 = name.artworkUrl100
            }
            do{
                try self.manageObjectContext.save()
                self.loadSaveData()
            }catch{
                print("Could not save data: \(error.localizedDescription)")
            }

        }catch let err{
            print("Error", err )
        }
        
    }
    func loadSaveData()  {
        let eventRequest: NSFetchRequest<ItuneResult> = ItuneResult.fetchRequest()
        do{
            resultArray = try manageObjectContext.fetch(eventRequest)
            print(resultArray , "Array Reult")
            self.tableView.reloadData()
        }catch{
            print("Could not load save data: \(error.localizedDescription)")
        }
    }
    

    
    @IBAction func deleteBtn(_ sender: UIBarButtonItem) {

        deleteRecords()
    }
    
    @IBAction func refreshBtn(_ sender: UIBarButtonItem) {
        loadSaveData()
        fetchItunesData()

        
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    // MARK: Delete Data Records
    
    func deleteRecords() -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItuneResult")
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [ItuneResult]
        for object in resultData {
            moc.delete(object)
        }
        
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        self.tableView.reloadData()
    }

    
}

//import CoreData
//
//class CoreDataOperations: NSObject {
//
//    // MARK: Save data
//    func saveData() -> Void {
//        let managedObjectContext = getContext()
//        let personData = NSEntityDescription.insertNewObject(forEntityName: "Person", into: managedObjectContext) as! Person
//        personData.name = "Raj"
//        personData.city = "AnyXYZ"
//
//        do {
//            try managedObjectContext.save()
//            print("saved!")
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        } catch {
//
//        }
//
//    }
//
//    // MARK: Fetching Data
//    func fetchData() -> Void {
//
//        let moc = getContext()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//
//        do {
//            let fetchedPerson = try moc.fetch(fetchRequest) as! [Person]
//
//            print(fetchedPerson.count)
//            for object in fetchedPerson {
//                print(object.name!)
//            }
//
//        } catch {
//            fatalError("Failed to fetch employees: \(error)")
//        }
//
//    }
//
//
//
//    // MARK: Delete Data Records
//
//    func deleteRecords() -> Void {
//        let moc = getContext()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//
//        let result = try? moc.fetch(fetchRequest)
//        let resultData = result as! [Person]
//
//        for object in resultData {
//            moc.delete(object)
//        }
//
//        do {
//            try moc.save()
//            print("saved!")
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        } catch {
//
//        }
//
//
//
//
//
//    }
//
//    // MARK: Update Data
//    func updateRecords() -> Void {
//        let moc = getContext()
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//
//        let result = try? moc.fetch(fetchRequest)
//
//        let resultData = result as! [Person]
//        for object in resultData {
//            object.name! = "\(object.name!) Joshi"
//            print(object.name!)
//        }
//        do{
//            try moc.save()
//            print("saved")
//        }catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//
//    }
//
//    // MARK: Get Context
//
//    func getContext () -> NSManagedObjectContext {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
//    }
//}



