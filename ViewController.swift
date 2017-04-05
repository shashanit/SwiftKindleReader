//
//  ViewController.swift
//  Kindle
//
//  Created by Shashwat Singh on 2/6/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {

    var books: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarStyles()
        setupNavBarButton()
        
        navigationItem.title = "Kindle"
        tableView.register(BookCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.darkGray
        tableView.separatorColor = UIColor(white: 1, alpha: 0.2)
       
        fetchbooks()
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(colorLiteralRed:  40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        let segmentedControl = UISegmentedControl(items: ["Cloud", "Device"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = .white
        
        
        
        footerView.addSubview(segmentedControl)
        segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true

        
        let gridbutton = UIButton(type: .system)
        gridbutton.setImage(#imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), for: .normal)
        gridbutton.tintColor = .white
        gridbutton.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(gridbutton)
        gridbutton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 8).isActive = true
        gridbutton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        gridbutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gridbutton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        let sortbutton = UIButton(type: .system)
        sortbutton.setImage(#imageLiteral(resourceName: "sort").withRenderingMode(.alwaysOriginal), for: .normal)
        sortbutton.tintColor = .white
        sortbutton.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(sortbutton)
        sortbutton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -8).isActive = true
        sortbutton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sortbutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sortbutton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        
        return footerView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func setupNavBarButton(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector (handleMenuPress))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "amazon_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector (handleamazonicon))
        
    }
    
    
    func handleMenuPress(){
        print("Menu pressed")
    }
    
    func handleamazonicon(){
        print("Amazon icon pressed")
    }
    
    func setupNavigationBarStyles(){
        
        print("Setting up shit")
        
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed:  40/255, green: 40/255, blue: 40/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    

    
    
    func fetchbooks(){
        print("Fetching books..")
        
        
        if let url = URL(string: "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/kindle.json") {
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil{
                    print("failed to fetch external json books")
                    return
                }
                
                
//                print(response)
                 
                guard let data = data else {return}
                
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                    // Array of dictionaries where we convert strings to any types array, string, int
                    guard let Dictionaries = json as? [[String: Any]] else {return}
                    
                    // Every new book gets added in the array that is nil from the beginning
                    self.books = []
                    for bookDictionary in Dictionaries{
                        
                        let book = Book(dictionary: bookDictionary)
                        self.books?.append(book)
                        
                        guard let response = response else {return}
                        print(response)
                    
                        
                    }
                    
                                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()

                    }
                    
                } catch let jsonError{
                    print("Failed to parse json properly", jsonError)
                }
                
                
                
                
                
                
                
                
                
            }).resume()

            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = books?.count{
            return count
        }
        return 0
        
            
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookCell
        
      let book = books?[indexPath.row]
        cell.book = book
////        cell.textLabel?.text = book?.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Book is being opened")
        let selectedbook = self.books?[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        let BookPageController = BookPagerController(collectionViewLayout: layout)
        BookPageController.book = selectedbook
        let navController = UINavigationController(rootViewController: BookPageController)
        present(navController, animated: true, completion: nil)
    }
    

    func setupbooks(){
    
        let book1 = Book(title: "Steve Jobs", author: "Walter Isaacson", image:#imageLiteral(resourceName: "steve_jobs"), pages: [Page(number: 1, text: "Text for steve jobs1"),
                                                                             Page(number: 2, text: "Text for steve jobs2")])
    
        let book2 = Book(title: "Bill Gates", author: "Ben Afflick", image:#imageLiteral(resourceName: "bill_gates"), pages: [Page(number: 1, text: "Text for Bill gates 1"),
                                                                         Page(number: 2, text: "Text for Bill gates 2")])
    
    
    
        self.books = [book1, book2]
        
        guard let unwrappedbooks = self.books else {return}
        for book in unwrappedbooks{
            print(book.title)
            for pages in book.pages{
                print(pages.text)
            }
        }
        
        
        
        
    }
    
 

}

