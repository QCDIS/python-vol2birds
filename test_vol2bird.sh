#!/bin/sh

vol2bird --version &> version || true
if  grep -q 'vol2bird version' version ; then cat version ;  else exit 255;  fi

vol2bird --version &> version || true
if  grep -q 'vol2bird version' version ; then cat version ;  else exit 255;  fi