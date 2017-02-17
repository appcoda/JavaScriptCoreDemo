//
//  MDEditorViewController.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

class MDEditorViewController: UIViewController {

    @IBOutlet weak var tvEditor: UITextView!
    
    @IBOutlet weak var webResults: UIWebView!
    
    @IBOutlet weak var conTrailingEditor: NSLayoutConstraint!
    
    @IBOutlet weak var conLeadingWebview: NSLayoutConstraint!
    
    
    var jsContext: JSContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(MDEditorViewController.handleMarkdownToHTMLNotification(notification:)), name: NSNotification.Name("markdownToHTMLNotification"), object: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initializeJS()
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


    // MARK: IBAction Methods
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func previewHTML(_ sender: Any) {
        var newTrailingConstant: CGFloat!
        
        if conTrailingEditor.constant == 0.0 {
            newTrailingConstant = self.view.frame.size.width/2
        }
        else if conTrailingEditor.constant == self.view.frame.size.width/2 {
            newTrailingConstant = self.view.frame.size.width
        }
        else {
            newTrailingConstant = 0.0
        }
        
        
        UIView.animate(withDuration: 0.4) {
            self.conTrailingEditor.constant = newTrailingConstant
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func convert(_ sender: Any) {
        self.convertMarkdownToHTML()
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
        
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        self.jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        _ = self.jsContext.evaluateScript("consoleLog")
        
        
        if let jsSourcePath = Bundle.main.path(forResource: "jssource", ofType: "js") {
            do {
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                self.jsContext.evaluateScript(jsSourceContents)
                
                
                // Fetch and evaluate the Snowdown script.
                let snowdownScript = try String(contentsOf: URL(string: "https://cdn.rawgit.com/showdownjs/showdown/1.6.3/dist/showdown.min.js")!)
                self.jsContext.evaluateScript(snowdownScript)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        
        let htmlResultsHandler = unsafeBitCast(self.markdownToHTMLHandler, to: AnyObject.self)
        self.jsContext.setObject(htmlResultsHandler, forKeyedSubscript: "handleConvertedMarkdown" as (NSCopying & NSObjectProtocol))
        _ = self.jsContext.evaluateScript("handleConvertedMarkdown")
    }

    
    func convertMarkdownToHTML() {
        if let functionConvertMarkdownToHTML = self.jsContext.objectForKeyedSubscript("convertMarkdownToHTML") {
            _ = functionConvertMarkdownToHTML.call(withArguments: [self.tvEditor.text!])
        }
    }
    
    
    func handleMarkdownToHTMLNotification(notification: Notification) {
        if let html = notification.object as? String {
            let newContent = "<html><head><style>body { background-color: #3498db; color: #ffffff; } </style></head><body>\(html)</body></html>"
            self.webResults.loadHTMLString(newContent, baseURL: nil)
        }
    }
    
    
    // MARK: Handler Blocks
    
    let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS Console:", logMessage)
    }
    
    
    let markdownToHTMLHandler: @convention(block) (String) -> Void = { htmlOutput in
        NotificationCenter.default.post(name: NSNotification.Name("markdownToHTMLNotification"), object: htmlOutput)
    }
    
}
