# Text Editors vs. IDEs

Loose guidelines:

1.  All code is text, so all code can be read in a text editor. Find a *real*, code
    specific text editor with first-class support for code tools like syntax
    highlighting, formatting, and linting -- but other than that? You do you.
2.  That said, compiled languages -- Java, for instance -- benefit a lot from
    some of the tools you get with an IDE. IDEs usually aren't general, so it's
    worth getting to know an editor as well, but IDEs are excellent toolkits for
    the specific languages they support.
3.  The Text Editor holy war is a crock of nonsense.

## Editors

Text editors are built for one thing: editing text. (Surprise, right?) A good
text editor supports tools for writing code in many different programming
languages. Microsoft Word? Not a text editor; neither is Google Docs. Text
Editors pair well with using the Terminal directly.

You can use most text editors as-is, but I recommend, at a minimum, that your
editor support and have installed the following tools:

-   Syntax Highlighting
-   Linting (automatic, often real-time detection of syntax errors)
-   Autocompletion

Really nice to have:

-   Some kind of integration with revision control
-   Search and jump
-   ...I dunno, what do *you* want it to be able to do?

### Sublime Text and Atom

-   Friendly as hell
-   Sublime Text (Python); Atom (JavaScript)
-   Pretty simple, but that's very good news. (They're **just** text editors.)
-   Pretty simple, and maybe you want a little more out of your tools.

### Emacs

-   Type words, get words. (Key chord-driven commands.)
-   ...but also it's backed by a lisp! Maybe you think that's great? Maybe it's
    the worst.
-   It's a text editor!
-   ...and an IDE!
-   ...and maybe also an operating system?
-   The gold standard in customizabile and extensible editors.

### Vim

-   Type words, get lost
-   Modal editing is powerful as hell, once you get your head around it. (And Vim
    is pretty much the only system that gets it right.)
-   Extensible with VimScript, which is a hideous nightmare-fuel of a pseudo-language
-   Installed by default, in at least some version, on almost every *nix-based
    computer you will ever ever touch.
-   Loads almost instantaneously.

### Note:

Part of the virtue of both Emacs and Vim is that they are first-class text
editors that will run in the Terminal, and/or interact natively with tools like
`ssh` and `rsync`. If you're likely to edit files that live on remote servers, it'll
be a great benefit to you to be able to use one of Emacs or Vim with at least
some familiarity.

## IDEs

### Emacs again

### JetBrains IDEAs

# The File System and an introduction to the Terminal

The file system is an interface to the data stored on your computer. Here's the
short short version:

> The file system represents data in a hierarchy, in which folders contain files,
> other folders, and links to files or folders elsewhere in the hierarchy. We can
> browse and manipulate this hierarchy with GUI tools, like Finder or Windows
> Explorer, or through the Terminal.

...okay great. What on *earth* does that mean in practice?

## File System Basics

Open your terminal. There's a blinking cursor. Your computer is waiting for you
to type a command, tell it what you'd like it to do. Great so far.

When you interact with the file system, you are always *in* the file system. That
is: your commands always have a context, and that context is some place, some
directory, in the filesystem. When you open your terminal, you start by viewing
the contents of a directory called your `home` directory. Every user of a Linux
computer has their own `home` dir, specific to them. You can see what directory
you're currently in by typing the  `pwd` command and hitting enter, so:

```sh
pwd
```

    /Users/gastove

Change which directory you're viewing using the `cd` command:

```sh
cd /tmp
pwd
```

    /tmp

Your `home` dir has a few special properties we'll get to as we go. First up is:
you can always return to your home directory by typing `cd` without specifying
which directory you want to go to:

```sh
cd
pwd
```

    /Users/gastove

The directory you're currently *in* is referred to as your *working directory*. (The
`pwd` command we used before stands for "print working directory".) You can list
the contents of your working directory with `ls`:

```sh
ls
```

    Applications
    Code
    Desktop
    Documents
    Downloads
    Dropbox
    Library
    Movies
    Music
    Pictures
    Public
    bin
    dump.rdb
    node_modules
    ssl-ca-cert.pem
    test.txt
    test.txt.gpg

Say it with me: ooooooooooooooh.

## A few useful keyboard shortcuts

### Ctrl-c / Ctrl-d

Ctrl-c is the keyboard interrupt command -- if you start something running and
you want it to stop, Ctrl-c will *usually* help. Ctrl-d is an exit command, useful
for quitting things like the Python REPL.

### Up/down arrow

As you type commands in to your terminal, your terminal will remember some
number of the last commands you used. Press up arrow to go through your old
commands. (You can go back down with down arrow.)

### Ctrl-r

Speaking of previous commands that you've used, you can also search through those remembered commands with Ctrl-r. Just hit Ctrl-r, and start typing some part of the command you are looking for. Once you have a few characters typed and start seeing good results, hitting Ctrl-r again will take you to the previous matching command you typed.

### Tab

Tab completion is a beautiful thing. It can be used, most notably, in a lot of
text editors and every Linux terminal. Tab complete can be an excellent way to
see what completions are available, avoid typos, and become **much** faster at using
your computer.

## Relative vs Absolute Paths

Say your current working directory is your `home` dir and you'd like to know the
contents of your `Documents` directory. You can achieve that like so:

```sh
ls /Users/gastove/Documents/
```

    Cornbread Dressing--Traditional Family Style.htm
    Cornbread by Mother.htm
    Data
    Friends
    From Archivist
    IMG_20140425_190148087.jpg
    IMG_2498.MOV
    List.pdf
    OJD Courts ePay Confirmation.pdf
    Principal Component Analysis of Binary Data. Applications to Roll-Call-Analysis.pdf
    SDS2016KickoffMeetingAgenda.txt
    Storage
    cider-refcard.pdf
    nnir:nnir-m2ioh56g5v.fsf
    org
    projects
    rbbt_img.jpg
    rbbt_img.jpg.gpg
    test

This is correct, but a little unwieldy -- that's a long command to type. We get
the same effect, however, typing this:

```sh
ls Documents/
```

    Cornbread Dressing--Traditional Family Style.htm
    Cornbread by Mother.htm
    Data
    Friends
    From Archivist
    IMG_20140425_190148087.jpg
    IMG_2498.MOV
    List.pdf    
    OJD Courts ePay Confirmation.pdf
    Principal Component Analysis of Binary Data. Applications to Roll-Call-Analysis.pdf
    SDS2016KickoffMeetingAgenda.txt
    Storage
    cider-refcard.pdf
    nnir:nnir-m2ioh56g5v.fsf
    org
    projects
    rbbt_img.jpg
    rbbt_img.jpg.gpg
    test

Here, we're referring to `Documents` *relative* to your home dir. That is, since
the directory `Documents` is within the directory `home`, we can simply say
`Documents`.

There are two other ways to write exactly the same command we've been using:

```sh
ls ./Documents/
```

and

```sh
ls ~/Documents/
```

The first uses Linux' `./` syntax, which means, "here, in current working
directory". The second uses ~, which is a short hand for your `home` dir.

Now: what if you want to list the contents of `/tmp`? The command is exactly what
you'd expect:

```sh
ls /tmp
```

    KSOutOfProcessFetcher.0.sAglCyxY5lzPoNgfmEvv-ZqGl-w=
    KSOutOfProcessFetcher.501.sAglCyxY5lzPoNgfmEvv-ZqGl-w=
    com.apple.launchd.6NyZdbPEvD
    com.apple.launchd.Ef4hcVmPbo
    com.apple.launchd.Oe9NDK7qNL
    com.apple.launchd.carQq0K5lQ

The leading `/` says, "start at the root of the file system". The leading `/` is
absolute. Any path starting with a `/` is said to be the *fully qualified* path --
that is, it is **not** relative. Relative paths change with the context of current
working directory; a fully qualified path always refers to the same thing.

Another way to think about this is: relatve paths undergo what's called
"expansion". Under the hood, `Documents`  and `~/Documents` both get "expanded" to
the fully qualified path `/Users/Documents`. The leading slash means, "don't
expand this, I'm going to tell you exactly what I want."

There's two other things to know with relative paths: `.` and `..`

`.` (dot) can be a pain, because it's *overloaded*. That is, it means a lot of
different things, depending on context. In the context of paths, dot means
"here" (mentioned briefly above).

`..` (double-dot) means, "the next level of the hierarchy, going up."

So for instance:

```sh
ls ~/..
```

    Guest
    Shared
    gastove

Lists the level *up* from your home dir -- which is to say, it lists all the home
dirs on your computer.

## A Quick Note about Trailing Slashes

These two commands do exactly the same thing:

```sh
ls /tmp

ls /tmp/
```

A trailing slash on a path tells your computer, "this is definitely a path." The
tricky part is, this is optional sometimes and required others. With `ls`, for
instance, your computer will "do the right thing" and just list whatever you
give it. With things like copying commands -- like `cp`, `scp`, and `rsync` -- it
becomes very important to say, "this one is a file and this one is a dir". Whee?

## Hidden Files

A lot of important files on your computer are *hidden* by default. That is, they
don't show up when you do this:

```sh
ls ~/
```

    Applications
    Code
    Desktop
    Documents
    Downloads
    Dropbox
    Library
    Movies
    Music
    Pictures
    Public
    bin
    dump.rdb
    node_modules
    ssl-ca-cert.pem
    test.txt
    test.txt.gpg

But if you do *this*:

```sh
ls -la ~/
```

    total 992
    drwxr-xr-x+  68 gastove  staff    2312 Feb 10 23:24 .
    drwxr-xr-x    6 root     admin     204 Oct 25 19:52 ..
    -r--------    1 gastove  staff       7 Oct 25 19:50 .CFUserTextEncoding
    -rw-r--r--@   1 gastove  staff   14340 Jan 24 12:37 .DS_Store
    drwxr-xr-x   10 gastove  staff     340 Aug  5  2015 .Mail
    lrwxr-xr-x    1 gastove  staff      39 Dec 11 22:08 .Rprofile -> /Users/gastove/.dotfiles/extra/Rprofile
    drwx------   41 gastove  staff    1394 Feb  4 12:45 .Trash
    lrwxr-xr-x    1 gastove  staff      36 Dec 11 22:08 .ackrc -> /Users/gastove/.dotfiles/extra/ackrc
    -rw-r--r--    1 gastove  staff     210 Jun 28  2015 .authinfo.gpg
    -rw-r--r--    1 gastove  staff   14454 Feb 21 10:57 .bash_history
    lrwxr-xr-x    1 gastove  staff      42 Dec 11 22:08 .bash_profile -> /Users/gastove/.dotfiles/bash/bash_profile
    -rwxr-xr-x    1 gastove  staff     598 Dec 24 20:43 .bash_profile.local
    drwxr-xr-x    7 gastove  staff     238 Oct 25 20:27 .bash_sessions
    lrwxr-xr-x    1 gastove  staff      36 Dec 11 22:08 .bashrc -> /Users/gastove/.dotfiles/bash/bashrc
    drwxr-xr-x    3 gastove  staff     102 Nov  6 18:56 .cache
    drwxr-xr-x   14 gastove  staff     476 Oct 25 20:20 .dotfiles
    drwx------   13 gastove  staff     442 Feb 18 19:39 .dropbox
    -rw-r--r--    1 gastove  staff    5489 Feb  6 13:24 .emacs-bmk-bmenu-state.el
    lrwxr-xr-x    1 gastove  staff      30 Oct 25 20:25 .emacs.d -> /Users/gastove/.dotfiles/emacs
    drwxr-xr-x    3 gastove  staff     102 Oct 25 20:41 .erc
    -rw-r--r--    1 gastove  staff      61 Dec 25 18:37 .eslintrc
    lrwxr-xr-x    1 gastove  staff      37 Dec 11 22:08 .floorc -> /Users/gastove/.dotfiles/extra/floorc
    lrwxr-xr-x    1 gastove  staff      42 Dec 11 22:08 .gitattributes -> /Users/gastove/.dotfiles/git/gitattributes
    -rwxr-xr-x    1 gastove  staff    2181 Oct 25 20:20 .gitconfig
    lrwxr-xr-x    1 gastove  staff      38 Dec 11 22:08 .gitignore -> /Users/gastove/.dotfiles/git/gitignore
    drwx------   12 gastove  staff     408 Jan 30 12:42 .gnupg
    drwxr-xr-x   11 gastove  staff     374 Nov 29 00:08 .heroku
    lrwxr-xr-x    1 gastove  staff      37 Dec 11 22:08 .inputrc -> /Users/gastove/.dotfiles/bash/inputrc
    drwxr-xr-x    5 gastove  staff     170 Oct 31 18:28 .ipython
    drwxr-xr-x    3 gastove  staff     102 Dec 11 22:08 .lein
    -rw-------    1 gastove  staff      39 Dec 25 10:02 .lesshst
    drwx------    3 gastove  staff     102 Nov  5 21:37 .local
    drwxr-xr-x    3 gastove  staff     102 Oct 27 21:13 .m2
    drwx------    5 gastove  staff     170 Oct 25 22:34 .mu
    -rw-------    1 gastove  staff     194 Nov 27 22:36 .netrc
    drwxr-xr-x    5 gastove  staff     170 Dec 24 13:21 .node-gyp
    drwxr-xr-x  823 gastove  staff   27982 Dec 24 20:49 .npm
    -rw-------    1 gastove  staff      36 Aug  8  2015 .npmrc
    drwx------    9 gastove  staff     306 Feb 21 11:08 .offlineimap
    -rw-r--r--    1 gastove  staff      15 May 11  2015 .offlineimap.py
    -rw-r--r--    1 gastove  staff     146 May 11  2015 .offlineimap.pyc
    -rw-r--r--    1 gastove  staff    1642 Feb 10 17:56 .offlineimaprc
    drwxr-xr-x    3 gastove  staff     102 Oct 27 20:27 .oracle_jre_usage
    -rw-------    1 gastove  staff      99 Oct 31 18:05 .psql_history
    -rw-------    1 gastove  staff     790 Nov  2 21:14 .python_history
    drwxr-xr-x   15 gastove  staff     510 Oct 31 17:58 .python_virtualenvs
    -rw-r--r--    1 gastove  staff      60 Nov  5 21:30 .racketrc
    drwx------    5 gastove  staff     170 Nov 15  2013 .ssh
    -rw-r--r--    1 gastove  staff   49752 Nov  5 21:39 .twittering-mode-icons.gz
    -rw-------    1 gastove  staff     238 Feb 20  2014 .twittering-mode.gpg
    -rw-r--r--    1 gastove  staff    8456 Nov 29 00:09 .v8flags.4.6.85.31.gastove.json
    drwx------    4 gastove  staff     136 Oct 25 20:31 Applications
    drwxr-xr-x   68 gastove  staff    2312 Jan 14 21:41 Code
    drwx------+   5 gastove  staff     170 Feb 20 22:04 Desktop
    drwx------@  24 gastove  staff     816 Feb  2 12:02 Documents
    drwx------+  31 gastove  staff    1054 Feb 20 22:04 Downloads
    drwx------@  64 gastove  staff    2176 Feb 18 19:39 Dropbox
    drwx------@  54 gastove  staff    1836 Dec 19 21:50 Library
    drwx------+   3 gastove  staff     102 Oct 25 19:50 Movies
    drwx------+ 129 gastove  staff    4386 Feb 20 15:44 Music
    drwx------+  15 gastove  staff     510 Oct 25 22:52 Pictures
    drwxr-xr-x+   5 gastove  staff     170 Oct 25 19:50 Public
    drwxr-xr-x    4 gastove  staff     136 Nov  7 09:12 bin
    -rw-r--r--    1 gastove  staff     135 Feb 10 23:24 dump.rdb
    drwxr-xr-x    3 gastove  staff     102 Dec 25 18:32 node_modules
    -rw-r--r--    1 gastove  staff  289081 Nov 29 16:35 ssl-ca-cert.pem
    -rw-r--r--    1 gastove  staff       4 Nov  5 21:09 test.txt
    -rw-r--r--    1 gastove  staff     344 Nov  5 21:10 test.txt.gpg

You get a **lot** more stuff. Notice all the files with a leading dot? The dot (I
said it was overloaded) tells the operating system not to normally show the
thing with the dot at the front of its name. Dotted files are used as
configuration files of all shapes and varieties, and now you know how to find
them. 

For reference: the `-la` at the end of the `ls` is a type of argument called a
"flag". There are two of them: `l` for "list"; `a` for "all". We'll be going
over flags in much greater detail later, but for now, `ls -la` is an excellent
command to know if you want to see _everything_ in a directory.

## Links

One last creature in the menagerie to discuss: links. A link makes a kind of
short-cut between one part of the file hierarchy and another. This can be... a
little brain meddling. The salient detail is this: a file linked to a directory
behaves as a member of both directories. You'll see links indicated as an arrow
from link name to the link location, like so:

```sh
lrwxr-xr-x    1 gastove  staff      37 Dec 11 22:08 .inputrc -> /Users/gastove/.dotfiles/bash/inputrc
```

There's a lot of that here in this document in the Hidden Files section. What
that says is, "if somebody comes looking for the file named .inputrc, give them
the contents of /Users/gastove/.dotfiles/inputrc". 

# Package Management

On OS X, this means `brew`; for all other \*nix, it's platform-specific.

On OS X, open your terminal and install homebrew thus:

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

You can now search for, get information about, and install an incredible array
of packages:

```sh
brew search git  # What packages with names like "git" are available?
brew info git    # Tell me about the git package!
brew install git # Gimmie git!
```

**Note: Do not use brew with sudo**. You *will* need to use `sudo` to install brew; you
do *not* need to use sudo to install packages with brew. Let's review:

```sh
# Correct
brew install git

# NO! NO NO NO!
sudo brew install git # <- DO NOT DO THIS
```

# Regular Expressions

I'm going to wing this if we have time.
