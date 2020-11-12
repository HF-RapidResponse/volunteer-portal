# Architecture

## Front End

The front end client is running on Node and using React. As of now, it is using React 16.x, and the recommended version of Node is 12.x (installed globally). The scaffold was created from `Create React App` and then the unnecessary files were removed (we're not hosting a spinning React logo). Unless you're sure of what you're doing, please do not edit the files in the public folder. Most of the editing will be doing within the src folder.

React allows to make interactive UIs, divide different parts of our website into components, and respond to changes in state. To learn more about React, [take a look at their docs](https://reactjs.org/docs/getting-started.html).

### Components

The main component is in `App.js`. It renders the child components, and these files are located in the `components` folder. For now, we have two major child components from `App`: `Header` and `PageViewSwitch`. If we end up adding a footer that appears on every page, we would place it here as well. We may branch off files within this folder as the website grows, but for now, all child components are in the same folder.

### Styling

CSS files will all be in the `styles` folder. Since we are Sass (.scss files), variables can be created. We typically put all the often used variables inside the `_variables.scss` file. They can simply point to a single value a mathematical computation. The `base.scss` is the main styling file that automatically gets loaded from `App.js`. Other Sass files can be used for styling on a specific page. We typically give a Sass file a similar name to a specific component if it's styling for just that component (e.g. `about.scss` for styling just `About.js`). To read more about Sass, [take a look at their docs](https://sass-lang.com/documentation/syntax).

### Future Considerations

We may possibly add Redux to handle API calls in the future. For now, we are using embedded Airtables to display things such as the events calendar and volunteer role openings. Pictures for now are also hosted on the front end client. They should be placed in the `assets` folder.

Testing is something we may do more in the future especially if we utilize Redux. However, the testing utility we are using can be a bit clunky with React. For now, there aren't any hard requirements for testing, but please test what you can. Testing will most likely be enforced more in the back end as well.

## Back End

As of this writing, the API is still under construction, but it will be using Python/MyPy with FastAPI (as opposed to SlowAPI). Stay tuned!
