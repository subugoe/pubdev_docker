#!/usr/bin/env bash

#Repositories
GOEFIS_REMOTE=https://github.com/subugoe/goefis.git
#####################
# The stuff below was used to extract parts of the old layer, it's keept here
# for potential reuse on top of another infrastructure.
#####################
# Directories
#GOEFIS_OLD=goefis-old

#git clone $GOEFIS_REMOTE $GOEFIS_OLD
#cd $GOEFIS_OLD
# Git revison of old layer
#git checkout 2678bc6f2a71dfb1a1c0c4311a8443dbb6dbfbfd
#cd ..

# Directories
#cp -r $GOEFIS_OLD/config $LOCAL_LAYER
#cp -r $GOEFIS_OLD/scss $LOCAL_LAYER
#cp -r $GOEFIS_OLD/public $LOCAL_LAYER
# Files
#cp $GOEFIS_OLD/views/partials/footer.tt $LOCAL_LAYER/views
#cat $GOEFIS_OLD/views/partials/copyright.tt >> $LOCAL_LAYER/views/footer.tt
#cat $GOEFIS_OLD/views/base/js_append.tt >> $LOCAL_LAYER/views/footer.tt
#cp  $GOEFIS_OLD/views/partials/topbar.tt  $LOCAL_LAYER/views
#cat  $GOEFIS_OLD/views/partials/menu.tt >> $LOCAL_LAYER/views/topbar.tt
#cat  $GOEFIS_OLD/views/partials/title.tt >> $LOCAL_LAYER/views/topbar.tt
#cat  $GOEFIS_OLD/views/partials/hero.tt >> $LOCAL_LAYER/views/topbar.tt
#cp $GOEFIS_OLD/views/frontdoor/tab_* $LOCAL_LAYER/views/publication

#rm -rf $GOEFIS_OLD

#####################
# The currently used part start here
#####################

# Either we add a test if we have a path to operate on, or we keep it as it is and 
# use this thing by setting two environment variables:
# $LIBRECATHOME where the sources are (Patches will be applied here)
# $LOCAL_LAYER where should the generated files be moved to

# Patching
cd  $LIBRECATHOME
GIT_TAG=`git describe --tags`
EXISTING_CHANGES=`git status --porcelain --untracked-files=no | cut -d ' ' -f 3` 
LIBRECAT_PATCH_LEVEL=`cat .librecat-version | tr -d .`

echo "Git tree is at $GIT_TAG, using this to reset the tree"
echo "Ignoring existing files: $EXISTING_CHANGES"

DOCKER_CHANGES=`ls *.patch *.diff *.py robonils.sh .librecat-version`

VERSIONFILE=public/version.txt

for file in `ls *.patch *.diff`
do
    echo "Trying git for $file"
    #TODO: This is needed to make the build fail
    #if [[ `git apply -v --check --ignore-space-change --ignore-whitespace < "$file"` != 0 ]] ; then
    #    echo $?
    #    exit 48
    #fi
    #Test if we have an version specific patch
    if [[ $file == 9* ]] ; then
        echo "Got version dependent patch $file"
    	if [[ $file == 9$LIBRECAT_PATCH_LEVEL* ]] ; then
    	    echo "LibreCat is at $LIBRECAT_PATCH_LEVEL, patch $file will be applied"
    	    git apply --binary -v --ignore-space-change --ignore-whitespace < "$file"
    	    echo -n ' + ' >> public/version.txt
    	    VERSION=`grep 'From ' "$file" | cut -d ' ' -f 2`
    	    if [[ -z "${VERSION// }" ]] ; then
    	    	VERSION=$file
    	    fi
    	    echo $VERSION >> $VERSIONFILE
    	fi
    else
        git apply --binary -v --ignore-space-change --ignore-whitespace < "$file"
    fi
done

echo "Generated Version file is:"
cat $VERSIONFILE
# Run the SASS tool
node-sass --output-style expanded --source-map-embed scss/main.scss public/css/main.css

# Extract changes and move them to layer
# Move Patched files into the layer and restore the originals from Git
for change in `git status --porcelain --untracked-files=no | cut -d ' ' -f 3`
do 
    if [[ ! ${EXISTING_CHANGES[*]} =~ "$change" ]] ; then
        PATH_COMPONENT=`dirname $change`
        echo "Moving patched file $change to $LOCAL_LAYER/$PATH_COMPONENT"
        mkdir -p "$LOCAL_LAYER/$PATH_COMPONENT"
        mv "$change" $LOCAL_LAYER/$PATH_COMPONENT
    fi
done
# Move the version file: Since it's changed by the Docker base image to the actual version,
# the loop above doesn't identify it as a part of the layer.
cp $VERSIONFILE $LOCAL_LAYER/public

# Find Changes, that haven't been there before (additions)   
for change in `git ls-files --others --exclude-standard`
do 
    if [[ ! ${DOCKER_CHANGES[*]} =~ "$change" ]] ; then
        PATH_COMPONENT=`dirname $change`
        echo "Moving added file $change to $LOCAL_LAYER/$PATH_COMPONENT"
        mkdir -p "$LOCAL_LAYER/$PATH_COMPONENT"
        mv "$change" $LOCAL_LAYER/$PATH_COMPONENT
    fi
done
# Reset and (TODO) remove new created but untracked files
git reset --hard $GIT_TAG # && git clean -fd