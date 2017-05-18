# Javascript

## Node Installation

Much of the code in this lecture was run in the command line using node.js
Since most people will use javascript through a web browser, this step is completely optional, but if you want to make a server based on javascript or something, you may want to install node.

#### OSX

```
brew install node
```

#### Ubuntu and bash on Windows

```
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Normal Windows

Download the [installer](https://nodejs.org/en/#download).

## Printing

I am going to write this assuming python is the only language you know. 
First, lets make a simple hello world command in the node repl.
```
grantal@computername:~$ node
> console.log("hello world");
hello world
undefined
>
(To exit, press ^C again or type .exit)
>
grantal@computername:~$
```
So what just happened? `console.log` works almost identically to python's `print` command. So after that, it prints the word, then the `console.log` function returns an undefined so the repl prints that out. The `undefined` is similar to `None` in python but not quite the same. Here is another illustating example of what `undefined` means:
```
grantal@computername:~$ node
> var x;
undefined
> x
undefined
> x = 4;
4
> x
4
>
(To exit, press ^C again or type .exit)
>
grantal@computername:~$
```
Since we didn't assign a value to `x` is is 'undefined.' So the `console.log` function returns an undefined variable. Also `console.log` does not just work in the command line. If you press `F12` in most browsers and click on `console` is will bring up a console. Shocking. This is where `console.log` commands run in a javascript file in the web page will output. 

## Types

There are six primitives in Javascript
 1. Number
 2. Boolean
 3. String
 4. Null
 5. Undefined
 6. Symbol
 
 

Note the 'Number' type. Unlike Python, which has a several different types for numbers, Javascript has just one. The 'Number' type is the same as the 'float' type in Python. Observe this Javascript command:
```
> 5+5
10
> 5.0+5.0
10
>
```
And compare it to this python interaction:
```
>>> 5+5
10
>>> 5.0+5.0
10.0
```
In javascript, `5+5` and `5.0+5.0` both return the same thing since both are floating point numbers. In Python, `5+5` and `5.0+5.0` return different things because python wants to differentiate between floating point numbers and integers.


Javascript will also automatically convert booleans and numbers to string. Observe:
```
> true + "Hello"
'trueHello'
> 1 + "2"
'12'
> typeof .1 + .2
'number0.2'
> typeof (.1 + .2)
'number'
```
As you can see, booleans and strings are similar to python except that booleans are lowercase. A more notable difference is with the boolean operators: `and`, `or`, and `not`. These words are replaced in Javascript by `&&`, `||`, and `!`.
```
> true && true
true
> true && false
false
> true || false
true
> !true
false
```

## Real World Javascript

All of this command line stuff is nice and all, but most likely you want to write Javascript be run in the browser. So how is that done? In this repo in the `examples/lesson_0X` folder there is a file called `index.html`. If you run it, you should get something like this: 

![alert](/images/alert.PNG)

So what's going on? Lets take a look at the two files in the `examples/lesson_0X` folder:
```html
<!-- index.html -->
<head>
    <script src="alert.js"></script> 
</head>
```
```javascript
// alert.js
alert("hello there!");
```
So the html file imports the javascript between the two `head` tags. Then, the browser runs the javascript file and executes the first line of code it sees. As you can see, the `alert` function will bring up a popup window on the webpage. Also single line comments in javascript begin with a `//` rather than a `#` like in python.
