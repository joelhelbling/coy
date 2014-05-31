[![Build Status](https://travis-ci.org/joelhelbling/coy.png)](https://travis-ci.org/joelhelbling/coy)

# Coy

/koi/ Adjective: *reluctant to give details, esp. about something regarded as
sensitive.*

A utility for protecting shy data, Coy uses TrueCrypt to set up a vcs-ignored\*,
encrypted volume within your project project for storing sensitive
information.  This allows access to that sensitive material _while
you're developing or running your application_ but after you close it,
the data is inaccessible\*\*.

You probably don't want to store a whole project in there; usually the
sensitive bits are just a few bytes of stuff, such as passwords, personally
identifying information, etc.  Accordingly, Coy's protected directories have
a 2Mb capacity.

\* _Git, Mercurial and SVN (See [Ignorance](http://github.com/joelhelbling/ignorance).)_

\*\* _Encrypted with AES and a Whirlpool hash algorithm._

## Installation

First, you'll need to [install TrueCrypt 7.1a](https://github.com/DrWhax/truecrypt-archive)
(or [compile from source](https://github.com/FreeApophis/TrueCrypt)) and ensure its
command-line utility is visible in your path:

    $ which truecrypt

Now you can add this line to your application's Gemfile:

    gem 'coy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coy


## Usage

This would create a new protected directory called "secret":

    $ coy create secret

This mounts the newly created TrueCrypt volume:

    $ coy open secret

Now you can slip on in there:

    $ cd secret/

And stash some top-secret tidbits that your program will need:

    $ echo "---\n - :santas_little_helper: me" > hush-hush.yaml

And then, in your ruby code:

```ruby
File.exists? './secret/hush-hush.yaml' #=> true
```

Once you're done developing or delivering toys and whatnot, you can
close up shop:

```
$ cd ..
$ coy close secret
```

And at this point, the `secret/` directory is inaccessible (unmounted).

```ruby
Dir.exists? './secret/' #=> false
```

Now your secret identity is protected by AES encryption, a Whirlpool hash,
your awesome password, and whatever other measures TrueCrypt uses.  Dobermans,
probably.

### Password

The `create` and `open` commands require a password.  Coy will prompt you,
and mask the input.  On the other hand, if you're safe in the batcave, you
can include the password as a command-line argument:

    $ coy create secret --password l33tp@55w0rd
    $ coy open secret -p l33tp@55w0rd

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests!
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

