//
//  ViewController.swift
//  isbnSearch
//
//  Created by Alberto De Avila Hernandez on 20/12/15.
//  Copyright © 2015 Alberto De Avila Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var isbnTexfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    resultTextView.text = String(NSString(data:booksData, encoding: NSUTF8StringEncoding)!)
        } catch{
            resultTextView.text = "There isn't internet. Check your device config"
        }
        
        
    }
    
}

