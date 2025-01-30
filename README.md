# Tom's Clean Slate

My base setup for when I eventually break something I don't understand and need a clean slate.

### How to Use

Clone the repository to your Kubuntu system. Navigate to the directory containing the Makefile and run:

```bash
make
```

Note: The @exec zsh line will replace the current shell process with zsh immediately after installation. This means:

The Makefile execution will appear to "end" when it reaches this point. Any remaining commands will execute in the new zsh shell. You'll need to restart the Makefile after zsh loads to complete any remaining targets.
