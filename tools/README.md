This directory contains build tools for shinydashboard.


## Grunt

Grunt is a build tool that runs on node.js. In shinydashboard, it is used for minifying and linting Javascript code.

### Installing Grunt

Grunt requires Node.js and npm (the Node.js package manager). Installation of these programs differs across platforms and is generally pretty easy, so I won't include instructions here.

Once node and npm are installed, install grunt:

```
# Install grunt command line tool globally
sudo npm install -g grunt-cli

# Install grunt plus modules for this project
npm install
```

### Using Grunt

To run all default grunt tasks (minification and jshint), simply go into the `tools` directory and run:

```
grunt
```

It's also useful to run `grunt` so that it monitors files for changes and run tasks as necessary. This is done with:

```
grunt watch
```
