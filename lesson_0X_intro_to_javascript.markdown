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

## A Note About Semicolons

In programming languages other than python, you end each statement with a semicolon rather than a line end. In javascript you can use both to end a statement. In `alert.js` I put a semicolon at the end of the line. That was not necessary, the code would run the same without the semicolon. You do need a semicolon if you want to execute two statements in the same line. For example:
```
> var x = 5; x
5
>
```

## If Else blocks

The `If Else` syntax in javascript is pretty similar to python. Here's an example:

```
> if (5 < 4) {
... console.log(1)
... } else if (3 < 2) {
... console.log(2)
... } else {
... console.log(3)
... }
3
undefined
>
```
Its pretty similar to python, there are three major differences:
1. Each condition needs to be surrounded by parentheses
2. each block needs to be surrounded by curly braces
3. use `else if` rather than `elif`.

## Loops

The `while` loop difference between python and javascript are the same as 1 & 2 from the if else blocks part. Here's an example:
```
> var x = 0
undefined
> while (x < 5){
... console.log(6)
... x = x + 1
... }
6
6
6
6
6
5
>
```
`for` loops are where weird stuff happens. I'll start by recreating the while loop from above:
```
> for (var x = 0; x < 5; x = x + 1){
... console.log(6)
... }
6
6
6
6
6
undefined
>
```
So inside the parentheses of the for loop there are three statements:
1. `var x = 0` This is called the *initialization*. This gets run before the loop starts
2. `x < 5` This is called the *condition*. It functions the same as the `x < 5` in the while loop.
3. `x = x + 1` This is called the *afterthought*. This gets run at the end of each loop.
You can also do stuff like this:
```
> for(;;){
... }
^CError: Script execution interrupted.
>
```
If you omit the three statements, the loop will run forever. This is called a *forever loop*. It functions identically to a `while (true)` loop. 

## jquery

To begin this section, here is a typical javascript stackoverflow question:

![jquery](http://i.imgur.com/Q3mkcnl.gif?1=)

I put this in to hightlight that jquery is never *necessary*. Anything you can do with jquery you can do with standard javascript and html. jquery just makes some problems easier to solve. Now, I will make an example that uses standard javascript and convert it to jquery. 


So, If I open `ex2.html`, this is what I see:

![ex2](/images/ex2.PNG)

Now, If I turn off javascript on the page, I see this:

![ex2](/images/ex2-1.PNG)

So, the javascript for the page is manipulating the page's html in some way. Let's take a look at the source code.
```HTML
<!-- ex2.html -->
<!doctype html>
<head>
    <meta charset="UTF-8"> 
</head>
<body>
    <p>The thing</p>
    <script>
        var paragraph = document.getElementsByTagName("p")[0]
        paragraph.innerHTML = "The other thing"
    </script>
</body>
```
So, this file selects the `<p>The thing</p>` element using `getElementsByTagName` with the tag name of `p`. That function returns a list, so we get the first item of that list set the variable `paragraph` to that element. We then set the html of the stuff between the `<p>` and `</p>` to `"The other thing"`. Also, our script needs to in the html file *after* the `<p>` element, otherwise our script would run and it could not find a `<p>` element to act on.


If you open `ex3.html` in your browser, you will see the exact same stuff as with `ex2.html`, so I won't post screenshots, lets go straight into the source code.
```HTML
<!-- ex3.html -->
<!doctype html>
<head>
    <meta charset="UTF-8"> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script>
        $(document).ready(function(){
            $("p").html("The other thing")
        })
    </script>
</head>
<body>
    <p>The thing</p>
</body>
```
Okay, first main difference is the part where it says `<script src=...`. This line gets imports jquery from a website that google maintains so that our script can use jquery. Now we can talk about importing. You can't import a javascript file from another javascript file. You have to import them all in you html file. Also, the order matters: If we put the jquery `script` tag after our script, then our script would throw an error. Okay, lets move on to our script. You may notice that our script is in the head and not the body this time. This is because we wrapped our program in the `$(document).ready` function. This makes it so that the script waits until all the elements on the page have loaded before running the `function()`. Now we get to get into anaonymous functions! These are just functions that
