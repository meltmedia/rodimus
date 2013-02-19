#Rodimus
##A Document Transformer for Word Formats
meltmedia innovation project by @ctrimble and @jking90

###Installation
- `wget http://…rodimus-1.0.jar -O rodimus-1.0.jar` (URL to be published)
- add `alias rodimus='java -jar {path}/rodimus-1.0.jar'` to your profile

###Use
- `rodimus {input_file}.docx > {output_directory}/`
- conversion will run and output an `index.html` file and an `images/` directory

###Dependancies
- All dependancies are self contained

Rodimus CLI
-----------

This project produces an executable jar for Rodimus.

Building this Project
---------------------

This project requires Maven 3.0.3 or later to be installed.  Use these steps to checkout and build the project:

```
git clone git@github.com:meltmedia/rodimus.git
cd rodimus
git checkout -b cli-develop
mvn clean install
```

Once you have the project built, you can execute the command line using:

```
java -jar target/rodimus-0.1.0-SNAPSHOT.jar <INPUT_FILE>
```

Adding Test Cases
-----------------

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
