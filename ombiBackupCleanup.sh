#!/bin/sh

find /opt/ombiBackups/* -mtime +5 -exec rm {} \;
