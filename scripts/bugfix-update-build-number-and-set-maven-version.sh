#!/bin/bash
echo "============================================================"
echo "DEBUG - Fetching Major.Minor.Patch-Qualifier-Build Details"
echo "------------------------------------------------------------"

POM_VERSION=$(mvn help:evaluate -Dexpression='project.version' -q -DforceStdout);

echo "DEBUG - POM_VERSION: $POM_VERSION"

MAJOR_VERSION=$(echo $POM_VERSION | cut -d. -f1)
MINOR_VERSION=$(echo $POM_VERSION | cut -d. -f2)
PATCH_VERSION=$(echo $POM_VERSION | cut -d. -f3 | cut -d- -f1)
MAVEN_QUALIFIER=$(echo $POM_VERSION | cut -d- -f2)
VERSION_WITHOUT_BUILD_NUMBER=$(echo $MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION-$MAVEN_QUALIFIER-)
VERSION_BUILD_NUMBER=$(echo $POM_VERSION | cut -d- -f3)

echo "DEBUG - MAJOR_VERSION: $MAJOR_VERSION"
echo "DEBUG - MINOR_VERSION: $MINOR_VERSION"
echo "DEBUG - PATCH_VERSION: $PATCH_VERSION"
echo "DEBUG - MAVEN_QUALIFIER: $MAVEN_QUALIFIER"
echo "VERSION_WITHOUT_BUILD_NUMBER: ${VERSION_WITHOUT_BUILD_NUMBER}"
echo "VERSION_BUILD_NUMBER: ${VERSION_BUILD_NUMBER}"

echo "------------------------------------------------------------"
echo "DEBUG - Incrementing Build Number"
echo "------------------------------------------------------------"

UPDATED_BUILD_NUMBER=$(expr $VERSION_BUILD_NUMBER + "1")
echo "Updated Build Number: $UPDATED_BUILD_NUMBER"

echo "------------------------------------------------------------"
echo "DEBUG - Setting New Maven Version"
echo "------------------------------------------------------------"

mvn build-helper:parse-version versions:set -DnewVersion=$VERSION_WITHOUT_BUILD_NUMBER$UPDATED_BUILD_NUMBER versions:commit

echo "============================================================"

