//
//  BasicsViewController.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

class BasicsViewController: UIViewController {
    
    var jsContext: JSContext!
    
    var guessedNumbers = [5, 37, 22, 18, 9, 42]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(BasicsViewController.handleDidReceiveLuckyNumbersNotification(notification:)), name: NSNotification.Name("didReceiveRandomNumbers"), object: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeJS()
        
//        self.helloWorld()
        
//        self.jsDemo1()
//
//        self.jsDemo2()
//
        self.jsDemo3()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: IBAction Method
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: Custom Methods
    
    func initializeJS() {
        self.jsContext = JSContext()
        
        // Add an exception handler.
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString())
            }
        }
        
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "jssource", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                self.jsContext.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        self.jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        _ = self.jsContext.evaluateScript("consoleLog")
    }
    
    
    func helloWorld() {
        if let variableHelloWorld = self.jsContext.objectForKeyedSubscript("helloWorld") {
            print(variableHelloWorld.toString())
        }
    }
    
    
    func jsDemo1() {
        let firstname = "Mickey"
        let lastname = "Mouse"
        
        if let functionFullname = self.jsContext.objectForKeyedSubscript("getFullname") {
            // Call the function that composes the fullname.
            if let fullname = functionFullname.call(withArguments: [firstname, lastname]) {
                print(fullname.toString())
            }
        }
    }
    
    
    func jsDemo2() {
        let values = [10, -5, 22, 14, -35, 101, -55, 16, 14]
        
        if let functionMaxMinAverage = self.jsContext.objectForKeyedSubscript("maxMinAverage") {
            if let results = functionMaxMinAverage.call(withArguments: [values]) {
                if let resultsDict = results.toDictionary() {
                    for (key, value) in resultsDict {
                        print(key, value)
                    }
                }
            }
        }
    }
    
    
    func jsDemo3() {
        let luckyNumbersObject = unsafeBitCast(self.luckyNumbersHandler, to: AnyObject.self)
        self.jsContext.setObject(luckyNumbersObject, forKeyedSubscript: "handleLuckyNumbers" as (NSCopying & NSObjectProtocol)!)
        _ = self.jsContext.evaluateScript("handleLuckyNumbers")
        
        
        if let functionGenerateLuckyNumbers = self.jsContext.objectForKeyedSubscript("generateLuckyNumbers") {
            _ = functionGenerateLuckyNumbers.call(withArguments: nil)
        }
    }
    
    
    
    func handleDidReceiveLuckyNumbersNotification(notification: Notification) {
        if let luckyNumbers = notification.object as? [Int] {
            print("\n\nLucky numbers:", luckyNumbers, "   Your guess:", guessedNumbers, "\n")
            
            var correctGuesses = 0
            for number in luckyNumbers {
                if let _ = self.guessedNumbers.index(of: number) {
                    print("You guessed correctly:", number)
                    correctGuesses += 1
                }
            }
            
            print("Total correct guesses:", correctGuesses)
            
            if correctGuesses == 6 {
                print("You are the big winner!!!")
            }
        }
    }
    
    
    
    let luckyNumbersHandler: @convention(block) ([Int]) -> Void = { luckyNumbers in
        NotificationCenter.default.post(name: NSNotification.Name("didReceiveRandomNumbers"), object: luckyNumbers)
    }
    
    
    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS Console:", logMessage)
    }
    
}
