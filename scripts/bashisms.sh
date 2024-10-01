#!/bin/sh

# Bashism 1: Use of [[ instead of [
if [[ -f /etc/passwd ]]; then
    echo "File exists"
fi

# Bashism 2: Use of 'let' to do arithmetic
let x=1+1
echo $x

# Bashism 3: Use of 'echo -e' to enable escape sequences (not POSIX)
echo -e "Hello\nWorld"

# Bashism 4: 'function' keyword for defining functions (POSIX uses 'foo()')
function my_func() {
    echo "This is a bashism function"
}

my_func