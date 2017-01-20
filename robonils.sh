#!env bash

#Repositories
GOEFIS_REMOTE=https://github.com/subugoe/goefis.git

# Directories
GOEFIS_OLD=goefis-old
LAYERDIR=$LOCAL_LAYER

git clone $GOEFIS_REMOTE $GOEFIS_OLD
cd $GOEFIS_OLD
# Git revison of old layer
#git checkout 2678bc6f2a71dfb1a1c0c4311a8443dbb6dbfbfd
#cd ..

# Directories
#cp -r $GOEFIS_OLD/config $LAYERDIR
#cp -r $GOEFIS_OLD/scss $LAYERDIR
#cp -r $GOEFIS_OLD/public $LAYERDIR
# Files
#cp $GOEFIS_OLD/views/partials/footer.tt $LAYERDIR/views
#cat $GOEFIS_OLD/views/partials/copyright.tt >> $LAYERDIR/views/footer.tt
#cat $GOEFIS_OLD/views/base/js_append.tt >> $LAYERDIR/views/footer.tt
#cp  $GOEFIS_OLD/views/partials/topbar.tt  $LAYERDIR/views
#cat  $GOEFIS_OLD/views/partials/menu.tt >> $LAYERDIR/views/topbar.tt
#cat  $GOEFIS_OLD/views/partials/title.tt >> $LAYERDIR/views/topbar.tt
#cat  $GOEFIS_OLD/views/partials/hero.tt >> $LAYERDIR/views/topbar.tt
#cp $GOEFIS_OLD/views/frontdoor/tab_* $LAYERDIR/views/publication

#rm -rf $GOEFIS_OLD

# Patching
for file in *.patch
do
     (cd  $LIBRECATHOME &&  patch -p1 -b) < "$file"
done

#Move Patched files into the layer and restore the originals
for file in **/*.orig 
do
     echo "Moving patched file ${file%.*} to $LAYERDIR"
     mv "${file%.*}" $LAYERDIR
     mv "$file" "${file%.*}"
done
