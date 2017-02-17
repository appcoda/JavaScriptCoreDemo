# Using JavaScriptCore Framework in Swift Projects

For a long time I wanted to write a post about how Swift and JavaScript can be tied together, and lead eventually to more powerful and rich-featured apps. Being able to embed JavaScript code in iOS projects is not something that you hear for first time, but if you have never tried to do that then you should really read this and find out how simple is to do magical things with just a few actions. The one that makes that magic available has a name, and is called JavaScriptCore framework.

You might be thoughtful about that, and wondering why someone would really like to use JavaScript when everything can be done in Swift. I admit that I was thoughtful too in the beginning, but here are some good reasons that answer to the above:

* iOS developers that were used to write web apps and they miss JavaScript-ing, can take the maximum out of the JavaScriptCore framework coding again using their favourite language.
* There might exist JavaScript libraries that perform specific tasks suitable for your needs, and there’s nothing equivalent in Swift or you have to do it on your own. Why not to use them?
* It’s possible that some tasks are easier to be handled in JavaScript.
* You want to modify the behaviour of your app remotely. In that case the JavaScript code resides on a server and not locally in the app’s bundle. Be careful though, because it’s easy to end up with a disaster.
* You could possibly make your app more flexible and powerful.
* You are curious enough and you want to use JavaScript in your iOS projects.

Of course, you can think more than the above, but even these are good reasons to make you want to get started with JavaScript in iOS. Now that you feel the excitement too, let me underline a few necessary technical details. First off, JavaScript execution has its own environment, or to put it in a better way, a virtual machine where it runs into. In the JavaScriptCore framework, the JSVirtualMachine class represents programmatically that virtual machine, but usually you won’t have to deal directly with it. It’s possible to have multiple virtual machines running in an app, but they cannot exchange any data directly.

For the full tutorial, you can refer to this link:

http://www.appcoda.com/javascriptcore-swift/



