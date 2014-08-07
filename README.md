add-github-user.sh
==================

Create a new user using GitHub user name or update public key(s)

* Create `:user` to unix group and unix user
* Grant sudo privilege to `:user`
* Install public key(s) from `https://github.com/:user.keys` to `/home/:user/.ssh/authorized_keys`

`add-github-user.sh` will not set user password.

Usage
-----

```
$ add-github-user.sh <github user>
```

Demo
----

```
$ sudo ./add-github-user.sh hansode
+ [[ -z hansode ]]
++ tr A-Z a-z
+ declare devel_user=hansode
+ declare devel_group=hansode
+ declare devel_home=/home/hansode
+ getent group hansode
+ groupadd hansode
+ getent passwd hansode
+ useradd -g hansode -d /home/hansode -s /bin/bash -m hansode
+ [[ -f /etc/sudoers ]]
+ egrep '^hansode' /etc/sudoers -q
+ echo 'hansode ALL=(ALL) NOPASSWD: ALL'
+ su - hansode -c '/bin/bash -ex'
+ egrep -w '^umask 022' -q /home/hansode/.bashrc
+ echo 'umask 022'
+ su - hansode -c '/bin/bash -ex'
+ mkdir -p -m 700 /home/hansode/.ssh
+ curl -fsSkL https://github.com/hansode.keys -o /home/hansode/.ssh/authorized_keys
```

Installation
------------

```
$ curl -fsSkL https://raw.githubusercontent.com/hansode/add-github-user.sh/master/add-github-user.sh -o add-github-user.sh
$ chmod +x add-github-user.sh
```

Effected Files
--------------

+ `/etc/passwd` - Creating the account
+ `/etc/shadow` - Creating the account
+ `/etc/group`  - Creating the account
+ `/etc/sudoers` - Granting sudo privilege
+ `/home/:user/.ssh/authorized_keys` - Installing public key(s) from `https://github.com/:user.keys`

License
-------

[Beerware](http://en.wikipedia.org/wiki/Beerware) license.

If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.
