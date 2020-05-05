#!/bin/bash
sass --watch web/style/:web/style -tcompressed &
webdev serve --release --hostname 0.0.0.0
