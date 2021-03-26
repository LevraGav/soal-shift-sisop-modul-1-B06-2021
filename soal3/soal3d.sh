#!/bin/bash

pwd="$(date '+%m%d%Y')"
zip -P $pwd -r Koleksi K*
rm -r Kucing*
rm -r Kelinci*
