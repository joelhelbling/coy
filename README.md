_This project works, and I have a cuke to prove it. It does require
[TrueCrypt](http://www.truecrypt.org/downloads) to be installed, however._

_If you want to see how things are coming along, take a look at
[Coy's Trello board](https://trello.com/board/coy-gem/50fac5252c4479de56004783).
It's a mess!_

# Coy

A strategy for obscuring shy data, Coy uses TrueCrypt to set up a
git-ignored, encrypted volume within a project for storing sensitive
information.  This allows access to that sensitive material _while
you're developing or running your application_ but after you close it,
the data is inaccessible\*.

You probably don't want to store a whole project in there; usually the
sensitive stuff is just a few bytes of stuff, such as passwords, personally
identifying numbers, etc.  But since the volume is created/managed by
TrueCrypt, it could be arbitrarily large.

\* _Encrypted with AES and a Whirlpool hash algorithm._

## Usage _(Here's what I'm thinkin')_

This would create a new protected directory called "secret":

```
coy create secret --password shhhhH!
```

This mounts the newly created TrueCrypt volume:

```
coy open secret --password shhhhH!
```

Now you can slip on in there:

```
cd secret
```

And stash some top-secret tidbits that your program will need:

```
echo "---\n - :santas_little_helper: me" > hush-hush.yaml
```

Once you're done developing or delivering toys and whatnot, you can
close up shop:

```
cd ..
coy close [secret]
```

Now your secret identity is protected by AES encryption with a Whirlpool
hash.  Or whatever other measures TrueCrypt offers.  Dobermans, probably.

## Operations

 - create a volume with the supplied {name}, prompting for password
 - mount that volume in the root of the project as a dir matching {name}
 - unmount that volume (using the supplied {name})
 - hook for application which will attempt to mount the drive when your
   app is run.  Should be disabled for running tests (do _not_ mount
   volume when running tests, but instead symbolic link {name}.test to
   {name}
 - Future: daemon which watches project dir for file events, and after
   {timeout} with no activity, will un-mount the volume and shut down.
   This could be slick with a little system menu icon with drop-down
   menu.

## Rather Urgent TODO's

 - The whole git-ignoree bit.  It should ensure your newly protected
   directory (and the volume file it rode in on) are ignored by git.
 - prompt in CLI for password: if no password is provided, let's use
   the CLI to prompt for one.  I'm thinking the highrise gem.
