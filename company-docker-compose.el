;;; company-docker-compose.el --- company-mode backend for docker-compose files -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Ricardo Martins

;; Author: Ricardo Martins
;; URL: https://github.com/meqif/company-docker-compose
;; Version: 0.1.0
;; Keywords: convenience
;; Package-Requires: ((emacs "24") (company "0.8.0") (cl-lib "0.5.0"))

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

(require 'company)
(require 'cl-lib)

(defgroup company-docker-compose nil
  "Company mode backend for docker-compose files."
  :group 'company
  :prefix "company-docker-compose-")

(defcustom company-docker-compose-keywords
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
  :group 'company-docker-compose)

(defun company-docker-compose--prefix ()
  "Get a prefix from the current position."
  (and (string-match-p "^docker-compose.*\.yml$" (buffer-name))
       (company-grab-line "^[\t ]+\\([a-zA-Z]+\\)" 1)))

(defun company-docker-compose--post-completion ()
  "Execute actions after completing with candidate."
  (insert ": "))

(defun company-docker-compose--candidates (prefix)
  "Obtain applicable candidates from the keywords list for the PREFIX."
  (cl-remove-if-not
   (lambda (candidate) (string-prefix-p prefix candidate))
   company-docker-compose-keywords))

;;;###autoload
(defun company-docker-compose (command &optional arg &rest ignored)
  "Company-mode completion backend for docker-compose files.
See `company-backends' for more info about COMMAND, ARG, and IGNORED."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-docker-compose))
    (prefix (company-docker-compose--prefix))
    (candidates (company-docker-compose--candidates arg))
    (post-completion (company-docker-compose--post-completion))))

(provide 'company-docker-compose)
;;; company-docker-compose.el ends here
