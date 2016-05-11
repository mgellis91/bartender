#!/bin/bash

#  _                _                 _                     _
# | |              | |               | |                   | |
# | |__   __ _ _ __| |_ ___ _ __   __| | ___ _ __       ___| |__
# | '_ \ / _` | '__| __/ _ \ '_ \ / _` |/ _ \ '__|     / __| '_ \
# | |_) | (_| | |  | ||  __/ | | | (_| |  __/ |     _  \__ \ | | |
# |_.__/ \__,_|_|   \__\___|_| |_|\__,_|\___|_|    (_) |___/_| |_|

#bartender.sh is a shell script to automate the process of creating a
#static web project using the sass bourbon libraries
#created by Matt Ellis

#usage bartender.sh <options> <projectName>
#options -n neat -b bitters.

#eg bartender.sh -nb test (creates a project called test using both neat and bitters
#                         ontop of the default bourbon library)

useNeat=false
useBitters=false
noOpts=true
projectName=""

while getopts ":bn" opt; do
  case $opt in
    b)
      useBitters=true noOpts=false;;
    n)
      useNeat=true noOpts=false ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

#handle options and project name
if [ $noOpts = true ] && [ ! -z $1 ] #no options triggered - just project directory
  then
    projectName=$1
    #check to make sure correct number of arguments or options havent been given after project directory
    if [ "$#" -ne 1 ]; then
      echo "Error: incorrect number of arguments given or options specifed after project name"
      exit
    fi
elif [ $noOpts = false ] #options specifed and project directory given
  then
    for val in "$@"
    do
      #check if arg is not a possible option or option combination
      if [ $val != "-b" ] && [ $val != "-n" ] && [ $val != "-bn" ] && [ $val != "-nb" ]
        then projectName=$val
      fi
    done
else #no args given
  echo "no args given"
  exit
fi

function checkForGem () {
  echo "checking for " $1 "gem"
  if [ $(gem list -i $1) == "true" ]
  then
     echo $1 "is installed"
  else
    echo $1 "is not installed. Would you like to install it?"
    if [ $1 == "bourbon" ]; then
      echo "WARNING: bourbon is required for the script to work. script will be
      exited if it's not installed"
    fi
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) echo "installing" $1...;
              sudo gem install $1;
              break;;
        No ) if [ $1 == "bourbon" ]; then
                echo $1 "was not installed. Exiting script..."; exit;
             fi
              echo $1 "was not installed. $1 files will not be added in the setup"; break;;
      esac
    done
  fi
}

#always check for bourbon because its a dependency for the other gems
checkForGem bourbon

if [ $useNeat = true ]; then
   checkForGem neat
fi

if [ $useBitters = true ]; then
  checkForGem bitters
fi


echo "creating "$projectName" directory"
mkdir $projectName

cd $projectName

echo "creating " $projectName"/js directory"
mkdir js

echo "creating " $projectName"/img directory"
mkdir img

echo "creating " $projectName"/css directory"
mkdir css

echo "creating " $projectName"/scss directory"
mkdir scss

cd scss

echo "Adding bourbon files to " $projectName"/scss directory"
bourbon install

if [ $useNeat = true ]; then
  echo "Adding neat files to " $projectName"/scss directory"
  neat install
fi

if [ $useBitters = true ]; then
  echo "Adding bitters files to " $projectName"/scss directory"
  bitters install
fi

echo "creating _variables.scss in " $projectName"/scss directory"
touch _variables.scss

echo "creating _mixins.scss in " $projectName"/scss directory"
touch _mixins.scss

echo "creating main.scss in" $projectName"/scss directory"
touch main.scss

echo '@import "bourbon/bourbon";' >> main.scss

if [ $useBitters = true ]; then
  echo '@import "base/base";' >> main.scss
fi

if [ $useNeat = true ]; then
  echo '@import "neat/neat";' >> main.scss
fi

echo '
@import "variables";
@import "mixins";' >> main.scss

cd ../

echo "creating index.html file in " $projectName" directory"
cat <<EOT>> index.html
<!Doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bartender Template</title>
    <link rel="stylesheet" href="css/main.css" />
  </head>
  <body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0-beta1/jquery.min.js"></script>
    <script src="js/main.js"></script>
  </body>
</html>
EOT

cd js

echo "creating main.js file in " $projectName"/js directory"
touch main.js

cd ../
echo "compiling main.scss"
sass scss/main.scss:css/main.css

echo "ORDER UP... cd into "$projectName"/ and drink it in"
