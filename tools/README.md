This directory contains build tools for shinydashboard.

## JavaScript build tools

### First-time setup

Shinydashboard's JavaScript build tools use Node.js, along with [yarn](https://yarnpkg.com/) to manage the JavaScript packages.

Installation of Node.js differs across platforms and is generally pretty easy, so I won't include instructions here.

There are also a number of ways to [install yarn](https://yarnpkg.com/en/docs/install) depending on your operating system. Follow the appropriate one and, once you have that installed, go to this directory (tools/), and run the following to install the packages:

```
yarn
```
  
### Adding packages

If in the future you want to a package, run:

```
yarn add --dev [packagename]
```

This will automatically add the package to the dependencies in package.json, and it will also update the yarn.lock to reflect that change. If someone other than yourself does this, simply run `yarn` to update your local packages to match the new package.json.


### Upgrading packages
Periodically, it's good to upgrade the packages to a recent version. There's two ways of doing this, depending on your intention:

1. Use `yarn upgrade` to upgrade all dependencies to their latest version based on the version range specified in the package.json file (the yarn.lock file will be recreated as well. Yarn packages use [semantic versioning](https://yarnpkg.com/en/docs/dependency-versions), i.e. each version is writen with a maximum of 3 dot-separated numbers such that: `major.minor.patch`. For example in the version `3.1.4`, 3 is the major version number, 1 is the minor version number and 4 is the patch version number. Here are the most used operators (these appear before the version number):

    - `~` is for upgrades that keep the minor version the same (assuming that was specified);

    - `^` is for upgrades that keep the major version the same (more or less -- more specifically, it allow changes that do not modify the first non-zero digit in the version, either the 3 in 3.1.4 or the 4 in 0.4.2.). This is the default operator added to the package.json when you run `yarn add [package-name]`.

2. Use `yarn upgrapde [package]` to upgrade a single named package to the version specified by the latest tag (potentially upgrading the package across major versions).

### More info on yarn
For information, see the [yarn workflow documentation](https://yarnpkg.com/en/docs/yarn-workflow).

### Grunt

Grunt is a build tool that runs on Node.js (and installed using `yarn`). In shinydashboard, it is used for minifying and linting Javascript code.

#### Installing Grunt and the Grunt CLI (command line interface)

Grunt is a package listed in package.json, so if you've done the previous step, that's already installed. However, as a developer, you also need to install a sister package (called `grunt-cli`) globally:

```
# Install grunt command line tool globally
sudo yarn global add grunt-cli
```

Here's what has happened (from the [Grunt Getting Started guide](http://gruntjs.com/getting-started)):

> This will put the `grunt` command in your system path, allowing it to be run from any directory.
>
> Note that installing `grunt-cli` does not install the Grunt task runner! The job of the Grunt CLI is simple: run the version of Grunt which has been installed next to a `Gruntfile`. This allows multiple versions of Grunt to be installed on the same machine simultaneously.

And here is how the CLI works (same source):

> Each time `grunt` is run, it looks for a locally installed Grunt using node's `require()` system. Because of this, you can run `grunt` from any subfolder in your project.
>
> If a locally installed Grunt is found, the CLI loads the local installation of the Grunt library, applies the configuration from your `Gruntfile`, and executes any tasks you've requested for it to run. To really understand what is happening, [read the code](https://github.com/gruntjs/grunt-cli/blob/master/bin/grunt).
 
### Using Grunt

To run all default grunt tasks specified in the Gruntfile (minification and jshint), simply go into the `tools` directory and run:

```
grunt
```

It's also useful to run `grunt` so that it monitors files for changes and run tasks as necessary. This is done with:

```
grunt watch
```
