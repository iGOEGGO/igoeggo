#!/bin/bash
DIR=/var/lib/igoeggo

sudo rm -rf $DIR 2> /dev/null

sudo mkdir -p $DIR/database
sudo mkdir -p $DIR/shiny_bookmarks

sudo cp template.db $DIR/database/database.db

sudo chmod -R a+rw $DIR/database

