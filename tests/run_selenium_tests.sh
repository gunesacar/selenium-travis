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

export ENABLE_XVFB=1    # run the tests headless using Xvfb. Set 0 to disable
py.test -s selenium  # autodiscover and run the tests

