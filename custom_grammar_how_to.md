# Custom TreeSitter Grammar in Helix

**Important**: `lolcode` must not be uppercase!

- Make sure the command `tree-sitter` is available.
- Create a folder called `tree-sitter-lolcode` and `cd` into it.
- `tree-sitter-generate`
- Edit `grammar.js`:

```javascript
module.exports = grammar({
  name: "lolcode",

  rules: {
    // The main entry point for the grammar
    source_file: ($) => repeat($.comment),

    // Define what a comment looks like
    // For example
    comment: ($) =>
      choice(
        seq("BTW", /[^\n]*/), // Matches comments that start with BTW
      ),
  },
});
```

- Edit `package.json` and add the "file-types" and "highlights" to the entry "tree-sitter":

```json
"scope": "source.lolcode",
"file-types": [
  "lol"
],
"highlights": "queries/highlights.scm",
```

- Make a folder called `queries` and put a file called `highlights.scm` in it:

```
; a comment
(comment) @comment
```

- Make a folder called `scripts` and put a file called `copy_queries_to_helix.sh` in it.

```shell
#!/bin/bash

mkdir -p ~/.config/helix/runtime/queries/lolcode
cp ../queries/highlights.scm ~/.config/helix/runtime/queries/lolcode/highlights.scm
```

- Make folder `test/corpus` and put a file called `comment.txt` in them:

```
===============================================================================
Parsing goal
===============================================================================
.\" -*- mode: text; coding: utf-8; -*-
\#
.\" Local Variables:

-------------------------------------------------------------------------------


(source_file
  (comment)
  (comment)
  (comment))
```

- Call `tree-sitter test` (optional)
- Call `tree-sitter generate`
- To test your parser, call `tree-sitter parse <file>`
- To test syntax highlighting, call `tree-sitter highlight <file>`
- Push your repo to GitHub
- In `~/.config/helix/languages.toml`:

```toml
[[language]]
name = "lolcode"
scope = "source.lolcode"
file-types = ["lol"]

[[grammar]]
name = "lolcode"
# Put in `main` if your main branch is called `main`
source = { git = "<Your GitHub URL>", rev = "master" }
```

- `helix -g fetch`
- `helix -g build`
- Change directory to `~/.config/helix/runtime/grammars/sources/lolcode/scripts/`
- Call `copy_queries_to_helix.sh`. Every time you update `highlights.scm`, you must call this script from within the folder in which it is located

# Useful Sources

- [Let's create a Tree-sitter grammar](https://www.jonashietala.se/blog/2024/03/19/lets_create_a_tree-sitter_grammar/)
- [Creating parsers](https://tree-sitter.github.io/tree-sitter/creating-parsers)
- [Guide to your first Tree-sitter grammar](https://gist.github.com/Aerijo/df27228d70c633e088b0591b8857eeef)
- [How to write a tree-sitter grammar in an afternoon](https://siraben.dev/2022/03/01/tree-sitter.html#editor-integration)
- [Add tree-sitter grammar to helix](https://github.com/helix-editor/helix/blob/5b3dd6a678ba138ea21d7d5dd8d3c8a53c7a6d3b/book/src/languages.md#tree-sitter-grammar-configuration)
- [tree-sitter-highlight](https://jeffkreeftmeijer.com/tree-sitter-highlight/)
- [custom helix syntax highlight hack](https://github.com/TudbuT/tree-sitter-spl/blob/main/install-helix.spl)
- [Adding new languages to Helix](https://docs.helix-editor.com/guides/adding_languages.html)
