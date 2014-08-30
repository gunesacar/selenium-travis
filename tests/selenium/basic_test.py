#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import unittest
from xvfbwrapper import Xvfb
from selenium import webdriver


class Test(unittest.TestCase):

    def setUp(self):
        self.xvfb = os.environ.get("ENABLE_XVFB", False)
        if self.xvfb:
            self.vdisplay = Xvfb(width=1280, height=720)
            self.vdisplay.start()
        self.driver = webdriver.Firefox()

    def tearDown(self):
        if self.driver:
            self.driver.quit()
        if self.xvfb and self.vdisplay:
            self.vdisplay.stop()

    def test_load_wikipedia(self):
        self.driver.get("https://www.wikipedia.org")
        self.assertIn("Wikipedia", self.driver.title)

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()
