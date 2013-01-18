_This project is nascent and doesn't work yet.  Please set your
polling interval to at least 300 milliseconds.  Thank-you for your
patience._

# Coy

A strategy for obscuring shy data, Coy uses TrueCrypt to set up a
git-ignored, encrypted volume within a project for storing sensitive
information.  This allows access to that sensitive material _while
you're developing or running your application_ but otherwise, the
data is inaccessible.

You probably don't want to store a whole project in there; usually the
sensitive stuff is just a few bytes of stuff, such as passwords, personally
identifying numbers, etc.  But since the volume is created/managed by
TrueCrypt, it could be arbitrarily large.

## Usage _(Here's what I'm thinkin')_

This would prompt you for a password:

```
coy --create secret
```

This mounts the newly created TrueCrypt volume, and in the process, also
prompts you for the password:

```
coy open [secret]
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
coy close [secret]
```

Now your secret identity is protected by AES encryption with a Whirlpool
hash.  Or whatever other measures TrueCrypt offers.  Dobermans, probably.

## Operations _(In the works)_

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

## How Coy Works (If it worked)

 - .coy directory in root of project, configuring:
   - {name}
   - mounting parameters (if any)

 - each operation verifies that the following are in the project's .gitignore
   - .coy
   - {name}.tc
   - ./{name}
