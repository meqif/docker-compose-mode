;;; docker-compose-mode.el --- major mode for editing docker-compose files -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Ricardo Martins

;; Author: Ricardo Martins
;; URL: https://github.com/meqif/docker-compose-mode
;; Version: 0.1.0
;; Keywords: convenience
;; Package-Requires: ((emacs "24.3") (dash "2.12.0"))

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;; http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;; Commentary:

;; See the README for more details.

;;; Code:

(require 'dash)

(defgroup docker-compose nil
  "Major mode for editing docker-compose files."
  :group 'languages
  :prefix "docker-compose-")

(defcustom docker-compose-keywords
  '("aliases" "args" "bridge" "build" "cache_from" "cap_add" "cap_drop"
    "cgroup_parent" "command" "configs" "container_name" "context"
    "credential_spec" "depends_on" "deploy" "devices" "dns" "dns_search"
    "dockerfile" "domainname" "driver" "driver" "driver_opts" "driver_opts"
    "enable_ipv6" "entrypoint" "env_file" "environment" "expose" "external"
    "external" "external_links" "extra_hosts" "healthcheck" "hostname" "image"
    "internal" "ipam" "ipc" "ipv4_address" "ipv6_address" "isolation" "labels"
    "labels" "labels" "labels" "labels" "links" "logging" "mac_address" "mode"
    "network_mode" "networks" "overlay" "pid" "placement" "ports" "privileged"
    "read_only" "replicas" "resources" "restart" "restart_policy" "secrets"
    "security_opt" "shm_size" "stdin_open" "stop_grace_period" "stop_signal"
    "sysctls" "tmpfs" "tty" "ulimits" "update_config" "user" "userns_mode"
    "volumes" "working_dir")
  "List of docker-compose keywords."
  :type '(repeat string)
  :group 'docker-compose)

(defun docker-compose--post-completion (_string status)
  "Execute actions after completing with candidate.
Read the documentation for the `completion-extra-properties'
variable for additional information about STRING and STATUS."
  (when (eq status 'finished)
    (insert ": ")))

(defun docker-compose--candidates (prefix)
  "Obtain applicable candidates from the keywords list for the PREFIX."
  (--filter (string-prefix-p prefix it) docker-compose-keywords))

(defun docker-compose--prefix ()
  "Get a prefix and its starting and ending points from the current position."
  (save-excursion
    (beginning-of-line)
    (when (looking-at "^[\t ]+\\([a-zA-Z][a-zA-Z0-9_]+\\)$")
      (list (match-string-no-properties 1) (match-beginning 1) (match-end 1)))))

(defun docker-compose--keyword-complete-at-point ()
  "`completion-at-point-functions' function for docker-compose keywords."
  (-let (((prefix start end) (docker-compose--prefix)))
    (when start
      (list start end (docker-compose--candidates prefix)
            :exclusive 'yes
            :company-docsig #'identity
            :exit-function #'docker-compose--post-completion))))

;;;###autoload
(define-derived-mode docker-compose-mode yaml-mode "docker-compose"
  "Major mode to edit docker-compose files."
  (setq-local completion-at-point-functions
              '(docker-compose--keyword-complete-at-point)))

;;;###autoload
(add-to-list 'auto-mode-alist
             '("docker-compose.*\.yml\\'" . docker-compose-mode))

(provide 'docker-compose-mode)
;;; docker-compose-mode.el ends here
