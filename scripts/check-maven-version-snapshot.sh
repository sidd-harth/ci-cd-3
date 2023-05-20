#!/bin/bash
echo "=================================================="
echo "DEBUG - Reading POM file to obtain current version"
echo "--------------------------------------------------"

POM_SNAPSHOT_VERSION=${POM_VERSION}
# POM_SNAPSHOT_VERSION=$(mvn help:evaluate -Dexpression='project.version' -q -DforceStdout);
echo "DEBUG - Pom version: $POM_SNAPSHOT_VERSION"
echo "DEBUG - Major version: ${POM_MAJOR_VERSION}"
echo "DEBUG - Minor version: ${POM_MINOR_VERSION}"
echo "DEBUG - Patch version: ${POM_PATCH_VERSION}"
echo "DEBUG - Maven Qualifier: ${POM_MAVEN_QUALIFIER}"

# POM_MAJOR_VERSION=$(mvn help:evaluate -Dexpression='project.version' -q -DforceStdout |  cut -d. -f1 );
# POM_MINOR_VERSION=$(mvn help:evaluate -Dexpression='project.version' -q -DforceStdout |  cut -d. -f2 );
# POM_PATCH_VERSION=$(mvn help:evaluate -Dexpression='project.version' -q -DforceStdout |  cut -d. -f3 | cut -d- -f1 ); 
# 
# echo MAJOR_VERSION=$POM_MAJOR_VERSION >> build-${BUILD_NUMBER}-pom-version.properties
# echo MINOR_VERSION=$POM_MINOR_VERSION >> build-${BUILD_NUMBER}-pom-version.properties
# echo PATCH_VERSION=$POM_PATCH_VERSION >> build-${BUILD_NUMBER}-pom-version.properties


if [[ $POM_SNAPSHOT_VERSION == *"-SNAPSHOT"* ]];
then
 echo "DEBUG - It's an Snapshot version"
 echo "=================================================="
else
 echo "DEBUG - Version is NOT an Snapshot"
 echo "ERROR - Script failed and will exit"
 echo "=================================================="
 exit -1
fi
