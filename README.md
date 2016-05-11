# Bartender.sh
bartender.sh is a shell script to automate the process of creating a
static web project using the sass bourbon libraries

# Installation
clone / download repo
```
$ git clone https://github.com/mgellis91/bartender.git
```
make bartender.sh executable
```
$ cd bartender
$ sudo chmod +x bartender.sh
```
# Global Installation
If you want to be able to use bartender.sh from any directory copy the script to a directory that is included in your PATH environment variable such as /usr/local/bin

```
$ sudo cp bartender.sh /usr/local/bin/bartender.sh
```

# Usage
bartender.sh takes one mandatory argument which is the name of the project you want to create that can be preceded with optional flags to specify any additional libraries to include. The bourbon library is always included by default because it's a dependency for the other libraries

##### flags
**-n** : include the [neat]() library
**-b** : include the [bitters]() library
**no flags** : just use default bourbon

Eg : project called **testProject** that uses bourbon , neat and bitters
```
$ bartender.sh -nb testProject
```

# Directory Structure
Directory structure given both bitters and neat are included
```
├── <projectDirectory>
│   ├── index.html
│   ├── css/
│   │   ├── main.css
│   │   ├── main.css.map
│   ├── img/
|   ├── js/
│   │   ├── main.js
│   ├──  scss/
│   │   ├── base/
│   │   ├── bourbon/
|   |   ├── neat/
|   |   ├── _variables.scss
|   |   ├── _mixins.scss
|   |   ├── main.scss
```
