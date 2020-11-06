# Volunteer Portal for Humanity Forward

This web app serves as a launch point for volunteers who want to get involved with [Humanity Forward](https://movehumanityforward.com/).

## System Requirements

Running this code requires the developer to have a working computer with [git](https://git-scm.com/downloads), an IDE such as [Visual Studio Code](https://code.visualstudio.com/), and [Node](https://nodejs.org/en/) installed globally. There is no mandated node version in the package files, but the developer team is running on version 14.x.

## Machine Setup

We've touched on some things to install on your computer, but for a detailed explanation, [see this page](/docs/setup.md).

## Local Repository Setup

If you're reading this, then you've probably created a GitHub account. As of this writing, the repo is set to private. However, if you somehow got access to this readme without creating an account, please do that first.

To run this code locally, it must first be cloned from GitHub. This can be done with the following command:

`git clone https://github.com/HF-RapidResponse/volunteer-portal.git`

The URL for cloning comes from the top right portion of the repo page.

### Client

In the _client_ directory, you can run:

#### `npm install` or `npm i`

Installs the packages required to run this project locally. This is the first command developers must run after cloning.

#### `npm run client`

**Note**: normally this would be `npm start`, but `npm start` is being used for something else.

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.
The page will reload if you make edits.<br />
You will also see any lint errors in the console.

#### `npm test`

Launches the test runner in the interactive watch mode.<br />
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

#### `npm run build`

Builds the app for production to the `build` folder.<br />
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br />
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### API

Running the API locally requires connecting to HF's databases. Make sure you have been given the correct permissions in GCP and have [authenticated through the GCP CLI](https://cloud.google.com/sdk/docs/authorizing#authorizing_with_a_user_account)

In the _api_ directory you can manage dependencies with conda or virtualenv run:

#### `conda env create -f environment.yml`

or

#### `virtualenv dev-env --python=/usr/bin/python3.8`

Creates an isolated Python environment. This is the first command developers must run after cloning before working on the API.

Python packages and environments are managed via [Conda](https://docs.conda.io/en/latest/miniconda.html)

#### `conda activate volunteer-portal`

or

#### `source dev-env/bin/activate`

Activates the virtual environment that the dependencies were installed in to enable you to run the API. This command must be run in a terminal session before running the below commands.

#### `pip install -r requirements.txt`

If you created your virtual environment using `conda create` then this has already been done for you (and you can always reinstall dependencies by running `conda env update` or `pip install -r requirements.txt` from within the conda virtual environment). If you created your virtual environment using `virtualenv` then this required step installs the dependencies for the API.

#### `uvicorn api:app --app-dir . --reload`

Runs the app in the development mode.<br />
Open [http://localhost:8000/redoc](http://localhost:8000/redoc) to view the API docs in the browser.

#### `mypy .`

Runs linting which validates Python static type hints/annotations

### `python -m pytest tests/`

Runs tests. Some data source tests currently (lazily) use real HF databases and require [authentication through the GCP CLI](https://cloud.google.com/sdk/docs/authorizing#authorizing_with_a_user_account).

## Architecture

To read more about architecture, [see this page](/docs/architecture.md).

## Asana Board

We keep track of tasks through an [Asana board here](https://app.asana.com/0/1196959085120745/board). Tasks are typically added in the `Backlog`, `Humanity Forward Requests`, or `Prioritized To Do` sections. When a task is ready to be worked on, it can then be moved to `In Progress`. Remember to assign yourself to the task (or delegate it to someone else if you're feeling bossy...). When you are done with a task, please move it to `Done` and choose `Mark complete` in the task menu (click on the 3 dots of the task card).

## Branching and GitHub

To read more about branching, [see this page](/docs/branching.md).
