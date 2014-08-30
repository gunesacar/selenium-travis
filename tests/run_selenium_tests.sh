trap 'rm -rf PBTESTENV' EXIT  # Clean virtualenv dir on exit
virtualenv PBTESTENV
source PBTESTENV/bin/activate
pip install -r sel_requirements.txt

export VERSION=$(echo $BROWSER | sed -e's/[^-]*-//')
export BROWSER=$(echo $BROWSER | sed -e's/-.*//')

# https://github.com/PolymerLabs/polymerchromeapp/blob/master/components/web-animations-js/.travis-setup.sh
echo BROWSER=$BROWSER
echo VERSION=$VERSION
echo "*************************"
echo "Running $BROWSER $VERSION"
echo "*************************"


case $BROWSER in
Chrome)
	echo "Getting $VERSION of $BROWSER"
	export CHROME=google-chrome-${VERSION}_current_amd64.deb
	wget https://dl.google.com/linux/direct/$CHROME
	sudo dpkg --install $CHROME || sudo apt-get -f install
	which google-chrome
	ls -l `which google-chrome`
	
	if [ -f /opt/google/chrome/chrome-sandbox ]; then
		export CHROME_SANDBOX=/opt/google/chrome/chrome-sandbox
	else
		export CHROME_SANDBOX=$(ls /opt/google/chrome*/chrome-sandbox)
	fi
	
	# Download a custom chrome-sandbox which works inside OpenVC containers (used on travis).
	sudo rm -f $CHROME_SANDBOX
	sudo wget https://googledrive.com/host/0B5VlNZ_Rvdw6NTJoZDBSVy1ZdkE -O $CHROME_SANDBOX
	sudo chown root:root $CHROME_SANDBOX; sudo chmod 4755 $CHROME_SANDBOX
	sudo md5sum $CHROME_SANDBOX
	
	google-chrome --version
	;;

Firefox)
	sudo rm -f /usr/local/bin/firefox
	case $VERSION in
	beta)
		yes "\n" | sudo add-apt-repository -y ppa:mozillateam/firefox-next
		;;
	aurora)
		yes "\n" | sudo add-apt-repository -y ppa:ubuntu-mozilla-daily/firefox-aurora
		;;
	esac
	sudo apt-get update --fix-missing
	sudo apt-get install firefox
	which firefox
	ls -l `which firefox`
	firefox --version
	;;
esac


export ENABLE_XVFB=1    # run the tests headless using Xvfb. Set 0 to disable
py.test -s selenium  # autodiscover and run the tests

