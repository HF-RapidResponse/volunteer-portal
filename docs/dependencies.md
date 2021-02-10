# Dependency Management

## API / Python Application

Todo

## Client / JavaScript Application

Like most JavaScript applications, dependencies are managed through the [client/package.json](../client/package.json) file through `npm`.

Since this application is run through Docker, you won't want to edit this file directly (well, you could edit it, then rebuild your entire docker container, but that would be a lot of work). Instead, here's the process for adding or removing dependencies to the client application.

Open up a shell into the client application using the following command from the root directory of the volunteer portal application.

`make shell-client`

You can read what's happening behind the scenes when you run this command by checking out the [Makefile](../Makefile).

This command will open a bash shell within the client javascript container in the client directory.

From there you can add or remove any libraries, run any npm commands and work as you would if you were developing locally.

### Client: Example Installation

Let's say you want to install the [momentjs](https://momentjs.com/) library. Here's the process you would follow (note the different command prompts when you're on your local machine's bash shell versus the docker bash shell):

```
volunteer-portal (develop) $ make shell-client
docker-compose run --rm client bash
Creating volunteer-portal_client_run ... done
root@5add2401d256:/srv/client# npm install --save momentjs
+ momentjs@2.0.0
added 1 package and audited 2376 packages in 30.721s
root@5add2401d256:/srv/client# exit
exit
volunteer-portal (develop) $ git status
On branch develop
Your branch is up to date with 'origin/develop'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   client/package-lock.json
	modified:   client/package.json

volunteer-portal (develop) $ git commit -am "Added momentjs library"
```

Running `npm install --save momentjs` within the docker container updated the `package.json` and the `package-lock.json` in the client directory – just like it would if you were working locally. After that you can commit, push and work just like you would if this application ran using your local node environment.

## Recreating Docker Images

Occassionally the docker images do not automatically update when new dependencies are added (e.g. when switching branches). If you are receiving errors for a dependency that's already declared in a dependencies file, try rebuilding the corresponding service using the following commands:
* `make recreate-api`
* `make recreate-client`
* `make recreate-db`
Then simply use `make up` as usual to test if the dependencies are now installed as expected.

There is a brute-force `make recreate-all` that does all of the above, but it takes a while so save yourself some time and just rebuild the service you need!
