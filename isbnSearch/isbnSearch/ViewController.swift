//
//  ViewController.swift
//  isbnSearch
//
//  Created by Alberto De Avila Hernandez on 20/12/15.
//  Copyright © 2015 Alberto De Avila Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var isbnTexfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.hidden = true
        isbnTexfield.returnKeyType = UIReturnKeyType.Search
        isbnTexfield.becomeFirstResponder()
        isbnTexfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
     * Function to respond to the search keyboard button
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchBookByISBN()
        textField.resignFirstResponder()
        return true
    }
    
    /**
      * Function to make a request to openlibrary to search a book by the isbn 
      * given in the isbnTextField and render it in the resultTextView
      */
    func searchBookByISBN(){
        errorLabel.hidden = true
        scrollView.hidden = false
        print ("Searching by \(isbnTexfield.text!)")
        let myUrl:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbnTexfield.text!)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let openLibraryURL:NSURL = NSURL(string: myUrl)!
        
        let request = NSURLRequest(URL: openLibraryURL,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 3)
        var response: NSURLResponse?
        do {
            let booksData = try NSURLConnection.sendSynchronousRequest(request,
                returningResponse: &response)
            
            let json = try NSJSONSerialization.JSONObjectWithData(booksData, options: .MutableLeaves)
            if((json as! NSDictionary)["ISBN:\(isbnTexfield.text!)"] != nil){
                let booksMap = (json as! NSDictionary)["ISBN:\(isbnTexfield.text!)"]!
                let authorsList = booksMap["authors"] as! NSArray
                var authors: String = ""
                for author in authorsList {
                    let authorName : String = author["name"] as! String
                    authors = "\(authorName)\n"
                }
                let bookName : String = booksMap["title"] as! NSString as! String
                bookNameLabel.text = bookName
                authorsLabel.text = authors
                let bookCovers = booksMap["cover"] as! NSDictionary
                if(bookCovers["medium"] != nil){
                    let url = NSURL(string: bookCovers["medium"] as! NSString as! String)
                    let data = NSData(contentsOfURL: url!)
                    frontImage.image = UIImage(data: data!)
                }
            }else{
                scrollView.hidden = true
                errorLabel.hidden = false
                errorLabel.text = "The book doesn't exists"
            }
        } catch{
            scrollView.hidden = true
            errorLabel.hidden = false
            errorLabel.text = "There isn't internet. Check your device config"
        }
        
        
    }
    
}

