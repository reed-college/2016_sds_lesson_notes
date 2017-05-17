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
