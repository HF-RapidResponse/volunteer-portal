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

Once that's downloaded, open up a terminal to the root `volunteer-portal` directory.

Include this [Service Account key](https://storage.cloud.google.com/humanity-forward-infra/gcp_credentials.json) called `gcp_credentials.json` in the `api/` folder. If you can't access this key, your onboarding process may not have been completed. reach out to a team lead to get that sorted.

In the root directory of the repo, run the following command to start the dev environment at `http://localhost:8000`:

`docker-compose up`

That command will take a while to run the first time you run it. It'll download a few OS images, set them up with the code in this repository and start the needed servers.

Once that's done, open up [http://localhost:8000](http://localhost:8000) and you should see the application!
:warning: **The client runs at 8080 and the api runs at 8081, but 8000 is the port you likely want to use** using 8080 to access the client you will not be able to interact with the API

## Testing

You can enter the api docker container to run tests in there, or use the handy make tasks. For these to work you'll need to have `docker-compse up` running.

`make test`

Runs linting which validates Python static type hints/annotations

`make validate`

Runs tests. Some data source tests currently (lazily) use real HF databases and require [authentication through the GCP CLI](https://cloud.google.com/sdk/docs/authorizing#authorizing_with_a_user_account).


## Using the Application

The ***client*** application (React) runs at [http://localhost:8080](http://localhost:8080).

The ***api*** (Python) runs at [http://localhost:8081](http://localhost:8081). You can view the API documentation at [http://localhost:8081/redoc](http://localhost:8081/redoc).

The ***database*** (Postgres) runs on port 8082 with username "admin" and password "password". You can connect to it locally for debugging purposes.

## Architecture

To read more about architecture, [see this page](/docs/architecture.md).

## Asana Board

We keep track of tasks through an [Asana board here](https://app.asana.com/0/1196959085120745/board). Tasks are typically added in the `Backlog`, `Humanity Forward Requests`, or `Prioritized To Do` sections. When a task is ready to be worked on, it can then be moved to `In Progress`. Remember to assign yourself to the task (or delegate it to someone else if you're feeling bossy...). When you are done with a task, please move it to `Done` and choose `Mark complete` in the task menu (click on the 3 dots of the task card).

## Branching and GitHub

To read more about branching, [see this page](/docs/branching.md).
