#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import unittest
from xvfbwrapper import Xvfb
from selenium import webdriver
from selenium.webdriver.chrome.options import Options


class Test(unittest.TestCase):

    def setUp(self):
        self.xvfb = os.environ.get("ENABLE_XVFB", False)
        if self.xvfb:
            self.vdisplay = Xvfb(width=1280, height=720)
            self.vdisplay.start()

    def tearDown(self):
        if self.driver:
            self.driver.quit()
        if self.xvfb and self.vdisplay:
            self.vdisplay.stop()

    def test_ff(self):
        self.driver = webdriver.Firefox()
        self.driver.get("https://www.wikipedia.org")
        self.assertIn("Wikipedia", self.driver.title)

    def test_chrome(self):
        opts = Options()
        if "TRAVIS" in os.environ:  # github.com/travis-ci/travis-ci/issues/938
            opts.add_argument("--no-sandbox")
        # Fix for https://code.google.com/p/chromedriver/issues/detail?id=799
        opts.add_experimental_option("excludeSwitches",
                                     ["ignore-certificate-errors"])
        self.driver = webdriver.Chrome(chrome_options=opts)
        self.driver.get("https://www.wikipedia.org")
        self.assertIn("Wikipedia", self.driver.title)

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()
