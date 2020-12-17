# Volunteer Portal for Humanity Forward

This web app serves as a launch point for volunteers who want to get involved with [Humanity Forward](https://movehumanityforward.com/).

## Setup

Running this code requires the developer to have a working computer with [git](https://git-scm.com/downloads), an IDE such as [Visual Studio Code](https://code.visualstudio.com/), and [Docker](https://www.docker.com/) installed globally. Everything application specific – Python, Node, Postgres, etc – will be setup inside Docker and doesn't require any local installation.

### Setup: Local Machine

We've touched on some things to install on your computer, but for a detailed explanation, [see this page](/docs/setup.md). Make sure you install the following:

* [Git](https://git-scm.com/downloads)
* [Docker](https://www.docker.com/)
* An IDE such as [Visual Studio Code](https://code.visualstudio.com/) or [Atom](https://atom.io/)

### Setup: Application

To run this code locally, it must first be cloned from GitHub. This can be done with the following command:

`git clone https://github.com/HF-RapidResponse/volunteer-portal.git`

The URL for cloning comes from the top right portion of the repo page.

Once that's downloaded, open up a terminal to the root `volunteer-portal` directory. In that directory, run the following command:

`docker-compose up`

That command will take a while to run the first time you run it. It'll download a few OS images, set them up with the code in this repository and start the needed servers.

If that command works, you'll see the following message:

```
```

This will create

## Testing

_Todo_

`mypy .`

Runs linting which validates Python static type hints/annotations

`python -m pytest tests/`

Runs tests. Some data source tests currently (lazily) use real HF databases and require [authentication through the GCP CLI](https://cloud.google.com/sdk/docs/authorizing#authorizing_with_a_user_account).


## Using the Application

Once the docker has started the application, a few endpoints will start up:

[http://localhost:8000/redoc](http://localhost:8000/redoc) - The API runs on port 8000.



## Architecture

To read more about architecture, [see this page](/docs/architecture.md).

## Asana Board

We keep track of tasks through an [Asana board here](https://app.asana.com/0/1196959085120745/board). Tasks are typically added in the `Backlog`, `Humanity Forward Requests`, or `Prioritized To Do` sections. When a task is ready to be worked on, it can then be moved to `In Progress`. Remember to assign yourself to the task (or delegate it to someone else if you're feeling bossy...). When you are done with a task, please move it to `Done` and choose `Mark complete` in the task menu (click on the 3 dots of the task card).

## Branching and GitHub

To read more about branching, [see this page](/docs/branching.md).
