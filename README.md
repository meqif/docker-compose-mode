# docker-compose-mode
[![MELPA](https://melpa.org/packages/docker-compose-mode-badge.svg)](https://melpa.org/#/docker-compose-mode)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Major mode for editing docker-compose files, providing completion of
docker-compose keys through `completion-at-point-functions`.

The completions can be used with the completion system shipped with vanilla
Emacs, and 3rd-party frontends like company-mode, autocomplete, and
ido-at-point.

## Installation

It's available on [MELPA](https://melpa.org/#/docker-compose-mode):

```
M-x package-install docker-compose-mode
```

Or you can just save the `.el` files in your Emacs' load path.

## Usage

Add the following to your `init.el`:

``` emacs-lisp
(require 'docker-compose-mode)
```

Alternatively, if you prefer using `use-package`:

``` emacs-lisp
(use-package docker-compose-mode)
```

## Customization

By default, the keyword completion function suggests docker-compose 3.3 keywords.

You can change the candidates offered by the backend by customizing `docker-compose-keywords`.
