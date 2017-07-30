;;; docker-compose-mode.el --- major mode for editing docker-compose files -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Ricardo Martins

;; Author: Ricardo Martins
;; URL: https://github.com/meqif/docker-compose-mode
;; Version: 0.2.0
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

;; Major mode for editing docker-compose files, providing completion of
;; docker-compose keys through completion-at-point-functions.
;;
;; The completions can be used with the completion system shipped with vanilla
;; Emacs, and 3rd-party frontends like company-mode, autocomplete, and
;; ido-at-point.
;;
;; By default, the keyword completion function detects the docker-compose
;; version of the current buffer and suggests the appropriate keywords.
;;
;; See the README for more details.

;;; Code:

(require 'dash)

(defgroup docker-compose nil
  "Major mode for editing docker-compose files."
  :group 'languages
  :prefix "docker-compose-")

(defcustom docker-compose-keywords
  '(
    ("1.0" . ("build" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "cpu_quota" "cpu_shares" "cpuset" "devices" "dns" "dns_search" "dockerfile" "domainname" "entrypoint" "env_file" "environment" "expose" "extends" "external_links" "extra_hosts" "file" "hard" "hostname" "image" "ipc" "labels" "links" "log_driver" "log_opt" "mac_address" "mem_limit" "mem_swappiness" "memswap_limit" "net" "pid" "ports" "privileged" "read_only" "restart" "security_opt" "service" "shm_size" "soft" "stdin_open" "stop_signal" "tty" "ulimits" "user" "volume_driver" "volumes" "volumes_from" "working_dir"))
    ("2.0" . ("aliases" "args" "build" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "context" "cpu_quota" "cpu_shares" "cpuset" "depends_on" "devices" "dns" "dns_opt" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "extends" "external_links" "extra_hosts" "file" "group_add" "hard" "hostname" "image" "ipc" "ipv4_address" "ipv6_address" "labels" "links" "logging" "mac_address" "mem_limit" "mem_reservation" "mem_swappiness" "memswap_limit" "network_mode" "networks" "oom_score_adj" "options" "pid" "ports" "privileged" "read_only" "restart" "security_opt" "service" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "tmpfs" "tty" "ulimits" "user" "version" "volume_driver" "volumes" "volumes_from" "working_dir"))
    ("2.1" . ("aliases" "args" "build" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "context" "cpu_quota" "cpu_shares" "cpuset" "depends_on" "devices" "dns" "dns_opt" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "extends" "external_links" "extra_hosts" "file" "group_add" "hard" "healthcheck" "hostname" "image" "ipc" "ipv4_address" "ipv6_address" "isolation" "labels" "labels" "link_local_ips" "links" "logging" "mac_address" "mem_limit" "mem_reservation" "mem_swappiness" "memswap_limit" "network_mode" "networks" "oom_score_adj" "options" "pid" "pids_limit" "ports" "privileged" "read_only" "restart" "security_opt" "service" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "storage_opt" "sysctls" "tmpfs" "tty" "ulimits" "user" "userns_mode" "version" "volume_driver" "volumes" "volumes_from" "working_dir"))
    ("2.2" . ("aliases" "args" "build" "cache_from" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "context" "cpu_count" "cpu_percent" "cpu_quota" "cpu_shares" "cpus" "cpuset" "depends_on" "devices" "dns" "dns_opt" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "extends" "external_links" "extra_hosts" "file" "group_add" "hard" "healthcheck" "hostname" "image" "init" "ipc" "ipv4_address" "ipv6_address" "isolation" "labels" "labels" "link_local_ips" "links" "logging" "mac_address" "mem_limit" "mem_reservation" "mem_swappiness" "memswap_limit" "network" "network_mode" "networks" "oom_score_adj" "options" "pid" "pids_limit" "ports" "privileged" "read_only" "restart" "scale" "security_opt" "service" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "storage_opt" "sysctls" "tmpfs" "tty" "ulimits" "user" "userns_mode" "version" "volume_driver" "volumes" "volumes_from" "working_dir"))
    ("2.3" . ("aliases" "args" "build" "cache_from" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "context" "cpu_count" "cpu_percent" "cpu_quota" "cpu_shares" "cpus" "cpuset" "depends_on" "devices" "dns" "dns_opt" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "extends" "external_links" "extra_hosts" "file" "group_add" "hard" "healthcheck" "hostname" "image" "init" "ipc" "ipv4_address" "ipv6_address" "isolation" "labels" "labels" "link_local_ips" "links" "logging" "mac_address" "mem_limit" "mem_reservation" "mem_swappiness" "memswap_limit" "network" "network_mode" "networks" "oom_score_adj" "options" "pid" "pids_limit" "ports" "privileged" "read_only" "restart" "scale" "security_opt" "service" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "storage_opt" "sysctls" "target" "tmpfs" "tty" "ulimits" "user" "userns_mode" "version" "volume_driver" "volumes" "volumes_from" "working_dir"))
    ("3.0" . ("aliases" "args" "build" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "context" "depends_on" "deploy" "devices" "dns" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "external_links" "extra_hosts" "hard" "healthcheck" "hostname" "image" "ipc" "ipv4_address" "ipv6_address" "labels" "links" "logging" "mac_address" "network_mode" "networks" "options" "pid" "ports" "privileged" "read_only" "restart" "security_opt" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "sysctls" "tmpfs" "tty" "ulimits" "user" "userns_mode" "version" "volumes" "working_dir"))
    ("3.1" . ("aliases" "args" "build" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "context" "depends_on" "deploy" "devices" "dns" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "external_links" "extra_hosts" "hard" "healthcheck" "hostname" "image" "ipc" "ipv4_address" "ipv6_address" "labels" "links" "logging" "mac_address" "network_mode" "networks" "options" "pid" "ports" "privileged" "read_only" "restart" "secrets" "security_opt" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "sysctls" "tmpfs" "tty" "ulimits" "user" "userns_mode" "version" "volumes" "working_dir"))
    ("3.2" . ("aliases" "args" "build" "cache_from" "cap_add" "cap_drop" "cgroup_parent" "command" "container_name" "context" "depends_on" "deploy" "devices" "dns" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "external_links" "extra_hosts" "hard" "healthcheck" "hostname" "image" "ipc" "ipv4_address" "ipv6_address" "labels" "links" "logging" "mac_address" "network_mode" "networks" "options" "pid" "ports" "privileged" "read_only" "restart" "secrets" "security_opt" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "sysctls" "tmpfs" "tty" "ulimits" "user" "userns_mode" "version" "volumes" "working_dir"))
    ("3.3" . ("aliases" "args" "build" "cache_from" "cap_add" "cap_drop" "cgroup_parent" "command" "configs" "container_name" "context" "credential_spec" "depends_on" "deploy" "devices" "dns" "dns_search" "dockerfile" "domainname" "driver" "entrypoint" "env_file" "environment" "expose" "external_links" "extra_hosts" "file" "hard" "healthcheck" "hostname" "image" "ipc" "ipv4_address" "ipv6_address" "labels" "labels" "links" "logging" "mac_address" "network_mode" "networks" "options" "pid" "ports" "privileged" "read_only" "registry" "restart" "secrets" "security_opt" "shm_size" "soft" "stdin_open" "stop_grace_period" "stop_signal" "sysctls" "tmpfs" "tty" "ulimits" "user" "userns_mode" "version" "volumes" "working_dir")))
  "Association list of docker-compose keywords for each version."
  :type '(alist :key-type string :value-type (repeat string))
  :group 'docker-compose)

(defun docker-compose--find-version ()
  "Find the version of the docker-compose file.
It is assumed that files lacking an explicit 'version' key are
version 1."
  (save-excursion
    (goto-char (point-min))
    (if (looking-at "^version:\s*[\\'\"]?\\([2-9]\\(?:\.[0-9]\\)?\\)[\\'\"]?$")
        (match-string-no-properties 1)
      "1.0")))

(defun docker-compose--normalize-version (version)
  "Normalize VERSION to conform to <major>.<minor>."
  (if (string-match-p "^[0-9]$" version)
      (concat version ".0")
    version))

(defun docker-compose--keywords-for-buffer ()
  "Obtain keywords appropriate for the current buffer's docker-compose version."
  (let ((version
         (docker-compose--normalize-version (docker-compose--find-version))))
    (cdr (assoc version docker-compose-keywords))))

(defun docker-compose--post-completion (_string status)
  "Execute actions after completing with candidate.
Read the documentation for the `completion-extra-properties'
variable for additional information about STRING and STATUS."
  (when (eq status 'finished)
    (insert ": ")))

(defun docker-compose--candidates (prefix)
  "Obtain applicable candidates from the keywords list for the PREFIX."
  (--filter (string-prefix-p prefix it) (docker-compose--keywords-for-buffer)))

(defun docker-compose--prefix ()
  "Get a prefix and its starting and ending points from the current position."
  (save-excursion
    (beginning-of-line)
    (when (looking-at "^[\t ]+\\([a-zA-Z][a-zA-Z0-9_]+\\)$")
      (list (match-string-no-properties 1) (match-beginning 1) (match-end 1)))))

(defun docker-compose--keyword-complete-at-point ()
  "`completion-at-point-functions' function for docker-compose keywords."
  (-when-let* (((prefix start end) (docker-compose--prefix)))
    (list start end (docker-compose--candidates prefix)
          :exclusive 'yes
          :company-docsig #'identity
          :exit-function #'docker-compose--post-completion)))

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
