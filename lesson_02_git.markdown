Version Control: What's the point?
----------------------------------

<http://www.phdcomics.com/comics/archive_print.php?comicid=1531>

I will not spend a *ton* of time trying to convince you that version control is good. Mostly, I'm going to assert that version control is good, and then let y'all see it in action over the year. But for reference, here's a best-of version of why you should care:

1.  Track your own work in a durable, recoverable way. If you break it, you can find the change that broke it; if you remove something you shouldn't have you can get it back.
2.  Share code with as many people as you want.
3.  Incorporate changes from as many contributors as you want without having to manually figure out if `important.txt` or `important_latest.txt` or `important_edits_v2.txt-richards` or `imporant_v2_latest.txt.backup.current` is the most important current version.

Version control lets you and your collaborators tell a consistent, comprehensible story about the development of a body of code. This is very good news.

(Distributed) Revision/Version Control
--------------------------------------

### Subversion and Co.

There are a lot of older version control systems, of which subversion is the one I've encountered the most.

### Mercurial

### Git

Git: What Do
------------

Git was originally developed by Linus Torvalds to track development of the Linux operating system. It is a *distributed* version control system, meaning that every copy, or *checkout*, of the code is a parts-complete history of the entire codebase. Under the covers, git is super neat! And also: you don't have to know a whole lot about how git works internally to be able to use it capably.

Here are three things that can be useful to know about git:

### Content-addressable diffing and the sha1 hash

Git is a "Content-addressable" version control framework. What this means in practice is that git separates a file in to two kinds of things: the *contents* of the file and *everything else* about a file. What is "everything else"? File name, path within the repo, information about permissions and creation time – *everything*. This is the property that allows git to compare files from different creators – it looks at whether the *contents* of each file are the same and goes from there.

### The .git dir

A "git repository" is actually just a special kind of directory at the root of a a hierarchy representing a project. So for instance, I have a directory on my computer named `2016_sds_lesson_notes`, which is the root of my lesson notes project. Inside that directory is a directory called `.git`:

``` src
ls -la
              
```

``` example
              total 984
              drwxr-xr-x  16 rossdonaldson  staff     544 Feb  8 12:21 .
              drwxr-xr-x  12 rossdonaldson  staff     408 Jan 31 15:16 ..
              drwxr-xr-x  14 rossdonaldson  staff     476 Feb  8 12:20 .git
              -rw-r--r--   1 rossdonaldson  staff      33 Jan 31 18:58 .gitignore
              -rw-r--r--   1 rossdonaldson  staff     154 Jan 24 14:40 README.markdown
              -rw-r--r--   1 rossdonaldson  staff   35290 Jan 31 18:47 lesson_01_development_environment.html
              -rw-r--r--@  1 rossdonaldson  staff   14177 Jan 31 19:03 lesson_01_development_environment.markdown
              -rw-r--r--   1 rossdonaldson  staff   69268 Feb  7 15:46 lesson_02_git.html
              -rw-r--r--   1 rossdonaldson  staff   36656 Feb  7 15:47 lesson_02_git.markdown
              -rw-r--r--   1 rossdonaldson  staff   19757 Jan 24 14:40 lesson_03_beginning_development.markdown
              -rw-r--r--   1 rossdonaldson  staff    9740 Jan 24 14:40 lesson_04_ssh_plain_text.markdown
              -rw-r--r--   1 rossdonaldson  staff   43493 Jan 24 14:40 lesson_05_http_and_html.markdown
              -rw-r--r--   1 rossdonaldson  staff   36247 Jan 24 14:40 lesson_06_databases_part_one.markdown
              -rw-r--r--   1 rossdonaldson  staff   22496 Jan 30 19:09 lesson_07_databases_part_two.markdown
              -rw-r--r--   1 rossdonaldson  staff  189982 Feb  8 12:21 master_file.org
              -rwxr-xr-x   1 rossdonaldson  staff     119 Jan 31 18:55 pandoc.sh
            
```

(Note that git's folder is named with the leading-dot hidden folder syntax, so you have to use the `la` flags to `ls` in order to see it.)

The `.git` directory contains everything git knows about your files, their history, the commits in your repo – everything is in there. Now: it's in there mostly in a format *git* understands. It's not especially human readable. But it's all there. This has two important implications:

1.  Making a project in to a "git repository" changes *nothing* about the files in the repository. Git is perfectly self-contained. If you deleted the `.git` dir, your directory wouldn't be a git repo any more, and the files would be exactly as they were before you deleted the `.git` dir.
2.  Your project is also self contained. You could move the directory that represents your project anywhere on your computer and it would still work perfectly normally, still know the same things about your files.

### Git's configuration files

Git is configured by a set of "dot files" – files with leading dots. The dot file you'll interact with the most, by far, is the `.gitignore`. That said, setting a `.gitconfig` in your home dir will let you configure git's behaviors in a set of ways you definitely want.

#### .gitconfig

Your `.gitconfig` can contain all manner of things: git command aliases, behavior tweaks, colorization. My minimal `.gitconfig` looks like this:

``` src
[user]
                  name = Ross Donaldson
                  email = gastove@gmail.com
                  [push]
                  default = simple
                
```

Now git knows who I am, what my email address is, and that I want to use the "simple" push strategy.

#### .gitignore

The `.gitignore` is a crucially important part of git: it controls a set of things that git, by default, will… ignore. (Shocking, I know.) This is ridiculously important. For instance:

``` src
mkdir -p /tmp/demo && cd /tmp/demo && git init
                  echo 'here is some stuff you need to know' > knowledge.txt
                  echo 'the top secret code is BANANAPHONE. Sure hope nobody ever adds this file to a public git repo' > top_secret.txt
                  git status
                
```

``` example
                Initialized empty Git repository in /private/tmp/demo/.git/
                On branch master

                Initial commit

                Untracked files:
                (use "git add <file>..." to include in what will be committed)

                knowledge.txt
                top_secret.txt

                nothing added to commit but untracked files present (use "git add" to track)
              
```

`top_secret.txt` is untracked, which is fine, but error prone. For instance: `git                   commit -am <message>` will definitely `git add` `top_secret.txt` – which is not what we want.

Observe:

``` src
echo 'top_secret.txt' > .gitignore
                  git status
                
```

``` example
                On branch master

                Initial commit

                Untracked files:
                (use "git add <file>..." to include in what will be committed)

                .gitignore
                knowledge.txt

                nothing added to commit but untracked files present (use "git add" to track)
              
```

Now the `.gitignore` exists, but `top_secret.txt` has vanished from git entirely. *Perfect*.

Github will helpfully create a `.gitignore` for you when you create a new repo using the Github UI. A `.gitignore` is also a plain text file you can write or edit yourself.

For the full syntax of the `.gitignore`, see the [git documentation](https://git-scm.com/docs/gitignore).

#### Global vs local vs extra-local

Useful to know: you can have a `.gitignore` in any directory, and git will view them all together, with `.gitignores` further down the hierarchy superseding those further up.

The basic mental model of Git
-----------------------------

Note: while we're discussing git specifically, most of what's discussed here is directly applicable to many other version control systems – especially modern distributed version control systems like mercurial.

Git is a way to change code, over time, such that:

1.  You can know how the code changed, from one version to the next
2.  You can know extra information *about* the change – who made it, when, an explanation of why.
3.  Many people can make changes at the same time without stepping on each others toes.

In order to track changes, with extra information, across contributors, we need three things:

1.  A collective noun for all the code that is inter-related and should be considered together.
2.  A notion of a unit of change.
3.  A way to separate my work from yours from anyone elses that allows our work to come back together.

Git provides all three of these things.

### A Collective Noun for Related Code

Git's unit for related code is called the *repository* – or usually just *repo*, for short. We also sometimes use the word *project*. A repo is all the code that is needed for the Thing you are Making. For instance: git's source code itself is in a git repo. All the lesson notes for the 2016 SDS cohort are in a single git repo.

Repos are usually at their best when they represent roughly one thing: a single web app; a single program; a single project. *Technically*, a git repository is just a folder you've told git to keep track of for you; it's up to you to make sure the contents of your repository make sense.

### A Unit of Change

Git's unit of change is called a `commit`. A commit is how we tell git, "I have made changes that I want to keep track of." Or: "I have made changes that I want to be part of the official line of development of my code."

A commit is something we, the users of git, construct. We build commits one at a time, giving them a natural order. We tell get, "add all the changes that happened to this particular file to the commit I'm currently making." Once we're satisfied with the state of the current commit, we tell git, "Okay, we're good. Write this in to the record. Here is a message explaining what I've done and why."

Git will allow you to build your commits at whatever level of granularity you want. You can add individual lines from individual files to a commit, or you can say, "just add absolutely everything that's changed in my entire repo to the same commit right now." Exactly how you do this is up to you. In general, however, small, focused commits are much better than huge commits (commits with hundreds or maybe thousands of lines of changes).

### A Way to Separate and Come Back Together

Git gives us three invaluable tools for working in parallel, without stepping on each others toes, while preserving our ability to unite our work whenever we please. The first tool is called a *branch*; the second is called *cloning*; the third is a *remote*.

#### Branches

Think of a branch as a line of development. Whenever you add new commits to a git repo, you're using a branch, whether you know it or not. The principle branch of a git repo is called *master*, and you can use git happily for a long time, in some contexts, just committing to master and never knowing a branch is involved at all.

Branches give us a great deal of power. We can have an effectively unlimited number of branches in the same repository. Sometimes we'll bring branches back together (a process called *merging*); sometimes we'll abandon branches and never come back.

When you branch, you tell git where you're branching *from*, and git creates a new branch for you. Any commits you add to git will now go to your new branch, instead of your old branch. You can switch branches at any time; when you do, git re-writes your repo to match the current branch you have "check out".

We'll talk more about the commands very soon; for now, let's just see what this looks like:

``` src
mkdir -p /tmp/branch-demo && cd /tmp/branch-demo && git init # Make a new git repo
                  echo "1. Pears" > groceries.txt                              # Add an item to a grocery list
                  git add groceries.txt                                        # Tell git to track groceries.txt
                  git commit -am "Add pears to list"                           # Commit groceries.txt
                  git status
                
```

``` example
                Initialized empty Git repository in /private/tmp/branch-demo/.git/
                On branch master

                Initial commit

                Changes to be committed:
                (use "git rm --cached <file>..." to unstage)

                new file:   groceries.txt
              
```

"On branch master; nothing to commit, working directory clean." `groceries.txt` looks like this:

``` src
cat groceries.txt
                
```

``` example
                1. Pears
              
```

But now:

``` src
git checkout -b new_branch
                  echo "2. tofu" >> groceries.txt
                  git commit -am "Add tofu to list"
                  git status
                
```

``` example
                On branch new_branch

                Initial commit

                Changes to be committed:
                (use "git rm --cached <file>..." to unstage)

                new file:   groceries.txt

                Changes not staged for commit:
                (use "git add <file>..." to update what will be committed)
                (use "git checkout -- <file>..." to discard changes in working directory)

                modified:   groceries.txt
              
```

`groceries.txt` looks like this now:

``` src
cat groceries.txt
                
```

``` example
                1. Pears
                2. tofu
              
```

But now:

``` src
git checkout master
                  cat groceries.txt
                
```

``` example
                1. Pears
                2. tofu
              
```

We checkout master… and we're back to the old version. Git has re-written `groceries.txt` to match the last commit on the master branch. If we go back to `new_branch`, our changes are intact:

``` src
git checkout new_branch
                  cat groceries.txt
                
```

``` example
                1. Pears
                2. tofu
              
```

We can combine the two histories through *merging*:

``` src
git checkout master   # We check out the branch we want changes to come *in* to
                  git merge new_branch  # "Bring the changes from new_branch" in to master
                  git commit -m "Merging new_branch in to master"
                  cat groceries.txt
                
```

``` example
                1. Pears
                2. tofu
              
```

Shazam.

#### Cloning

Cloning allows us to make our own copy of an existing repo. The metaphor of "cloning" is actually quite good: our copy (usually called a "checkout") of the source repository will be exactly identical to the source at time of cloning, but will grow and develop independently. (The metaphor breaks down when we smash clones back together. Oh well.)

Any repo can be cloned. For instance, using our repo from the previous example:

``` src
cd /tmp
                  git clone ./branch-demo cloning-demo
                  cd cloning-demo
                  git status
                
```

``` example
                On branch master

                Initial commit

                nothing to commit (create/copy files and use "git add" to track)
              
```

We now have a complete second copy to `branch_demo` called `cloning_demo`. It has its very own copy of `groceries.txt`:

``` src
pwd
                
```

``` example
                /tmp/cloning-demo
              
```

``` src
cat groceries.txt
                
```

The important thing about cloning is that it can create an exact copy of *any git repo*, whether it's on your local file system or exposed via a transport protocol like HTTPS or SSH. This leads us directly in to the notion of "remotes".

#### Remotes

Git allows us to declare a particular kind of relationship between repositories. This relationship is called a "remote". The "remote" of a repo is automatically set during cloning – your remote is the repo you cloned *from*. A remote can also be manually declared from the command line.

The "remote" relationship has a number of ramifications.

First: a remote is a source and destination for commits, allowing two developers to each have their own checkout (clone) of a given repository while still sharing changes back and forth. For instance: we cloned `cloning-demo` from `branch-demo`, so `branch-demo` is a remote for `cloning-demo`. This means that if more changes are made in `branch-demo`, they can be *pulled* in to `cloning-demo`:

``` src
cd /tmp/branch-demo/
                  echo "3. Gargantua" >> groceries.txt
                  git commit -am "Add Gargantua to groceries.txt"
                
```

``` src
cd /tmp/cloning-demo
                  cat groceries.txt
                
```

``` src
git pull origin master
                  cat groceries.txt
                
```

By using `git pull`, our checkout now has the changes we made in our remote.

So this is cool and good; we now know we can clone our own checkout of any git repo, wherever it is, and we can pull new changes from it. But, what if we want to add our own changes? Good news: git provides for this! However, there's an issue to consider first:

Pulling changes alters our *working copy* – which is to say, we, the developers currently at the console, make a very deliberate choice to bring new changes in to the code we're currently working on. The complementary action to pulling is *pushing*, which sends our changes to our remote. But if our remote is, as in our current example, a repository on disk that someone else could be editing, life gets complicated. How much fun would it be to have your working copy change out from under you? (Answer: no fun at all.)

So: git provides a special class of repositories called "bare" repositories, *just* for pulling and pushing changes. Github, for instance, is a web service that hosts bare repositories, to allow you to pull and push from them freely.

Remember that we were talking about the First important ramification of remotes? This is the Second: by establishing bare repositories on servers that are *only* for pushing and pulling, multiple developers can coordinate their development efforts.

#### Tying It All Together

The last thing to make sure we all know is that a branch in your local checkout can be configured to match a branch *on your remote*. In this way, branches can also be shared, or many developers can work out of the same bare repository, each working on their own branch. Tidy. Clean.

The Pull Request
----------------

So how does this all work for a software development workflow? There are a lot of answers to this question. We'll be using a fairly standard practice, which goes like this:

1.  You decide you want to contribute to a project; you find it on github and clone it locally.
2.  You use `git checkout -b <branch name>` to make a new branch (a "topic" or "feature" branch) to contain your work.
3.  You work for a while, committing your work as you go. Every now and then, you use `git push`, to make sure your branch is available on the remote and that everything is up-to-date.
4.  Every now and then, you make sure you're keeping up with `master` by merging it in like this:
    1.  Make sure all of your work is committed on your branch.
    2.  Check out the `master` branch and do a `git pull` to be sure it's up-to-date.
    3.  If there are new commits on `master`, check out your topic branch and `git                     merge master`. Resolve any merge conflicts.
5.  When you're ready to fully contribute your work, you do it like so:
    1.  Make sure you're up to date with `master`, exactly like in step 4.
    2.  `git push` your changes to the remote (github).
    3.  Open the repo on github; create a new pull request.
    4.  Share it around! Get code review.
        1.  Make any changes suggested in code review.
    5.  When you're ready, merge and delete your topic branch.

Quintessential Git Operations:
------------------------------

Okay, let's build a git repo.

``` src
cd /tmp
              mkdir -p demo-repo
              cd demo-repo
              pwd
            
```

``` example
            /tmp/demo-repo
          
```

We'll make a file – for ease of seeing line numbers, a grocery list:

``` src
touch list.txt
              echo '1. Eggs' >> list.txt
              echo '2. Cheese' >> list.txt
              echo '3. Bacon' >> list.txt
              cat list.txt
            
```

``` example
            1. Eggs
            2. Cheese
            3. Bacon
          
```

Good so far.

### `git init`

First things first: we need to declare that this folder is a git repository. This is done with `git init`, like so:

``` src
git init
              
```

``` example
              Initialized empty Git repository in /private/tmp/demo-repo/.git/
            
```

Perfect! Repo achieved. Notice that the `init` command has done exactly what it tells us it did – if we check the contents of our working directory:

``` src
ls -la
              
```

``` example
              total 8
              drwxr-xr-x   4 rossdonaldson  wheel   136 Feb  8 12:21 .
              drwxrwxrwt  38 root           wheel  1292 Feb  8 12:21 ..
              drwxr-xr-x   9 rossdonaldson  wheel   306 Feb  8 12:21 .git
              -rw-r--r--   1 rossdonaldson  wheel    27 Feb  8 12:21 list.txt
            
```

Now there's a `.git`. Blam.

### `git status`

Git will tell us about a repo's present state using the `git status` command. Right now, the output is a little thin:

``` src
git status
              
```

``` example
              On branch master

              Initial commit

              Untracked files:
              (use "git add <file>..." to include in what will be committed)

              list.txt

              nothing added to commit but untracked files present (use "git add" to track)
            
```

We learn which branch we're on (master), that the commit we're building will be the very first (i.e. the Initial commit), and that there's a single, un-tracked file. Not so exciting right now, but we'll be coming back to this command a **lot**.

### `git add`

If the repo is going to do us any good, we'll want to start tracking our list. Remember that in git, you *build* a commit by adding changes to it. One kind of change is, "I made this file".

So, before:

``` src
git status
              
```

``` example
              On branch master

              Initial commit

              Untracked files:
              (use "git add <file>..." to include in what will be committed)

              list.txt

              nothing added to commit but untracked files present (use "git add" to track)
            
```

And after:

``` src
git add list.txt
                git status
              
```

``` example
              On branch master

              Initial commit

              Changes to be committed:
              (use "git rm --cached <file>..." to unstage)

              new file:   list.txt
            
```

Okay! More informative! We've got a command on unstaging (look further through this doc for more on that), and list.txt is now known as a "new file"! Progress.

Now, an **important thing**: check out what happens if we now change the file:

``` src
echo '4. kale' >> list.txt
                git status
              
```

``` example
              On branch master

              Initial commit

              Changes to be committed:
              (use "git rm --cached <file>..." to unstage)

              new file:   list.txt

              Changes not staged for commit:
              (use "git add <file>..." to update what will be committed)
              (use "git checkout -- <file>..." to discard changes in working directory)

              modified:   list.txt
            
```

Note that our new change has *not* been added to the current commit. We'll go ahead and fix that now:

``` src
git add list.txt
                git status
              
```

``` example
              On branch master

              Initial commit

              Changes to be committed:
              (use "git rm --cached <file>..." to unstage)

              new file:   list.txt
            
```

### `git commit`

Now that we've built our shiny new commit, let's go ahead and commit it:

``` src
git commit -m "Initial commit of a grocery list"
              
```

Let's break this down: `git commit` is our command – it's the most salient thing happening. That `-m` flag is worth unpacking.

See, every commit needs a commit message. That message needs to be written someplace. If you were to simply type `git commit`, git would say, "neat! let's get a commit message written," and open the default editor for your computer. For most computers, that editor is… Vim. Which is a wonderful tool if you know it well, and a bewildering headache if you don't.

`-m`, then, lets us specify the commit message as a command-line argument. Good stuff, eh?

**Protip** – if you're confident in the changes on your branch, you can also use `git commit -am <your message>`, which automatically adds *and* commits all uncommitted changes in all tracked files.

Anywho:

``` src
git status
              
```

``` example
              On branch master

              Initial commit

              Changes to be committed:
              (use "git rm --cached <file>..." to unstage)

              new file:   list.txt
            
```

Now we get a very terse message: working directory clean. Nothing to see here. Everything is committed. *Ahhhhh*.

### `git branch`

Come with me on this one: let's say we want to be tidy grocery list developers and we decide to start working on a new branch. To start with, we should see what branches are available to us:

``` src
git branch
              
```

Okay, only the one so far. The asterisk indicates that `master` is our current branch. We can make a new branch like so:

``` src
git branch list_dev
                git branch
              
```

We've created a new branch… but we're still on master. To actually *use* our new branch, we need the next git command: `checkout`.

### `git checkout`

Git checkout is a) incredibly useful and b) painfully overloaded, meaning it does different things depending on exactly how you use it. Right now, what we care about is using `git checkout` to let us switch between branches:

``` src
git checkout list_dev
                git status
              
```

``` example
              On branch master

              Initial commit

              Changes to be committed:
              (use "git rm --cached <file>..." to unstage)

              new file:   list.txt
            
```

There! Now we're on branch `list_dev`: `git branch` confirms it:

``` src
git branch
              
```

There's an extra-awesome way to use `git checkout`: with the `-b` flag. `git checkout                 -b <branch_name>` does three good things at once:

1.  Creates a new branch named `<branch_name>`
2.  Switches you to it
3.  Moves any uncommitted changes from your old branch to your new branch.

``` src
echo "4. Orange Juice" >> list.txt
                git checkout -b even_list_devier
                git status
              
```

``` example
              On branch even_list_devier

              Initial commit

              Changes to be committed:
              (use "git rm --cached <file>..." to unstage)

              new file:   list.txt

              Changes not staged for commit:
              (use "git add <file>..." to update what will be committed)
              (use "git checkout -- <file>..." to discard changes in working directory)

              modified:   list.txt
            
```

Now, there's a **second crucially important** thing `git checkout` lets you do: recover deleted files or past states. So, for instance: I'm going to make a directory full of important files:

``` src
mkdir -p so_important
                for i in 1 2 3; do touch so_important/critical_$i; done
                tree
              
```

``` example
              .
              ├── list.txt
              └── so_important
              ├── critical_1
              ├── critical_2
              └── critical_3

              1 directory, 4 files
            
```

Git doesn't know about this yet, so let's add it:

``` src
git add so_important
                git commit -am "This is so important. Add it!"
              
```

And now, let's do a poorly considered delete:

``` src
rm -rf so_important
                ls -la
              
```

``` example
              total 8
              drwxr-xr-x   4 rossdonaldson  wheel   136 Feb  8 12:21 .
              drwxrwxrwt  38 root           wheel  1292 Feb  8 12:21 ..
              drwxr-xr-x  11 rossdonaldson  wheel   374 Feb  8 12:21 .git
              -rw-r--r--   1 rossdonaldson  wheel    51 Feb  8 12:21 list.txt
            
```

Well crap. All our important stuff is completely gone. *Except*, we were smart developers and added it to git! Git knows something is up:

``` src
git status
              
```

``` example
              On branch even_list_devier

              Initial commit

              Changes to be committed:
              (use "git rm --cached <file>..." to unstage)

              new file:   list.txt
              new file:   so_important/critical_1
              new file:   so_important/critical_2
              new file:   so_important/critical_3

              Changes not staged for commit:
              (use "git add/rm <file>..." to update what will be committed)
              (use "git checkout -- <file>..." to discard changes in working directory)

              modified:   list.txt
              deleted:    so_important/critical_1
              deleted:    so_important/critical_2
              deleted:    so_important/critical_3
            
```

It tells us we've deleted all those files. We can bring them back with `git                 checkout`:

``` src
git checkout -- so_important/*
                tree
              
```

``` example
              .
              ├── list.txt
              └── so_important
              ├── critical_1
              ├── critical_2
              └── critical_3

              1 directory, 4 files
            
```

Blam. Git saves the day.

### `git remote`

Probably if we have changes, we wanna share them with the world, eh? I mean, maybe not – maybe you're hacking on a one-off project and you don't know if it'll really "work" yet, y'know? But for now, today, right now: let's assume sharing is on the menu. "But wait," you say, "I haven't set up a place to share this!" Git agrees:

``` src
git push
              
```

``` example
              fatal: No configured push destination.
              Either specify the URL from the command-line or configure a remote repository using

              git remote add <name> <url>

              and then push using the remote name

              git push <name>
            
```

To spare my github account, I'm going to create a bare repo locally:

``` src
cd /tmp && git clone --bare demo-repo demo-remote
              
```

I can now add my remote to my original repo:

``` src
git remote add origin /tmp/demo-remote
              
```

By convention, we call the "primary" remote of a repo "origin" (which makes considerably more sense if you think of cloning a repo from Github – Github is then your "origin".)

We can see that we have a remote set:

``` src
git remote
              
```

``` example
              origin
            
```

Using git's verbose flag, `-v`, we can learn a little more about `origin`:

``` src
git remote -v
              
```

``` example
              origin    /tmp/demo-remote (fetch)
              origin    /tmp/demo-remote (push)
            
```

This means, by default, `git fetch` and `git push` will both refer to `git fetch                 origin` and `git push origin`. Perfect!

### `git push`

Now that we've set a remote, we can *push* changes from our checkout to the remote, allowing those changes to be shared. First, a word about upstream branches.

So far, locally, we've made a variety of branches. We're about to push from a branch to our remote. What happens to those commits? Do they wind up all on the same branch on the remote? Or do they get a branch that matches what we've got locally? The answer is: we can tell git to do it however we'd like. What we're describing here is called the "upstream branch" – which branch does `even_list_devier` get pushed to on our remote? The best practice here is that you should push your local branch to a branch of the same name on your remote. Here's how to do this:

First, when we push, we can manually specify a remote and a branch on the remote:

``` src
git push origin even_list_devier
              
```

This command gets a little tiresome, so we typically use the `--set-upstream` flag to tell git, "remember where I push so I don't have to type the full command in the future":

``` src
git push --set-upstream origin even_list_devier
              
```

Now that this has been saved, we can see our upstreams by passing the *double verbose* flag, `-vv`, to `git branch`:

``` src
git branch -vv
              
```

`[origin/even_list_devier]` means that `even_list_devier` is "tracking" an eponymous remote branch on `origin`. Yatta!

Now, we can make that command a little shorter. Remember in the <span id="orgeaa33f9"></span> section, I set my "push strategy" to "simple"? This means that when I say `git                 push`, git automatically assumes that I mean `git push <upstream_branch>`.

``` src
echo "5. Gold Rings" >> list.txt
                git commit -am "Adding 5 Gold Rings to grocery list"
                git push
              
```

Lovely.

### `git fetch` and `git pull`

Git gives us two ways to retrieve new commits from our remote: `fetch` and `pull`. First, I'll create a second checkout of our remote, so we can see this in action:

``` src
cd /tmp && git clone ./demo-remote demo-second-clone
              
```

In demo-second-clone, I can use the `-av` syntax (all, verbose) to see what branches are on the remote:

``` src
git branch -av
              
```

Ah, of course. We never pushed `master` or `list_dev`, so they aren't on the remote at all. Let's fix that:

``` src
cd /tmp/demo-repo
                git checkout list_dev
                git push --set-upstream origin list_dev
                git checkout master
                git push --set-upstream origin master
              
```

Now, back in demo-second-clone:

``` src
git branch -avv
              
```

There. Now, let's see what `git status` in demo-second-clone has to say:

``` src
git status
              
```

``` example
              On branch master

              Initial commit

              nothing to commit (create/copy files and use "git add" to track)
            
```

It says we're up-to-date with `origin/even_list_devier` – but we know that's not true, because we pushed a commit from `demo-repo`. We can ask the remote to tell us about commits we're missing using `git fetch`:

``` src
git fetch
                git status
              
```

``` example
              On branch master

              Initial commit

              nothing to commit (create/copy files and use "git add" to track)
            
```

Ah! There we go. We are "behind" by 1 commit, as expected. The thing to notice is that `git fetch` *has not changed anything*. We know what we're missing, but the current state of our files is no different:

``` src
cat list.txt
              
```

`git pull` is the command that will actually bring changes from the remote *in to our working copy*:

``` src
git pull
              
```

``` src
cat list.txt
              
```

Voila.

Homework
--------

1.  Clone [blabs' config file](https://github.com/reed-college/blabs-config) to your computer. Read it and understand it.
2.  Contribute a new command, or expand an old one!
3.  Open a pull request. Heck! Open two!
4.  When you open a pull request, post it in the interns channel; I'll review every single one of them. Y'all are welcome to review each others code – just remember to be kind. Ask questions! Learn things :D
5.  Once I approve your PR, you can merge it, and I'll make blabs pick up the new configuration.

Author: Ross Donaldson

Created: 2017-02-08 Wed 12:21

[Validate](http://validator.w3.org/check?uri=referer)
