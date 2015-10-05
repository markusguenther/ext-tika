#!/usr/bin/env bash

test -n "$TIKA_PATH" || TIKA_PATH="$HOME/bin/"

# download Tika if not present
if [ ! -d "$TIKA_PATH" ]; then
	mkdir -p "$TIKA_PATH"
fi
if [ ! -f "$TIKA_PATH/tika-app-$TIKA_VERSION.jar" ]; then
	wget "http://apache.osuosl.org/tika/tika-app-$TIKA_VERSION.jar" -O "$TIKA_PATH/tika-app-$TIKA_VERSION.jar"
else
	echo "Cached $TIKA_PATH/tika-app-$TIKA_VERSION.jar present"
fi
if [ ! -f "$TIKA_PATH/tika-server-$TIKA_VERSION.jar" ]; then
	wget "http://apache.osuosl.org/tika/tika-server-$TIKA_VERSION.jar" -O "$TIKA_PATH/tika-server-$TIKA_VERSION.jar"
else
	echo "Cached $TIKA_PATH/tika-server-$TIKA_VERSION.jar present"
fi

# start tika server
echo "Starting Apache Tika"
TIKA_PID=`nohup java -jar "$TIKA_PATH/tika-server-$TIKA_VERSION.jar" > /dev/null 2>&1 & echo $!`
echo $TIKA_PID > tika_pid
echo "Tika pid: $TIKA_PID"

echo "PWD: $(pwd)"

composer require typo3/cms="$TYPO3_VERSION"
# Restore composer.json
git checkout composer.json
export TYPO3_PATH_WEB=$PWD/.Build/Web




# clone TYPO3
#git clone --single-branch --branch $TYPO3_BRANCH --depth 1 https://github.com/TYPO3/TYPO3.CMS.git typo3_core
#mv typo3_core/* .
#composer self-update
#composer install --prefer-dist
mkdir -p $TYPO3_PATH_WEB/uploads $TYPO3_PATH_WEB/typo3temp $TYPO3_PATH_WEB/typo3conf/ext/tika


# clone EXT:solr
#git clone --single-branch --branch master --depth 1 https://github.com/TYPO3-Solr/ext-solr.git solr

#mv solr typo3conf/ext/
#cp -R ext-tika/* typo3conf/ext/tika/

#cd -
