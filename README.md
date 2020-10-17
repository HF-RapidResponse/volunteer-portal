# Volunteer Portal for Humanity Forward

This web app serves as a launch point for volunteers who want to get involved with [Humanity Forward](https://movehumanityforward.com/).

## System Requirements

Running this code requires the developer to have a working computer with a terminal (built-in terminal for Linux/OSX or something like [Git Bash](https://git-scm.com/downloads)), an IDE such as [Visual Studio Code](https://code.visualstudio.com/), and [Node](https://nodejs.org/en/) installed globally. There is no mandated node version in the package files, but the developer team is running on version 14.x.

## Setup

To run this code locally, it must first be cloned from GitHub. This can be done with the following command:

`git clone https://github.com/HF-RapidResponse/volunteer-portal.git`

The URL for cloning comes from the top right portion of the repo page.

### Client

In the _client_ directory, you can run:

#### `npm install` or `npm i`

Installs the packages required to run this project locally. This is the first command developers must run after cloning.

#### `npm start`

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

In the _api_ directory you can run:

#### `conda env create`

Creates an isolated Python environment and installs the packages required to run this project locally. This is the first command developers must run after cloning before working on the API.

Python packages and environments are managed via [Conda](https://docs.conda.io/en/latest/miniconda.html)

#### `conda activate volunteer-portal`

Activates the virtual environment that the dependencies were installed in to enable you to run the API. This command must be run in a terminal session before running the below commands.

#### `uvicorn app:app --app-dir . --reload`

Runs the app in the development mode.<br />
Open [http://localhost:8000](http://localhost:8000/redoc) to view the API docs in the browser.

#### `mypy .`
Runs linting which validates Python static type hints/annotations
