![Rodimus Prime](https://raw.github.com/meltmedia/rodimus/master/src/test/resources/testCases/image-test/images/image1.jpeg)

#Rodimus

A Word to HTML5 Document Transformer

[![Build Status](https://secure.travis-ci.org/meltmedia/rodimus.png?branch=master)](https://travis-ci.org/meltmedia/rodimus)

meltmedia innovation project by @ctrimble and @10xLaCroixDrinker

#Installation

This project requires that the following to be preinstalled:

* [Homebrew 0.9.X](http://mxcl.github.com/homebrew/) - You can check your home homebrew version by running `brew -v`.
* [Maven 3.0.3](http://maven.apache.org) (or greater) - You can check your Maven version by running `mvn -v`.

Once all of the dependencies are installed, you can use Homebrew to install rodimus:

```bash
brew tap meltmedia/homebrew-meltmedia
brew install --HEAD rodimus
```

#Usage

To use rodimus, simply pass in the file to convert and an optional output directory:

```bash
rodimus <INPUT_FILE> [<OUTPUT_DIR>]
```

If no output directory is specified, then the output will be placed in a directory based on the name of the input file.

#Building this Project

This project requires Maven 3.0.3 or later to be installed.  Use these steps to checkout and build the project:

```
git clone git@github.com:meltmedia/rodimus.git
cd rodimus
mvn clean install
```

Once you have the project built, you can execute the command line using:

```
./target/rodimus <INPUT_FILE> [<OUTPUT_DIR>]
```

#Adding Test Cases

`src/test/resources/testCases` contains a set of example input document and expected output directories.  Simply
add new input and output documents to this directory to define new test cases.  For example,
to add a new test for `case-x`, you would add input and output documents like this:

Input:
```bash
src/test/resources/testCases/case-x.docx
```
Expected Output:
```bash
src/test/resources/testCases/case-x/index.html
src/test/resources/testCases/case-x/img/image1.jpeg
```
