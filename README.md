![Test multiple format rendering](https://github.com/lc5415/rmarkdown-action/workflows/Test%20multiple%20format%20rendering/badge.svg)

# rmarkdown-action

Github action to render documents using rmarkdown. Uses `rocker/r-rmd` docker image which includes rmardkown, pandoc and latex.

## Inputs

* `input_file`: path or name of input file, all with respect to root directory of the repo (e.g: `my_doc.Rmd`, `path/to/my_doc.Rmd`)
* `output_format`: (defaults to `pdf_document`), options are: `word_document`, `html_document` and `pdf_document`.

## Outputs 

* `output_file`: This is automatically generated as the name that precedes `.Rmd` + the output format extension (e.g: for `my_doc.Rmd` with `output_format` as `pdf_document` -> `my_doc.pdf`

## Example

```yaml
name: Render documents with rmarkdown-action
on: [push]
jobs:
  render_document:
    runs-on: ubuntu-latest
    steps:
      - name: Set up Git repository
        uses: actions/checkout@v2
      - name: Render document
        uses: lc5415/rmarkdown-action@v1
        with:
          input_file: path/to/my_doc.Rmd
	  output_format: pdf_document
```

## Other powerful usages

### Uploading rendered document to GitHub

This makes use of the [github-push-action](https://github.com/ad-m/github-push-action) to automatically upload the rendered document to the branch that trigerred the rmarkdown-action. This is useful when the quality of the rendering needs to be reviewed as well (which is almost always the case).

```yaml
name: Render documents and upload

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  render_document:
    runs-on: ubuntu-latest
    steps:
      - name: Set up Git repository
        uses: actions/checkout@v2
      - name: Render document
        uses: lc5415/rmarkdown-action@v1
        with:
          input_file: path/to/my_doc.Rmd
	  output_format: pdf_document
      - name: Commit files
        run: |
          git config --local core.autocrlf false
          git config --local user.email "${{ github.actor }}@users.noreply.github.com"
          git config --local user.name "${{ github.actor }}"
          git add . && git add --renormalize .
          git pull origin ${{ github.head_ref }} --autostash --rebase -X ours
          git commit --allow-empty -am "AUTO-GH ACTION: ${{ github.workflow }}"
          NO_PAGER=1 git --no-pager diff HEAD^
      - name: Push changes
        uses: ad-m/github-push-action@master
        with:
          branch: ${{ github.head_ref }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```
