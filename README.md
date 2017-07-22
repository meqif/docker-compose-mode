# docker-compose-mode

Major mode for editing docker-compose files, providing completion of
docker-compose keys through `completion-at-point-functions`.

The completions can be used with the completion system shipped with vanilla
Emacs, and 3rd-party frontends like company-mode, autocomplete, and
ido-at-point.

## Installation

You will soon be able to install this package from Melpa. Meanwhile, you'll have
to save the `.el` files in your Emacs' load path.

## Usage

Manually:

``` emacs-lisp
(require 'docker-compose-mode)
```

Alternatively, if you're using `use-package`:

``` emacs-lisp
(use-package docker-compose-mode)
```

## Customization

By default, the keyword completion function suggests docker-compose 3.3 keywords.

You can change the candidates offered by the backend by customizing `docker-compose-keywords`.
