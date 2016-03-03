Okay: we know how to work a terminal. We know how to clone a git repo. Let's start pulling the pieces together. We'll start with some software development tools, and their relationship with our computers.

Getting Going: `virtualenvs` and `virtualenvwrapper`
----------------------------------------------------

Let's get rocking with two of the very few python packages you always want installed globally: [virtualenv](https://virtualenv.readthedocs.org/en/latest/) and [virtualenvwrapper](https://virtualenvwrapper.readthedocs.org/en/latest/). The installation is done with `pip`, and is the easy part:

``` src
pip install virtualenv virtualenvwrapper
```

But… what are they *for*? What do they *do*? Let's have a motivating example, shall we?

Imagine you've installed python 3 as the default version of python on your computer. What's more, you've been noodling around a bunch in the python interpreter, using the `requests` library to do HTTP requests and the `beautifulsoup` library to parse the results. You're having a perfectly nice time, until you decide to contribute to an open source project. You clone it, manually install a stack of dependencies for it, and… it detonates spectacularly. It was written for python 2! It uses an antique version of `requests` and an even older version of `beautifulsoup`! Sturm und drang! Gnashing of teeth! If only there were a better way to separate your *system* from a *project*.

You can, perhaps, see where this is going.

`virtualenv` and `virtualenvwrapper` are two indispensable tools for, effectively, putting your projects in tidy boxes and managing them separately from the rest of your system. They work through a combination of *environment variables* and manipulation of the Linux *path*. Let's talk about what on earth that means.

### The Environment

So far, we've been considering the Terminal an interface to the file system. But it's more: the Terminal is, in some sense, very much like the python interpreter. That is, it's a running instance of a program which interprets commands and produces output. In this case, the interpreter is a "shell", which is also the broad family of languages we're now using. By default, OSX systems use Bourne Again SHell, usually called BASH. There's a small multitude of others. We wont be discussing them ;-P

When you open a terminal, you are interacting with a shell *session*. Like python, BASH has a notion of *variables*, many of which are set by default when you start a session. These variables are part of your *environment*, and are referred to as *environment variables*.

Remember when I told you your home dir is special to your computer? Here's another way that shows up: one environment variable set in every BASH session is called `HOME`. (By convention, environment variables are always upper case.) We can view the value of `HOME` using two things: a dollar sign, and `echo`, thus:

``` src
echo $HOME
```

``` example
/Users/gastove
```

Similarly, your user name is sorted in a variable called `USER`:

``` src
echo $USER
```

``` example
gastove
```

You can see your entire environment all at once using the `printenv` command. I'm not going to put the results of that here for two reasons:

1.  The list can be *quite* long
2.  It's not uncommon to store sensitive information, like api keys and passwords, in environment variables. I *really* don't want to accidentally put one of those in a public github.

That said: check out `printenv` on your own machine!

Now, there's a particular environment variable we particularly care about right now. You could view it with `echo`, but we're going to find it's value a different way: piping and grep.

### Standard In, Standard Out, Pipes, and Grep

When you type `echo $HOME`, your home dir appears in your terminal, and then you're returned to your prompt. Something like this, probably:

``` example
$ echo $HOME
/Users/rossdonaldson
$
```

What we're seeing is the result of a program, `echo`, printing the value of a variable, `HOME`, to *standard out*. Often written *stdout*, standard out is one of the three Linux standard streams. (Like many Linux things, the name hearkens back to a day when computers worked very differently, and is now mostly a legacy.) stdout equates to, "just stream the results of doing FOO back to whoever asked me to FOO" – in this case, us, our terminal, echoing `HOME`.

Now, what if we want to send that output somewhere *other* than our terminal? For instance, we could save it to a file, using the `>` operator:

``` src
mkdir -p /tmp/dev-demo && cd /tmp/dev-demo
printenv > my_env.txt
ls -l
```

``` example
total 8
-rw-r--r--  1 gastove  wheel  877 Mar  2 20:00 my_env.txt
```

The contents of my environment have been written to a file called my\_env.txt. Note that `>` means, "take the results of the thing on the left and make them be the contents of the thing on the right" – it's a destructive operation:

``` src
echo 'no more env here' > my_env.txt
cat my_env.txt
```

``` example
no more env here
```

For non-destructive addition, you could use `>>`:

``` src
echo 'but now there is other stuff so ok?' >> my_env.txt
cat my_env.txt
```

``` example
no more env here
but now there is other stuff so ok?
```

For a lark, we could count the lines in this file. To do this, we'll use the word count program, `wc`, passing the `-l` file to count… lines.

``` src
wc -l my_env.txt
```

``` example
2 my_env.txt
```

Okay, so that's good and useful. But what if we wanted to actually count the number of variables in our environment? Sure, we could `printenv` in to a file and then `wc -l` it, but there's a better way. For this, the operator we want is Pipe. The pipe operator, `|`, shares the back-slash key on a stock Mac keyboard. It means, "take the results of the thing on my left and send them to the thing on my right". We can now count the number of variables in our environment without using a file at all:

``` src
printenv | wc -l
```

``` example
17
```

What we're really doing is making use of one of the other three standard streams: standard input, or *stdin*. Most Linux command-line utilities can operate on a file **or**, if a file name is omitted, read from stdin. Pipe means, "take the stdout stream from the thing on the left and feed it to stdin on the right". (Similarly, `>` is, "take stdout from the left and write it to a file on the right", and `>>` is, "take stdout from the left and *append* it to a file on the right".)

Okay so counting variables is fine, but let's see something more useful: `grep`. `grep` searches for a pattern in a place, line by line. That place can be a file, sure – but more useful is a stream. Let's grep our environment to find the value of our PATH:

``` src
printenv | grep PATH
```

``` example
PATH=/usr/local/bin:/Applications/Postgres93.app/Contents/MacOS/bin:/usr/local/heroku/bin:/Users/gastove/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/Library/TeX/texbin:/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_9:/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_9:./node_modules/.bin:/usr/bin:/Users/gastove/bin:/Users/gastove/.dotfiles/bin
```

Blam!

### The PATH

So what exactly *is* the `PATH`, anyhow? First: see how there's all those colons in there? Let's look at the PATH another way:

``` src
IFS=":" read -r -a paths <<< "$PATH"

for p in "${paths[@]}"; do echo $p; done
```

``` example
/usr/local/bin
/Applications/Postgres93.app/Contents/MacOS/bin
/usr/local/heroku/bin
/Users/gastove/bin
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
/usr/local/MacGPG2/bin
/Library/TeX/texbin
/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_9
/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_9
./node_modules/.bin
/usr/bin
/Users/gastove/bin
/Users/gastove/.dotfiles/bin
```

The `PATH` is a concatenated list of directories, separated by `:`. The `PATH` tells the shell how to find programs so you can run them. Let's have an example: say you want to run `git`. The program `which` will tell you a) if a program can be found by a given name, and b) which program it is, so:

``` src
which git
```

``` example
/usr/local/bin/git
```

That was easy. We can confirm there really is a `git`-named thing in `/usr/local/bin` using `ls` and `grep` and our new Linux-pipe-friend:

``` src
ls -l /usr/local/bin | grep git
```

``` example
lrwxr-xr-x  1 gastove  admin        27 Jan 25 21:05 git -> ../Cellar/git/2.7.0/bin/git
lrwxr-xr-x  1 gastove  admin        50 Jan 25 21:05 git-credential-osxkeychain -> ../Cellar/git/2.7.0/bin/git-credential-osxkeychain
lrwxr-xr-x  1 gastove  admin        37 Jan 25 21:05 git-cvsserver -> ../Cellar/git/2.7.0/bin/git-cvsserver
lrwxr-xr-x  1 gastove  admin        40 Jan 25 21:05 git-receive-pack -> ../Cellar/git/2.7.0/bin/git-receive-pack
lrwxr-xr-x  1 gastove  admin        33 Jan 25 21:05 git-shell -> ../Cellar/git/2.7.0/bin/git-shell
lrwxr-xr-x  1 gastove  admin        35 Jan 25 21:05 git-subtree -> ../Cellar/git/2.7.0/bin/git-subtree
lrwxr-xr-x  1 gastove  admin        42 Jan 25 21:05 git-upload-archive -> ../Cellar/git/2.7.0/bin/git-upload-archive
lrwxr-xr-x  1 gastove  admin        39 Jan 25 21:05 git-upload-pack -> ../Cellar/git/2.7.0/bin/git-upload-pack
lrwxr-xr-x  1 gastove  admin        28 Jan 25 21:05 gitk -> ../Cellar/git/2.7.0/bin/gitk
```

That's a lot of stuff with `git` in the name! And one of them is exactly what we were looking for: `git` itsown self.<sup><a href="#fn.1" id="fnr.1" class="footref">1</a></sup>

The thing to understand about the `PATH` is that your shell searches it *in order*, looking for a program that matches what you've asked for.

### Bringing it back to `virtualenvs`

A `virtualenvironment` works like this: a user-specified version of python (with a matching installation of pip) is installed in to a directory. Then, when the `virtualenv` is *activated*, the `PATH` is altered: `virtualenv` temporarily appends its install directory to the front of the `PATH`. This means that when you ask for `python`, you'll get the `virtualenv`-specified version, and any packages installed with pip will be of a specified version. Let's see how this works in practice.

First: which python is my default, system python?

``` src
which python
```

``` example
/usr/local/bin/python
```

Great. Now let's make a `virtualenv`:

``` src
cd /tmp && mkdir venv-demo && cd venv-demo
virtualenv .
```

``` example
New python executable in ./bin/python2.7
Also creating executable in ./bin/python
Installing setuptools, pip, wheel...done.
```

Great! Our new `virtualenv` is done. We activate it by sourcing a shell script called `activate` in a dir called `bin` (the traditional name for a directory of `binaries`, or executables):

``` src
source bin/activate
which python
```

``` example
/private/tmp/venv-demo/bin/python
```

Et voila! We're now using a totally different python. `virtualenv`: activated. Now, when we install packages with pip, they'll be specific to this environment, not affecting our global state or other projects. `virtualenv` has appended its own directories to the front of the `PATH`:

``` src
source bin/activate
echo $PATH
```

``` example
/private/tmp/venv-demo/bin:/usr/local/bin:/Applications/Postgres93.app/Contents/MacOS/bin:/usr/local/heroku/bin:/Users/gastove/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/Library/TeX/texbin:/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_9:/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_9:./node_modules/.bin:/usr/bin:/Users/gastove/bin:/Users/gastove/.dotfiles/bin
```

When we `source` the `activate` script, we gain a new command: `deactivate`. It – brace yourself for this – deactivates the `virtualenv`:

``` src
deactivate
```

### Managing `virtualenvs`

`virtualenvs` are good news; they help us solve the otherwise maddening problem of dependencies and python versions. But, now we have a new problem. Consider the contents of our project directory now:

``` src
ls -la
```

``` example
total 8
drwxr-xr-x   6 gastove  wheel  204 Mar  2 20:00 .
drwxrwxrwt  22 root     wheel  748 Mar  2 20:00 ..
lrwxr-xr-x   1 gastove  wheel   79 Mar  2 20:00 .Python -> /usr/local/Cellar/python/2.7.11/Frameworks/Python.framework/Versions/2.7/Python
drwxr-xr-x  15 gastove  wheel  510 Mar  2 20:00 bin
drwxr-xr-x   3 gastove  wheel  102 Mar  2 20:00 include
drwxr-xr-x   3 gastove  wheel  102 Mar  2 20:00 lib
```

`bin` is a directory of `virtualenv` stuff. `lib` is full of python executables. `lib` is where pip installs packages into the `virtualenv` itself. Convinced this is a mess yet? No? Consider:

``` src
git init
git status
```

``` example
Initialized empty Git repository in /private/tmp/venv-demo/.git/
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

    .Python
    bin/
    include/
    lib/

nothing added to commit but untracked files present (use "git add" to track)
```

You do *not* want any of that nonsense in `git`. One solution is a good `.gitignore`, which wouldn't be bad, but is easy to get wrong. Instead, consider: when we activate a `virtualenv`, it appends its own binaries to the front of the `PATH`. What's stopping us from storing those binaries *somewhere else all together*? The answer is: absolutely nothing. `virtualenvwrapper` is a tool that helps us do exactly this, while providing a very clean interface.

### Setting up and using `virtualenvwrapper`

`virtualenvwrapper` gives you the ability to set a single, configurable location into which all your `virtualenvs` will be installed. `virtualenvwrapper` uses an environment variable to configure where it does its installation, so the first thing to do is to get that set.

We've already checked the value of environment variables. There are two common ways of setting them: per session and globally.

To set a variable only in your current BASH session, use the `export` command:

``` src
export PLABBER='I am the plabber'
echo $PLABBER
```

``` example
I am the plabber
```

This variable will vanish if you exit or reload your terminal, so it's a handy way to test something and a bad way to keep it.

More commonly, we want new environment variables to persist. To do this, we use the same syntax as per-session, but instead of typing it in to the terminal, we write it in to a configuration file. BASH recognizes several configuration files; on OSX, users typically edit their `.bash_profile`. For instance:

``` src
echo "export PLABBER='I am the plabber'" >> ~/.bash_profile
```

Now `PLABBER` is a permanent member of my profile. Glee.

In any case: back to `virtualenvwrapper`, which looks for an environment variable called `WORKON_HOME`. Mine is set in my `.bash_profile`, like this:

``` src
export WORKON_HOME=~/.python_venvs
```

While you're editing your `.bash_profile`, `virtualenvwrapper` has one other thing that needs doing: it provides a file that needs to be *sourced* – that is, read in to the current environment, much like `virtualenv`'s `activate` script – so that we gain its full power. Add this, too:

``` src
source /usr/local/bin/virtualenvwrapper.sh
```

Now, things get good.

### A quick tour of `virtualenvwrapper`

``` src
export PS1="$"
```

``` src
source /usr/local/bin/virtualenvwrapper.sh
```

You now have access to a set of marvelously useful commands with excellent properties. For instance: imagine we've made a new directory and we're setting up a python project in it:

``` src
cd /tmp && mkdir -p venv/venv-wrapper-demo && cd venv/venv-wrapper-demo
git init
echo "print 'hello world'" > hello.py
ls -la
```

``` example
Initialized empty Git repository in /private/tmp/venv/venv-wrapper-demo/.git/
total 8
drwxr-xr-x  4 gastove  wheel  136 Mar  2 20:00 .
drwxr-xr-x  3 gastove  wheel  102 Mar  2 20:00 ..
drwxr-xr-x  9 gastove  wheel  306 Mar  2 20:00 .git
-rw-r--r--  1 gastove  wheel   20 Mar  2 20:00 hello.py
```

We decide it's time for a `virtualenv`. Instead of using the `virtualenv` command directly, we use `mkvirtualenv`:

``` src
mkvirtualenv venv-demo
```

``` example
New python executable in venv-demo/bin/python2.7
Also creating executable in venv-demo/bin/python
Installing setuptools, pip, wheel...done.
virtualenvwrapper.user_scripts creating /Users/gastove/.python_virtualenvs/venv-demo/bin/predeactivate
virtualenvwrapper.user_scripts creating /Users/gastove/.python_virtualenvs/venv-demo/bin/postdeactivate
virtualenvwrapper.user_scripts creating /Users/gastove/.python_virtualenvs/venv-demo/bin/preactivate
virtualenvwrapper.user_scripts creating /Users/gastove/.python_virtualenvs/venv-demo/bin/postactivate
virtualenvwrapper.user_scripts creating /Users/gastove/.python_virtualenvs/venv-demo/bin/get_env_details
```

Now, in our project dir we see:

``` src
ls -la
```

``` example
total 8
drwxr-xr-x  4 gastove  wheel  136 Mar  2 20:00 .
drwxr-xr-x  3 gastove  wheel  102 Mar  2 20:00 ..
drwxr-xr-x  9 gastove  wheel  306 Mar  2 20:00 .git
-rw-r--r--  1 gastove  wheel   20 Mar  2 20:00 hello.py
```

Nothing different at all! The `virtualenv` has been created in an entirely different location. We can list our available `virtualenvs` like so:

``` src
lsvirtualenv -b #-b is "brief mode"; output can be long
```

``` example
l03-slackbort
venv-demo
vrfy
```

We can activate a `virtualenv` with the `workon` command:

``` src
workon venv-demo
```

And we can still deactivate with `deactivate`.

Starting Development
--------------------

Step one: clone the repo

``` src
cd /tmp && mkdir l03 && cd l03
git clone git@github.com:Gastove/slackbort.git
```

Step two: `cd` in to that directory and have a look around:

``` src
cd slackbort && ls -la
```

``` example
total 32
drwxr-xr-x   8 gastove  wheel  272 Mar  2 18:37 .
drwxrwxrwt  23 root     wheel  782 Mar  2 20:00 ..
drwxr-xr-x  12 gastove  wheel  408 Mar  2 18:37 .git
-rw-r--r--   1 gastove  wheel   10 Mar  2 18:37 .gitignore
-rw-r--r--   1 gastove  wheel  145 Mar  2 18:37 README.md
-rw-r--r--   1 gastove  wheel   46 Mar  2 18:37 auth.cfg.tpl
-rw-r--r--   1 gastove  wheel   30 Mar  2 18:37 requirements.txt
drwxr-xr-x   4 gastove  wheel  136 Mar  2 18:37 slackbort
```

Notice "requirements.txt" – that's an extremely handy file. By convention, it contains the output of the pip command `freeze`, which prints all installed packages with their versions from the current environment. Conveniently, pip prints this information in a format it can also read, using the `-r <filename>` argument to `pip install`. Let's make `virtualenv` and get the deps for this project installed:

``` src
mkvirtualenv l03-slackbort
```

``` example
New python executable in l03-slackbort/bin/python2.7
Not overwriting existing python script l03-slackbort/bin/python (you must use l03-slackbort/bin/python2.7)
Installing setuptools, pip, wheel...done.
```

``` src
pip install -r requirements.txt
```

(I'm mostly redacting the output from that command, but it should end with something much like this:)

``` example
Successfully installed requests-2.9.1 wheel-0.29.0
```

For the sake of thoroughness, we can now compare `pip freeze` and `requirements.txt`:

``` src
pip freeze
```

``` example
requests==2.9.1
wheel==0.29.0
```

``` src
cat requirements.txt
```

``` example
requests==2.9.1
wheel==0.29.0
```

Perfect.

Footnotes:
----------

<sup><a href="#fnr.1" id="fn.1" class="footnum">1</a></sup>
We can find only git exactly using a regex with `grep`:

``` src
ls -la /usr/local/bin | grep -e 'git$'
```

``` example
lrwxr-xr-x    1 rossdonaldson  wheel        27 Feb 26 12:22 git -> ../Cellar/git/2.7.2/bin/git
```

Author: Ross Donaldson

Created: 2016-03-02 Wed 20:00

[Validate](http://validator.w3.org/check?uri=referer)


