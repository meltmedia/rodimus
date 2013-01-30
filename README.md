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
