

# path-from-root

A [yazi](https://github.com/sxyazi/yazi) mini-plugin to copy file path relative to git root.
The target file must be inside a git repository.

# Install

```
ya pkg add aresler/path-from-root
```

Then, add the mapping to `yazi/keymap.toml`:

```
[[manager.prepend_keymap]]
on = [ "c", "r" ]
run = "plugin path-from-root"
desc = "Copies path from git root"
```
