#!/bin/bash
echo "============================================================"
echo "DEBUG - Fetching Major Minor Version for Release Branch Name"
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
echo "DEBUG - Decrementing Build Number to get verious branch Number"
echo "------------------------------------------------------------"

DECREMENTED_BUILD_NUMBER=$(expr $VERSION_BUILD_NUMBER - "1")
echo "Updated Build Number: $DECREMENTED_BUILD_NUMBER"

echo "------------------------------------------------------------"
echo "DEBUG - Create Release Branch"
echo "------------------------------------------------------------"

if [[ $JOB_NAME == 'bugfix-release' ]]
then
    git add pom.xml   
    git commit -m "Bugfix release for $POM_VERSION"
    git checkout -b release/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION-${VERSION_BUILD_NUMBER} bugfix/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION-$DECREMENTED_BUILD_NUMBER;
elif [[ $JOB_NAME == 'prepare-hotfix' ]]
then
    git checkout -b hotfix/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION main;
elif [[ $JOB_NAME == 'prepare-minor-release' ]]
then
    git checkout develop;
    git checkout -b release/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION develop;
elif [[ $JOB_NAME == 'build-release' ]]
then
    git add pom.xml   
    git commit -m "Build Release RC-${VERSION_BUILD_NUMBER}";
    git checkout -b release/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION-${VERSION_BUILD_NUMBER} release/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION;
else
    git checkout develop;
    git checkout -b release/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION develop;
fi

echo "============================================================"

