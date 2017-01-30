#!env bash

#Repositories
GOEFIS_REMOTE=https://github.com/subugoe/goefis.git

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

# Patching
cd  $LIBRECATHOME
GIT_TAG=`git describe --tags`
EXISTING_CHANGES=`git status --porcelain --untracked-files=no | cut -d ' ' -f 3` 

echo "Git tree is at $GIT_TAG, using this to reset the tree"
echo "Ignoring existing files: $EXISTING_CHANGES"

for file in *.patch *.diff
do
    echo "Applying $file..."
    if [[ "$file" == *.diff ]] ; then
        echo "Trying git for $file"
        #if [[ `git apply -v --check --ignore-space-change --ignore-whitespace < "$file"` != 0 ]] ; then
        #    echo $?
        #    exit 48
        #fi
        
        git apply -v --ignore-space-change --ignore-whitespace < "$file"
        #Move Patched files into the layer and restore the originals
        for change in `git status --porcelain --untracked-files=no | cut -d ' ' -f 3`
        do 
            if [[ ! ${EXISTING_CHANGES[*]} =~ "$change" ]] ; then
                PATH_COMPONENT=`dirname $change`
                echo "Moving patched file $change to $LOCAL_LAYER/$PATH_COMPONENT"
                
                mkdir -p "$LOCAL_LAYER/$PATH_COMPONENT"
                mv "$change" $LOCAL_LAYER/$PATH_COMPONENT
            fi
        done
        # Reset and remove new created but untracked files
        git reset --hard $GIT_TAG # && git clean -fd
    elif [[ "$file" == *.patch ]] ; then
        echo "Trying git for $file"
        patch -p1 -b < "$file"
        #Move Patched files into the layer and restore the originals
        for file in **/*.orig 
        do
            echo "Moving patched file ${file%.*} to $LOCAL_LAYER"
            mv "${file%.*}" $LOCAL_LAYER
            mv "$file" "${file%.*}"
        done
    else
        echo "Couldn't apply patch, will fail"
        exit 23
    fi
done

