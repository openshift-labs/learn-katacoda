This quickstart tutorial shows you how to setup a Citrus Project with Maven.

Citrus as a framework integrates best with build tools like Maven or Gradle. These tools can help you to manage the
project sources and all required dependencies in order to compile, package and execute the tests in your project.

## Maven archetype

Citrus provides several Maven archetypes that can be used as a starting point for creating a new Citrus project. The
archetypes create all required source files and directories for you.
 
You can call the archetype in order to create a new project with:
 
`
mvn archetype:generate -B \
    -DarchetypeGroupId=com.consol.citrus.mvn \
    -DarchetypeArtifactId=citrus-quickstart \
    -DarchetypeVersion=2.7.1 \
    -DgroupId=org.citrus \
    -DartifactId=citrus-sample \
    -Dversion=1.0-SNAPSHOT \
    -Dpackage=org.citrus.samples
`{{execute}}

The archetype process requires some project information such as the groupId, artifactId and version of the new project.
The command executes the project archetype **citrus-quickstart** and creates the new project in the folder 
**citrus-sample**, named after the _artifactId_ of the _mvn archetype:generate_ command.
