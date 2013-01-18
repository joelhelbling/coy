# Coy

A convenience handler for TrueCrypt which sets up a git-ignored, encrypted
volume within a project for storing sensitive information.  This allows
access to that sensitive material _while you're developing or running your
application_ but otherwise, the data is inaccessible.

You probably don't want to store a whole project in there; usually the
sensitive stuff is just a few bytes of stuff, such as passwords, personally
identifying numbers, etc.  But since the volume is created/managed by
TrueCrypt, it could be arbitrarily large.

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

# Resources

 - .coy directory in root of project, configuring:
   - {name}
   - mounting parameters (if any)

 - each operation verifies that the following are in the project's .gitignore
   - .coy
   - {name}.tc
   - ./{name}
