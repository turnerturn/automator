# automator
This is project is a hodge podge cocktail of various automation features.  Some features may or may not be complete.

## Prerequisites

Before you begin, ensure you have met the following requirements:

* You have a `<Mac>` machine.
* You have installed the latest version of Visual Studio Code
* You have implemented the installation instructions listed below.
* You are not beaten down by technical challenges and you have the brains to fix that which is broked.




## Instalation Instructions:

### Preparing Your Local Environment

```shell
mkdir ~/Projects
mkdir ~/Software
```

### Brew Install
Homebrew provides an installation script you can download and run with a single command (check that it hasn't changed at the Homebrew site [here](https://brew.sh/).  ). This is the easiest way to install Homebrew.
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```

### Additional Installations

The following installations are frequently used in our developement environment.  Be better than average and get ahead of the game by installing the following.

* Update Homebrew, formulae, and packages
This is likely only needed if you already had homebrew installed before following my guide...

```shell
echo "Updating Homebrew..."
brew update
brew upgrade
```

* Install Cask
Homebrew Cask extends Homebrew and brings its elegance, simplicity, and speed to the installation and management of GUI macOS applications such as Visual Studio Code and Google Chrome.
```shell
brew tap homebrew/cask-cask
```

* Install Visual Studio Code
```shell
brew install --cask visual-studio-code
```

* Install Java 11
```shell
brew install openjdk@11
```

Add Java to PATH 
_This tells your operating system to use this instance of java when you try executing 'java' on your command line._
```shell
echo 'export PATH="/usr/local/opt/openjdk@11/bin:$PATH"' >> ~/.zshrc
```

* Install GitHub CLI
```shell
brew install gh
```

* Install Python 3
```shell
brew install python
```

* Install Node.js
```shell
brew install node
```

* Update & upgrade Brew packages & cleanup
```shell
brew update
brew upgrade
brew cleanup
```


## Contributing to this project.

To contribute to this project, follow these steps:

1. Clone this project: 
```shell
git clone https://github.com/turnerturn/automator.git
```

2. Create a branch: 
```shell
git checkout -b "<branch_name>"
```

3. Make your changes and commit them: 
```shell
git commit -m "<commit_message>"
```

4. Push to the original branch: 
```shell
git push origin "<project_name>/<location>"
```
5. Create the pull request.

## Contact

If you want to contact me you can reach me at blahblah@noneyabusiness.com.

## License

This project uses the following license: `MIT`.

## Additional Resources

To learn more about the technologies used in this project and for other helpful resources, check out the following links:

* [Node.js Documentation](https://nodejs.org/docs/latest/api/)
* [Express.js Guide](http://expressjs.com/en/guide.html)
* [Node.js course on Codecademy](https://www.codecademy.com/learn/learn-node-js)
* [Painless Node.js Authentication](https://developer.okta.com/blog/2019/10/03/painless-node-authentication#use-okta-for-oidc)

