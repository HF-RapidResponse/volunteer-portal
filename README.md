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

Running the API locally requires connecting to HF's databases. Make sure you have been given the correct permissions in GCP and have [authenticated through the GCP CLI](https://cloud.google.com/sdk/docs/authorizing#authorizing_with_a_user_account). In order for the API to use GCP, setup a local environment variable, `GOOGLE_APPLICATION_CREDENTIALS`. Set it to the full local path to the Google Application Credentials JSON file provided to you as a volunteer. You can setup this variable either in a local `.env` file, or as an environment variable.

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

## Contributing

### Branching Model

If you are looking to contribute to this project, please first familiarize yourself with [Vincent Driessen's Git branching model](https://nvie.com/posts/a-successful-git-branching-model/), as this repo's branching model follows from Driessen's.

#### Development branches

The `develop` branch is the main development branch, it contains the project's working codebase, with newly developed features that are ready for implementation in production. Think of it as 'beta' code, the features are there but haven't been given a proper testing before being pushed to production.

If you are working on a new feature, component, fix, or whatnot, you will want to create a branch off `develop`, referred to as a feature branch. The easiest way to do this from the command line is `git checkout -b {branch name} develop`. A feature branch can be named whatever you want, but should not contain `master`, `develop`, `release`, or `hotfix` in the branch name.

All development work should be done on a feature branch, and when it is ready to be integrated into the development code base, a pull request should be created to merge the changes into `develop`. Make sure to add at least one reviewer to the pull request. Once the feature branch is merged into `develop` it may be deleted.

#### Production branches

Once `develop` has reached a release-ready state (most likely this will be once a release featureset target has been met) a new branch should be created off of `develop` named `release-{version}`, where `{version}` is whatever version number is applicable for the release. See [Semantic Versioning](https://semver.org/) for guidance on what version numbering to use for any particular release. Generally release branches will bump the minor version number, unless there are breaking changes, in which case the major version number will be bumped. Pre-release (below v1.0.0) versioning is more informal and can generally follow any numbering scheme.

Release branches are dedicated specifically to rigorous testing and fixing of the code prior to it reaching production. All commits on a release branch should be for this purpose and this purpose alone. Make sure to add all apropriate reviewers to the pull request as well.

Once a release branch is ready to merge into `master` a pull request should be made for this with at least two reviewers.

After a successful pull request is made from a release branch to `master`, any applicable deployment steps should commence. The release branch should then be merged into the `develop` branch to catch `develop` up on any changes that were made in the release branch. After this is done, the release branch can be deleted.

#### Hotfix branches

If bug(s) are identified in `master` that cannot wait for a regular release cycle then a hotfix branch should be created off of `master`, named `hotfix-{version}`. Versioning of hotfixes should follow the same [Semantic Versioning](https://semver.org/) guidelines as releases do, however should be limited to bumping the patch version only.

Once the bugfix(es) are complete in the hotfix branch, a pull request should be created to merge it back into `master`, with at least two reviewers. The process after the pull request is sucessfully merged for a hotfix branch is the same as with a release branch: deployment processes & merge the hotfix into `develop`, then the hotfix branch can be deleted.
