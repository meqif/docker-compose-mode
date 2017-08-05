;;; docker-compose-mode-helpers.el --- Helper functions for docker-compose-mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Ricardo Martins

;; Author: Ricardo Martins

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

;;; Code:

(require 'docker-compose-mode)
(require 'f)
(require 'json)

(defun docker-compose--extract-keywords-from-schema-tree (tree)
  "Extract a list of keywords from docker-compose JSON schema TREE."
  (-flatten
   (--map
    (pcase it
      (`("definitions" . ,rest) (docker-compose--read-definitions rest))
      (`("properties" . ,rest) (docker-compose--read-properties rest))
      (`("patternProperties" . ,rest) (docker-compose--read-pattern-properties rest)))
    tree)))

(defun docker-compose--read-definitions (definitions)
  "Extract keywords from a DEFINITIONS node in the docker-compose schema tree."
  (--map
   (pcase it
     (`("service" . ,rest)
      (docker-compose--extract-keywords-from-schema-tree rest)))
   definitions))

(defun docker-compose--read-pattern-properties (pattern-properties)
  "Extract keywords from a PATTERN-PROPERTIES node in the docker-compose schema tree."
  (--map
   (pcase it
     (`(,_keyword . (("oneOf" . ,rest)))
      (--map (docker-compose--extract-keywords-from-schema-tree it) rest)))
   pattern-properties))

(defun docker-compose--read-properties (properties)
  "Extract keywords from a PROPERTIES node in the docker-compose schema tree."
  (--map
   (pcase it
     (`(,keyword . (("type" . ,_type) . ,rest))
      (cons keyword
            (docker-compose--extract-keywords-from-schema-tree rest)))
     (`(,keyword . (("$ref" . ,_reference))) keyword)
     (`(,keyword . (("oneOf" . ,alternatives)))
      (cons keyword
            (--map (docker-compose--extract-keywords-from-schema-tree it)
             alternatives))))
   properties))

(defun docker-compose--extract-keywords-from-schema-file (path)
  "Extract a list of keywords from the docker-compose JSON schema file at PATH."
  (let ((json-key-type 'string))
    (docker-compose--extract-keywords-from-schema-tree (json-read-file path))))

(defun docker-compose--generate-lists-of-keywords (path)
  "Generate a list of lists of docker-compose keywords by extracting them from the schema files present in PATH."
    (--map
     (progn
       (string-match "config_schema_v\\(.*\\).json" it)
       (cons (docker-compose--normalize-version (match-string-no-properties 1 it))
             (sort (docker-compose--extract-keywords-from-schema-file it) #'string<)))
     (f-glob "config_schema_*.json" path)))

(provide 'docker-compose-mode-helpers)
;;; docker-compose-mode-helpers.el ends here
