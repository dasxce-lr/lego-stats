# README

This repository contains the following.
- `get-be-simple.sh` - a script to get data from BrickEconomy with a list of Lego set IDs
- `example-input/` - a directory with a CSV file for what the expected input should look like
- `example-output/` - a directory containing the expected output from running the script

# Example usage

Running the following command should create the contents of `example-output/`.

`epoch="example-output/$(date +%s)"; bash get-be-simple.sh example-input/data.csv $epoch`

(The timestamp you generate will likely differ, but these timestamps can be useful to refer back to old BE data that you have downloaded.)

The file containing the BrickEconomy data of all sets from the input file is `example-output/1687973873/timeline-be.csv`. You can open this file in any CSV reader to more easily digest the data. E.g., You can import the `example-output/1687973873/timeline-be.csv` into [Google sheets](https://docs.google.com/spreadsheets/d/1WtsMAJDHcxTdCnoeWViDsxjRuaVCgKQEw21Xl-yB8mg).

To get the data from BrickEconomy, `get-be-simple.sh` downloads the webpage for each unique set in `example-input/data.csv`. If you wish to avoid this script from continually consuming disk space when you run it, simply save the `example-output/*/timeline-be.csv` each time you run the commend and then delete everything else (e.g., `rm example-output/*/*.html`).

# Requirements

This script was tested on a standard Mac and Linux machine and does not require any specialized tools beyond standard unix commands (e.g., `wget`, `cut`, `echo`, `mkdir`, `grep`, `sleep`, `sed`). Running the script on Windows Subsystem for Linux is likely to work.
