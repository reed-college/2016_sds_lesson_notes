# First, a couple points


## Text versus Everything Else

Let's look at bits of two different files:

```sh
cat ~/.bashrc | head
```

    #!/bin/bash

    # bashrc

    [ -n "$PS1" ] && source ~/.bash_profile

    ### Added by the Heroku Toolbelt
    export PATH="/usr/local/heroku/bin:$PATH"

Okay, that looks just fine. I recognize a few words! "bin" and "bash" &#x2013; both fine words, good good. Now, what about something else? Note: for a few reasons, the output of the following commands are not being spliced in to this document (they actually confuse the hell out of both text editors and git). So, to follow along at home, find files with the equivalent extension. First, how about a JPEG:

```sh
cat ~/Dropbox/Photos/grumpycat_wsj_headcut.jpg | head
```

Well, uh that's pretty&#x2026; not&#x2026; word-looking. How about an MP3:

```sh
cat ~/Dropbox/eMusic/Doomtree/All\ Hands/1.\ Final\ Boss.mp3 | head
```

*Hnnnnnnnng*. Yeah okay. We aren't getting anywhere, fast. What on earth is going on?

The answer is: we're looking at *binary* data. Binary files are encoded in the language of your computer &#x2013; which makes sense, right? Reading a JPEG makes maybe a little more sense than reading an MP3, but only just barely. We have specialized programs to open MP3s and JPEGs &#x2013; software like iTunes and Preview that know how to interpret the binary data. When we attempt to read them, our computers take a wild stab at turning the binary information in each file in to text, and&#x2026; it's not pretty, or useful.

We're accustomed to this. For most of us, before we code, we write documents in Microsoft Word. I wonder:

```sh
cat ~/Dropbox/gradschool/capstone/Modus\ Cooperandi/Donaldson,\ Ross\ _\ ModusCooperandiCapstoneProjectCharter.doc | head
```

See this is a weird conceptual gotcha: Word documents *are not plain text*. We think of them as being full of words, but they are actually a proprietary binary format &#x2013; barely words at all. We need a special program &#x2013; Word &#x2013; to open a `.doc` or `.docx`.

And here's the inverse: if a file is plain text we can open it with&#x2026; anything, almost. You can't open a Word document in Sublime, but you could open your `.bash_profile` in Word if you felt so inclined<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup>. This is why text editors are so, so, so important &#x2013; in the world of code, source files are pretty much always *just text*. So are all the configuration files that control your laptop. So are all the configuration files that control every Linux and Unix computer in the world.


# SSH Keys


## What the Crap is SSH?

SSH &#x2013; short for Secure Shell, is a protocol by which two computers can exchange information. Sometimes, we connect to another computer "over" SSH, allowing us to use that computer through the terminal on our own "local" computer. At other times, a service "uses" SSH to move other data &#x2013; say, a file &#x2013; from one computer to another. SSH really is pretty damn secure; it's also used in a *lot* of different places, making it an awfully useful tool to have set up.

There's a whole heck of a lot we could get in to on the topic of how SSH works. Frankly, we're just going to skip most of it. The important thing to know right now is this: SSH requires you to make a set of SSH *keys*. You'll have two keys, a "public" key and a "private" key. For instance:

```sh
ls -la ~/.ssh
```

    total 40
    drwx------   7 rossdonaldson  staff   238 Feb 10 13:43 .
    drwxr-xr-x+ 95 rossdonaldson  staff  3230 Feb 23 14:50 ..
    -rw-r--r--   1 rossdonaldson  staff   308 Feb 10 13:43 config
    -r--------@  1 rossdonaldson  staff  1696 Nov  1 14:16 gastove.pem
    -rw-------   1 rossdonaldson  staff  3326 Oct 17 12:29 id_rsa
    -rw-r--r--   1 rossdonaldson  staff   741 Oct 17 12:29 id_rsa.pub
    -rw-r--r--   1 rossdonaldson  staff  2899 Feb  3 15:55 known_hosts

`id_rsa` is my private key; `id_rsa.pub` is my public key. (`known_hosts` tracks places I've SSHed to, and is otherwise not germane right now.)

The public key is precisely that &#x2013; public. You don't want to share your public SSH key by posting it on your web site or tweeting it &#x2013; not *that* public. But for instance: if you join the tech sector, one of the very first things you're likely to do is get a work laptop, generate work SSH keys, and send your public key to someone on the Ops team. They'll then put that SSH key on every computer you're allowed SSH access to.

Here's a gross oversimplification of how this works: your private key can be used to encrypt a message which your public key can then decrypt. In this way, your keys can be used for your computer to say, "hi it's me!", and for a server to then say, "yes, I can decrypt your message correctly, therefore I know it is you."

Here at Reed, we'll use SSH keys for Github access, as well as for access to virtual machines in the Reed stack, if you ever need such a thing.


## Makin' SSH Keys

So how do we do this? Great question! Good news: it's easy. Open yer terminal and execute like so:

```sh
ssh-keygen -t rsa -b 4096 -C <your email address>
```

`-t` tells keygen to make you an "RSA" SSH key.<sup><a id="fnr.2" class="footref" href="#fn.2">2</a></sup> `-b 4096` makes a 4,095-bit long key (longer keys are more secure). `-C` adds a comment, in this case your email address.

You'll receive a prompt asking you to "Enter a file in which to save the key". Hit Enter to accept the default, which will be `$HOME/.ssh/id_rsa` and `id_rsa.pub`.

Next, a point of security: you'll be prompted for a password. The password will lock your ssh key, and you wont be able to use your key without entering the password. This is vastly more secure; it's also optional.

Next&#x2026; you're done! Good job.


## What to do with your SSH Keys

Here's a great one: go to github.com and log in. In the upper-right-hand corner of the screen is a tiny little representation of your avatar; click the arrow next to that, then hit *Settings*. There's a dialogue on the left side of the screen: SSH Keys. Click that.

Hit "New SSH Key". Osnap: you're asked to give it a name, and then there's just&#x2026; a text box.

Remember out discussion of plain text data? Your `id_rsa.pub` is also *just text* &#x2013; by which I mean, "literally only". In your home directory, do:

```sh
cat ~/.ssh/id_rsa.pub
```

    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqEwvMcwRBR9D3dO+KbbhNUOWzbRfdi2TxS4btEsoJqpHl708OuZm6XEXJPq9UfzrIyl/9uuQkVDOXJb3nN5AoaegUeKDfnImLw/DPZNjdqp+VNcziFTTwnou5mbELMFmhFtOBoJT083gGR10KCtepnZryUPwJjuNcb/+pJyXlKYRZIAl00v09aTHAjzVhvT5/296gIbDcQ0Px32MAyxKDffnkIRrH/SXnDfONp+Mtb4lofYDBlMMZXhZBt2QKRn17DhvdDR3eGXy75tJQplGxDlA8/+mt06KOJ2BqNF2TVdE0qqejYi3uG4Eqimx8qQ93Aa9etba8ZcRU4MFB59z+8cAEqAD/56ABG7mkA4jbehda/gYViEYEAbafqm/OSITr8ycSgLw0E++PDCEWhp+lXsayQxVzl46ih/gI4PbNbhn/FdJRiqVpWlEmsZWK7XiCouUw8RRHguPSBoB9sAMeFowk/y4Wyn9osAAMaFTNKxglvHksnr/vqWSNIHJcUWcr5icT2ifcR+SnWMmQxlHQGlIBqeqmaYxz212F1aqtAwMnU043DVAxqeYlK4EEoNwQKVBGXOJZKMOnbL9U1VQr6bb9rd9ZSTV7ocBaw2/CwfWNSKKDpfd547Oy/w5vu25sQ75leyveYnjPUP6RPbhUg5kiL77RZWgpJAw4Bk36qw== ross@disqus.com

You'll see something a lot like:

    ssh-rsa AAAGB3NzaC1yc2EAAAADAQABAAABAQDQ1fvnMbYDN1nm8X8KZY3d/sPG14L9nngvDZXU2BbDm+zMLkc5arWelqpY6bLxKhlo0p5lDbD/LXZL8QwUE527TVe2eZvORXrv8GbbDINVG+qXCSxmCBGv2nnMakijsy/WsUGScPBXgaYsKzcrvKO+ZdjwBbZ+Eqkl7085aorQsST2PKAE81jCJx5hpI/E/5NdUMeC1vi7GnEn+wROh4TU/fQIR8r3kTAoSbyph7l/8D0UE4Nwm3xtEGjL7PJPn2x4u8X8gV3IQvHLn1uJiaAHxRjYC1vOJDAClnyU0N9OJcN9xkGo1CImyzFTZw0UGqN2uBoqjl/djvG2HOe0yTLd gastove@apparatus.local

That's your public key. (No, that's *not* my public key. It's a demo. Don't put your public key in a git repo. Not *that* public.)

Anywho: notice that's it's just a string of letters and numbers &#x2013; that's it. Copy paste that whole thing in to the box on Github. Hit "Add SSH Key". Done! You win! Good job.

Note that you can have an effectively unlimited number of SSH keys. This is part of the beauty of them &#x2013; I have separate keys for my work laptop and my work desktop, so security can be managed on them separately. For instance: if my work laptop is stolen, we can revoke only its keys and I can generate new ones, leaving my desktop untouched.


## Using SSH with git: a brief lesson in URIs

If you go to [the Slackbort repo on Github](https://github.com/Gastove/slackbort), you'll see at the top there's a box with either "HTTPS" or "SSH" in it, followed by some text &#x2013; either `https://github.com/Gastove/slackbort.git` or `git@github.com:Gastove/slackbort.git`. The first one runs over HTTPS; the second goes over SSH.

While we tend to call these "URLs" (Uniform Resource Locator), the proper name is "URI" &#x2013; Uniform Resource *Identifier*. A URI is more general, and has this form:

    scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]

In practice, the `scheme` is often omitted, provided by context. For instance: when we type something like, `/Users/gastove/.bash_profile`, that is *also* a URI. It omits the `scheme`, which is `file://`. Modern web browsers often elide the scheme as well, but we're more accustomed to seeing `http` or `https`. Some of us have probably used `ftp://`.

So: a URI that begins with `git@github.com` is telling git to try and access the `github.com` domain with user `git`; it then looks for a repo, which traditionally has the form `<username or organization>/<repo name>.git`. This is, it should be noted, just the way Github is set up; git URIs very often have a form more like, for instance, those at my work: `ssh://git@atlassian.prod.urbanairship.com:222/reports/hubble.git`.

## Footnotes

<sup><a id="fn.1" class="footnum" href="#fnr.1">1</a></sup> But please: don't.

<sup><a id="fn.2" class="footnum" href="#fnr.2">2</a></sup> The other option is DSA. For the most part, the winner between RSA and DSA isn't clear, but: the math on which RSA is based is generally more difficult, and RSA keys are longer. Also, RSA validation is more broadly deployed.
