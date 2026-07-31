# ML for Java Minds

A 34-chapter book, built as a [Jupyter Book](https://jupyterbook.org) (MyST Document Engine) static site.

## Structure

```
ml-for-java-minds/
├── myst.yml              # project config + table of contents (chapter order)
├── index.md               # front matter, "how to read this book", full TOC
├── references.md          # Back matter - official sources behind this book
├── part1/                 # Beginner:      chapters 1-9
├── part2/                 # Intermediate:  chapters 10-21
├── part3/                 # Advanced:      chapters 22-29
├── part4/                 # Professional:  chapters 30-34
└── build.sh                # checks/installs the myst CLI and builds static HTML
```

Each chapter is its own Markdown file, named `NN-slug.md` (e.g. `part1/06-training-vs-inference.md`).

## Cross-references (automatic, reorder-safe)

- Every chapter starts with a MyST label: `(ch-06)=`
- Every in-text mention of "Chapter N" / "Chapters N-M" was rewritten as a link to that
  label, e.g. `[Chapter 6](#ch-06)`. MyST resolves these project-wide, from any file,
  regardless of chapter order — so nothing breaks if you reorder or insert chapters.
- Each chapter ends with a Previous / Table of Contents / Next navigation footer.

## Inserting a new chapter

1. Add a new file, e.g. `part2/12b-my-new-topic.md`, starting with a unique label:
   ```markdown
   (ch-12b)=
   # 12b. My New Topic
   ...
   ```
2. Add it to `myst.yml` under the right part's `children:` list, in the position you want.
3. (Optional) Update the neighboring chapters' nav footers / `index.md` TOC if you want
   them to mention it by number.
4. Rebuild: `./build.sh`

Existing cross-references to other chapters keep working untouched — labels aren't
positional, so nothing needs renumbering.

## Diagrams

Mermaid diagrams (` ```mermaid ` fenced code blocks) are used throughout and render
natively in the built site.

## Building

```bash
./build.sh              # build AND launch a working local preview automatically
./build.sh build-only   # just build _build/html, no server (for CI/deploy)
./build.sh serve     # live-reloading local preview
./build.sh clean     # remove build artifacts
```

The script checks for the `myst` CLI and installs it via `pip install mystmd` if missing
(no manual Node.js setup required in the common case).

## Publishing

`_build/html` is a complete static site — deploy it anywhere:

- **GitHub Pages**: `myst init --gh-pages` generates a ready-to-use GitHub Actions workflow.
- **Any static host** (Netlify, Cloudflare Pages, S3, nginx): just upload the contents of `_build/html`.

No reader accounts, no paywalls, no server required.
