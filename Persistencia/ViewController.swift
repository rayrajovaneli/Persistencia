//
//  ViewController.swift
//  Persistencia
//
//  Created by user218260 on 5/23/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    //  var names: [String] = []
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lista de Nomes"
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:  "Person")
        
        do{
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Não foi possível retornar os registros \(error)")
            
        }
    }

    @IBAction func addPerson(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Nome", message: "Insira um novo nome", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default){
        [unowned self] action in
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else{
                return
            }
            //self.names.append(nameToSave)
            save(name: nameToSave)
            self.myTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
   
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        
        do{
            try managedContext.save()
            people.append(person)
        } catch let error as Error {
            print("Error ao salvar novo nome\(error)")
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return names.count
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        //   cell.textLabel?.text = names[indexPath.row]
        
        return cell
    }
    
    
}
