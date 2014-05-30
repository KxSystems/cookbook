#!/bin/bash
# run rdb demo

P=~/q/start/tick/run1.sh

for f in ticker rdb hlcv last tq show vwap feed
do $P $f; done
