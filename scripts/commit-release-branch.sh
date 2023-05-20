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
VERSION_WITHOUT_BUILD_NUMBER=$(echo $POM_VERSION | sed 's/^\(.*-\)\([0-9]*\)$/\1/')
VERSION_BUILD_NUMBER=$(echo $POM_VERSION | sed 's/^\(.*-\)\([0-9]*\)$/\2/')

echo "DEBUG - MAJOR_VERSION: $MAJOR_VERSION"
echo "DEBUG - MINOR_VERSION: $MINOR_VERSION"
echo "DEBUG - PATCH_VERSION: $PATCH_VERSION"
echo "DEBUG - MAVEN_QUALIFIER: $MAVEN_QUALIFIER"
echo "VERSION_WITHOUT_BUILD_NUMBER: ${VERSION_WITHOUT_BUILD_NUMBER}"
echo "VERSION_BUILD_NUMBER: ${VERSION_BUILD_NUMBER}"

echo "------------------------------------------------------------"
echo "DEBUG - Commit to Release Branch"
echo "------------------------------------------------------------"

if [[ $JOB_NAME == 'bugfix-release' ]]
then
    git checkout release/$MAJOR_VERSION.$MINOR_VERSION-${VERSION_BUILD_NUMBER};
   # git add pom.xml;
   # git commit -m "Bugfix release RC-${env.VERSION_BUILD_NUMBER}";
    git push --set-upstream origin release/$MAJOR_VERSION.$MINOR_VERSION-${VERSION_BUILD_NUMBER};  
elif [[ $JOB_NAME == 'build-hotfix' ]]
then
    git add pom.xml;
    git commit -m "Hotfix Release $POM_VERSION";
    git checkout -b hotfix/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION;
    git push --set-upstream origin hotfix/$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION; 
else
    git checkout release/$MAJOR_VERSION.$MINOR_VERSION;
    git add pom.xml;
    git commit -m "Prepare release RC-0";
    git push --set-upstream origin release/$MAJOR_VERSION.$MINOR_VERSION; 
fi

echo "============================================================"

