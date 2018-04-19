//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController{
    
//    struct objects{
//        var sectionName: String
//        var sectionObjects: [categoryInfo]
//    }
//
//    var tblViewObjects = [objects]()

    static var recentlyDeleted = [recentlyDeletedInfo]()
    
    struct recentlyDeletedInfo{
        var categoryIdentifier: String
        var deletedObject: Any //deletedObject can be anything (Category, Image ,... )
    }
    
//    static func delete(object: Any , withIdentifer identifier: String){
//        if let deletedCategory = object as? categoryInfo{
//            addDeleted(category: deletedCategory)
//        }else if let deletedImage = object as? UIImage{
//            addDeleted(image: deletedImage, withCategoryName: identifier)
//        }
//    }
    
    static func addDeleted(image:UIImage, withCategoryName name: String){
        recentlyDeleted.append(recentlyDeletedInfo(categoryIdentifier: name, deletedObject: image))
    }
    static func addDeleted(category:categoryInfo){
        recentlyDeleted.append(recentlyDeletedInfo(categoryIdentifier: category.name, deletedObject: category))
    }
    
    func revertCategory(image: UIImage, withCategoryName name: String){
        if categories.filter({$0.name == name}).count == 1{
            for index in categories.indices{
                if (categories[index].name == name){categories[index].categoryImages?.append(image)}
            }
        }
    }
    @IBOutlet var imageGalleryTableView: UITableView!
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "Untitled".madeUnique(withRespectTo: categories), number: 1400, categoryImages: []))
        imageGalleryTableView.reloadData()
    }
    
    private var categories = [categoryInfo]()

    struct categoryInfo{
        var image: UIImage?
        var name: String
        var number: Int
        var categoryImages: [UIImage]?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageGalleryTableView.delegate = self
        imageGalleryTableView.dataSource = self
       
        categories.append(categoryInfo(image: UIImage(named: "img.jpg"), name: "My Photos", number: 1400,
        categoryImages: [UIImage(named: "img.jpg")!]))
        categories.append(categoryInfo(image: UIImage(named: "img2.jpg"), name: "Facebook", number: 1200,
        categoryImages: [UIImage(named: "img")!,UIImage(named: "img2.jpg")!]))
        categories.append(categoryInfo(image: UIImage(named: "img3.jpg"), name: "Instagram", number: 2400,
        categoryImages: [UIImage(named: "img")!,UIImage(named: "img2.jpg")!,UIImage(named: "img3.jpg")!]))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        if splitViewController?.preferredDisplayMode != .primaryOverlay {
//            splitViewController?.preferredDisplayMode = .primaryOverlay
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2 //we have only two sections one for All and one only for the recently deleted
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case Constatns.NormalCategoriesSectionNumber: return categories.count
        case Constatns.RecentlyDeletedSectionNumber: return ImageGalleryTableViewController.recentlyDeleted.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! ImageGalleryTableViewCell
        
        // Configure the cell...
        if indexPath.section == Constatns.NormalCategoriesSectionNumber{
            cell.cellImage.image = categories[indexPath.row].image
            cell.cellName.text = categories[indexPath.row].name
            cell.cellNumber.text = String(categories[indexPath.row].number)
        }else if let deletedCategory = ImageGalleryTableViewController.recentlyDeleted[indexPath.row].deletedObject as? categoryInfo{
                cell.cellImage.image = deletedCategory.image
                cell.cellName.text = deletedCategory.name
                cell.cellNumber.text = String(deletedCategory.number)
        }else if let deletedImage = ImageGalleryTableViewController.recentlyDeleted[indexPath.row].deletedObject as? UIImage{
//                let onlyImageCell = tableView.dequeueReusableCell(withIdentifier: "onlyImageTableViewCell", for: indexPath) as! OnlyImageTableViewCell
//                onlyImageCell.imageCell.image = deletedImage
//                return onlyImageCell
            let onlyImageCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? OnlyImageTableViewCell
            onlyImageCell?.cellImage.image = deletedImage
            return onlyImageCell!
            }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Constatns.RecentlyDeletedSectionNumber {return "Recently Deleted"} else {return ""}
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let revert = revertAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [revert])
    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let revert = revertAction(at: indexPath)
//        return UISwipeActionsConfiguration(actions: [revert])
//    }
    
    func revertAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "revert") { (action, view, completion) in
            if indexPath.section == Constatns.RecentlyDeletedSectionNumber{
                if let category = ImageGalleryTableViewController.recentlyDeleted[indexPath.row].deletedObject as? categoryInfo{
                    DispatchQueue.main.async{ [weak self] in
                        self?.categories.append(category)
                        ImageGalleryTableViewController.recentlyDeleted.remove(at: indexPath.row)
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        action.title = "Revert"
        action.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        return action
    }
    
    func revertImage(image: UIImage, withCategoryName name: String){
        if categories.filter({$0.name == name}).count == 1{
            for index in categories.indices{
                if (categories[index].name == name){categories[index].categoryImages?.append(image)}
            }
        }
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == Constatns.NormalCategoriesSectionNumber{
                let category = categories[indexPath.row]
                ImageGalleryTableViewController.addDeleted(category: category)
                categories.remove(at: indexPath.row)
                tableView.reloadData()
                //tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        else if editingStyle == .insert { //Done using add + button
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImagesForSelectedCategory"{
            if let tableViewCell = sender as? ImageGalleryTableViewCell{
                var destination = segue.destination
                if let navigationControl = destination as? UINavigationController{
                    destination = navigationControl.visibleViewController ?? navigationControl
                }
                if let collectionViewController = destination as? ImageGalleryCollectionViewController{
                    if let indexPath = imageGalleryTableView.indexPath(for: tableViewCell){
                        if indexPath.section == Constatns.NormalCategoriesSectionNumber{
                            assert(categories.indices.contains(indexPath.row), "ImageGalleryTableViewController.Prepare: Row# \(indexPath.row) is not a valid row")
                            let category = categories[indexPath.row]
                            DispatchQueue.global(qos: .userInitiated).async{
                                collectionViewController.cellImages = category.categoryImages!
                                collectionViewController.title = category.name
                            }
                        }else{
                            assert(ImageGalleryTableViewController.recentlyDeleted.indices.contains(indexPath.row), "ImageGalleryTableViewController.Prepare: Row# \(indexPath.row) is not a valid row")
                            if let category = ImageGalleryTableViewController.recentlyDeleted[indexPath.row].deletedObject as? categoryInfo{
                                DispatchQueue.global(qos: .userInitiated).async{
                                    collectionViewController.cellImages = category.categoryImages!
                                    collectionViewController.title = category.name
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    
    
    struct Constatns{
        static var NormalCategoriesSectionNumber: Int = 0
        static var RecentlyDeletedSectionNumber: Int = 1
    }
    
}


extension String {
    func madeUnique(withRespectTo otherCatrgories: [ImageGalleryTableViewController.categoryInfo]) -> String {
        var possiblyUnique = self
        var uniqueNumber = 1
        var otherStrings = [String]()
        for category in otherCatrgories{
            otherStrings.append(category.name)
        }
        while otherStrings.contains(possiblyUnique) {
            possiblyUnique = self + " \(uniqueNumber)"
            uniqueNumber += 1
        }
        return possiblyUnique
    }
}















