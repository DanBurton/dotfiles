Python repl broken? Try something like this.

Test for the problem, see what version it needs:

>>> import readline
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: dlopen(/Users/dan/.pyenv/versions/3.5.6/lib/python3.5/lib-dynload/readline.cpython-35m-darwin.so, 2): Library not loaded: /usr/local/opt/readline/lib/libreadline.7.dylib
  Referenced from: /Users/dan/.pyenv/versions/3.5.6/lib/python3.5/lib-dynload/readline.cpython-35m-darwin.so
  Reason: image not found

Pretend like you have that version:

$ cd /usr/local/opt/readline/lib
$ ln -s libreadline.8.dylib libreadline.7.dylib
