#!/bin/bash

cd dotfiles
echo "script executed from ${PWD}"
git add .
git commit -m "auto commit"
git push origin main

