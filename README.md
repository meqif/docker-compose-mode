# docker-compose-mode
[![MELPA](https://melpa.org/packages/docker-compose-mode-badge.svg)](https://melpa.org/#/docker-compose-mode)
[![MELPA Stable](http://stable.melpa.org/packages/docker-compose-mode-badge.svg)](http://stable.melpa.org/#/docker-compose-mode)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Major mode for editing docker-compose files, providing context-aware completion
of docker-compose keys through `completion-at-point-functions`.

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

Functions to perform docker-compose commands are provided they are:
```
docker-compose-run-buffer
docker-compose-build-buffer
docker-compose-restart-buffer
docker-compose-stop-buffer
docker-compose-down-buffer
docker-compose-pause-buffer
docker-compose-unpause-buffer
docker-compose-start-buffer
```
They can be bound to the docker key map as follows:
```
(define-key docker-compose-mode-map (kbd "C-c C-r") #'docker-compose-run-buffer)
```


## Customization

By default, the keyword completion function detects the docker-compose version
of the current buffer and suggests the appropriate keywords.

You can change the candidates offered by the backend by customizing `docker-compose-keywords`.
