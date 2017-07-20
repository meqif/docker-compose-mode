# company-docker-compose

Company-mode backend for docker-compose files, providing completion of
docker-compose keys.

## Installation

You will soon be able to install this package from Melpa. Meanwhile, you'll have
to save the `.el` files in your Emacs' load path.

## Usage

Manually:

``` emacs-lisp
(require 'company-docker-compose)

(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-docker-compose))
```

Alternatively, if you're using `use-package`:

``` emacs-lisp
(use-package company-docker-compose
  :after company
  :config
  (add-to-list 'company-backends 'company-docker-compose))
```

## Customization

By default, company-docker-compose suggests docker-compose 3.3 keywords for completion.

You can change the keyword candidates offered by this backend by customizing `company-docker-compose-keywords`.
