Foundational Idea: Plain Text
-----------------------------

You've probably used Microsoft Word. You've probably used it to do a thing like this:

1.  Open a new Document.
2.  Write five works.
3.  Make one of them bold.
4.  Change the font size.
5.  Change the font entirely.
6.  Save it.
7.  Email it to someone else.

First point of clarification: when you save the document, it becomes a *file*, a thing that exists on the hard drive of your computer. We could call it a document, because we know it is; now we can call it a "file" too. A file is a much broader term; nearly anything stored on your computer is a file, or is made of files. (The primary exception are folders, which collect a set of files and other folders, making a natural hierarchy.) Point is: I'm going to say "document" and "file" a little interchangeably for a moment here.

When that document arrives in the inbox of the Other Person, and they open it in Microsoft Word, you will have a very reasonable expectation that it will be "the same". Which is to say, not *only* will the words be the same, but the font will be the same, and the correct word will be typeset in a bold face.

This sort of file is called a *rich text* document. Which means: the document encodes both data ("what words are in the document") and metadata about those words ("this one is bold; the font is Impact") and saves them in the same file. You need a particular kind of program to correctly interact with this file; you'd have a gross experience opening a Word document in Sublime Text.

This markdown document, on the other hand, is a *plain text* document. It **only** contains words. What font will it open in? A font provided by the program that opens it. How big will the text be? You can't control that either. A plain text format conveys **only** the data – the words – and no metadata.

This distinction is important for a variety of reasons. The most important of them is this: unlike Word Documents, where the program used to write them is prescribed by the format, plain text documents can be opened and edited by a dazzling array of programs. Plain text can also be manipulated by an incredibly rich set of tools. Today, we're going to explore some of these.

Text Editors vs. IDEs
---------------------

"Text editor" is the name for the broad category of tools intended for working with plain text. There are a **lot** of IDEs, and many of them don't bear fooling with. Windows, for example, comes with a program called Notepad. If Text Editors are cars, Notepad is a golf cart with half a battery left. It'll move you a short distance, sure, and then you'll wish you'd done something else.

An Integrated Development Environment – IDE – ties a text editor together with Some Number of Other Tools. Which tools, and how they are tied together, varies widely. And yes, the line between an editor and an IDE can get fuzzy.

Loose guidelines:

1.  All code is text, so all code can be read in a text editor. Find a *real*, code specific text editor with first-class support for code tools like syntax highlighting, formatting, and linting – but other than that? You do you.
2.  That said, compiled languages – Java, for instance – benefit a lot from some of the tools you get with an IDE. IDEs usually aren't general, so it's worth getting to know an editor as well, but IDEs are excellent toolkits for the specific languages they support.
3.  The Text Editor holy war is a crock of nonsense.

### Editors

Text editors are built for one thing: editing text. (Surprise, right?) A good text editor supports tools for writing code in many different programming languages. Microsoft Word? Not a text editor; neither is Google Docs. Text Editors pair well with using the Terminal directly.

You can use most text editors as-is, but I recommend, at a minimum, that your editor support and have installed the following tools:

-   Syntax Highlighting
-   Linting (automatic, often real-time detection of syntax errors)
-   Autocompletion

Really nice to have:

-   Some kind of integration with revision control
-   Search and jump
-   …I dunno, what do *you* want it to be able to do?

#### Sublime Text and Atom

-   Friendly as hell
-   Sublime Text (Python); Atom (JavaScript)
-   Pretty simple, but that's very good news. (They're **just** text editors.)
-   Pretty simple, and maybe you want a little more out of your tools.

#### Nano

-   Look, this is technically a text editor
-   But it's a little like the Notepad of unix

Nano is a wonderful thing to know is there in a context where you might otherwise have to use Vim, assuming you do not presently know how to use Vim.

#### Emacs

-   Type words, get words. (Key chord-driven commands.)
-   …but also it's backed by a lisp! Maybe you think that's great? Maybe it's the worst.
-   It's a text editor!
-   …and an IDE!
-   …and maybe also an operating system?
-   The gold standard in customizabile and extensible editors.
-   The gold standard in truly idiosyncratic user experiences.

#### Vim

-   Type words, get lost
-   Modal editing is powerful as hell, once you get your head around it. (And Vim is pretty much the only system that gets it right.)
-   Extensible with VimScript, which is a hideous nightmare-fuel of a pseudo-language
-   Installed by default, in at least some version, on almost every \*nix-based computer you will ever ever touch.
-   Loads almost instantaneously.

#### Note:

Part of the virtue of both Emacs and Vim is that they are first-class text editors that will run in the Terminal, and/or interact natively with tools like `ssh` and `rsync`. If you're likely to edit files that live on remote servers, it'll be a great benefit to you to be able to use one of Emacs or Vim with at least some familiarity.

### IDEs

#### Emacs again

#### JetBrains IDEAs

The File System and an introduction to the Terminal
---------------------------------------------------

The file system is an interface to the data stored on your computer. Here's the short short version:

> The file system represents data in a hierarchy, in which folders contain files, other folders, and links to files or folders elsewhere in the hierarchy. We can browse and manipulate this hierarchy with GUI tools, like Finder or Windows Explorer, or through the Terminal.

…okay great. What on *earth* does that mean in practice?

### File System Basics

Open your terminal. There's a blinking cursor. Your computer is waiting for you to type a command, tell it what you'd like it to do. Great so far.

When you interact with the file system, you are always *in* the file system. That is: your commands always have a context, and that context is some place, some directory, in the filesystem. When you open your terminal, you start by viewing the contents of a directory called your `home` directory. Every user of a Linux computer has their own `home` dir, specific to them. You can see what directory you're currently in by typing the `pwd` command and hitting enter, so:

``` shell
pwd
```

Change which directory you're viewing using the `cd` command:

``` shell
cd /tmp/
pwd
```

Your `home` dir has a few special properties we'll get to as we go. First up is: you can always return to your home directory by typing `cd` without specifying which directory you want to go to:

``` shell
cd
pwd
```

The directory you're currently *in* is referred to as your *working directory*. (The `pwd` command we used before stands for "print working directory".) You can list the contents of your working directory with `ls`:

``` shell
ls
```

Say it with me: ooooooooooooooh.

### A few useful keyboard shortcuts

#### Ctrl-c / Ctrl-d

Ctrl-c is the keyboard interrupt command – if you start something running and you want it to stop, Ctrl-c will *usually* help. Ctrl-d is an exit command, useful for quitting things like the Python REPL.

#### Up/down arrow

As you type commands in to your terminal, your terminal will remember some number of the last commands you used. Press up arrow to go through your old commands. (You can go back down with down arrow.)

#### Tab

Tab completion is a beautiful thing. It can be used, most notably, in a lot of text editors and every Linux terminal. Tab complete can be an excellent way to see what completions are available, avoid typos, and become **much** faster at using your computer.

### Relative vs Absolute Paths

Say your current working directory is your `home` dir and you'd like to know the contents of your `Documents` directory. You can achieve that like so:

``` shell
ls /Users/gastove/Documents/
```

This is correct, but a little unwieldy – that's a long command to type. We get the same effect, however, typing this:

``` shell
ls Documents/
```

Here, we're referring to `Documents` *relative* to your home dir. That is, since the directory `Documents` is within the directory `home`, we can simply say `Documents`.

There are two other ways to write exactly the same command we've been using:

``` shell
ls ./Documents/
```

and

``` shell
ls ~/Documents/

```

The first uses Linux' `./` syntax, which means, "here, in current working directory". The second uses `, which is a short hand for your ~home` dir.

Now: what if you want to list the contents of `/tmp`? The command is exactly what you'd expect:

``` shell
ls /tmp
```

The leading `/` says, "start at the root of the file system". The leading `/` is absolute. Any path starting with a `/` is said to be the *fully qualified* path – that is, it is **not** relative. Relative paths change with the context of current working directory; a fully qualified path always refers to the same thing.

Another way to think about this is: relatve paths undergo what's called "expansion". Under the hood, `Documents` and `~/Documents` both get "expanded" to the fully qualified path `/Users/Documents`. The leading slash means, "don't expand this, I'm going to tell you exactly what I want."

There's two other things to know with relative paths: `.` and `..`

`.` (dot) can be a pain, because it's *overloaded*. That is, it means a lot of different things, depending on context. In the context of paths, dot means "here" (mentioned briefly above).

`..` (double-dot) means, "the next level of the hierarchy, going up."

So for instance:

``` shell
ls ~/..
```

Lists the level *up* from your home dir – which is to say, it lists all the home dirs on your computer.

### A Quick Note about Trailing Slashes

These two commands do exactly the same thing:

``` shell
ls /tmp

ls /tmp/
```

A trailing slash on a path tells your computer, "this is definitely a path." The tricky part is, this is optional sometimes and required others. With `ls`, for instance, your computer will "do the right thing" and just list whatever you give it. With things like copying commands – like `cp`, `scp`, and `rsync` – it becomes very important to say, "this one is a file and this one is a dir". Whee?

### Hidden Files

A lot of important files on your computer are *hidden* by default. That is, they don't show up when you do this:

``` shell
ls ~/
```

But if you do *this*:

``` shell
ls -la ~/
```

You get a **lot** more stuff. Notice all the files with a leading dot? The dot (I said it was overloaded) tells the operating system not to normally show the thing with the dot at the front of its name. Dotted files are used as configuration files of all shapes and varieties, and now you know how to find them.

For reference: the `-la` at the end of the `ls` is a type of argument called a "flag". There are two of them: `l` for "list"; `a` for "all". We'll be going over flags in much greater detail later, but for now, `ls -la` is an excellent command to know if you want to see *everything* in a directory.

### Links

One last creature in the menagerie to discuss: links. A link makes a kind of short-cut between one part of the file hierarchy and another. This can be… a little brain meddling. The salient detail is this: a file linked to a directory behaves as a member of both directories. You'll see links indicated as an arrow from link name to the link location, like so:

``` shell
lrwxr-xr-x    1 gastove  staff      37 Dec 11 22:08 .inputrc -> /Users/gastove/.dotfiles/bash/inputrc
```

There's a lot of that here in this document in the Hidden Files section. What that says is, "if somebody comes looking for the file named .inputrc, give them the contents of *Users/gastove*.dotfiles/inputrc".

Package Management
------------------

On OS X, this means `brew`; for all other \*nix, it's platform-specific.

On OS X, open your terminal and install homebrew thus:

``` shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

You can now search for, get information about, and install an incredible array of packages:

``` shell
brew search git  # What packages with names like "git" are available?
brew info git    # Tell me about the git package!
brew install git # Gimmie git!
```

**Note: Do not use brew with sudo**. You *will* need to use `sudo` to install brew; you do *not* need to use sudo to install packages with brew. Let's review:

``` shell
# Correct
brew install git

# NO! NO NO NO!
sudo brew install git # <- DO NOT DO THIS
```

Homework
--------

1.  Accept github invite!
2.  Slack all set up and ready to go!
3.  Read Blabs' [configuration file](https://github.com/reed-college/blabs-config); think about gifs or commands to add next week.
4.  Play with text editors! Figure out how to install a linter. Learn how to jump forward/backaward up/down by word/sentence/paragraph. Learn how to jump from an opening symbol, like {, to it's matching close, }.
5.  Start thinking about users you care about! Who would you want to build for?
