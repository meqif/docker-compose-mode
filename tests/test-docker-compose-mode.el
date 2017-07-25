;;; test-docker-compose-mode.el --- Tests for docker-compose-mode -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Ricardo Martins

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

(describe "Function: `docker-compose--prefix'"
  (it "returns the partially written key in the current line"
    (with-temp-buffer
      (insert "version: '2'\nservices:\n  example:\n    underscore_\n    partial")
      ;; move point to after the underscore
      (goto-char 50)
      (expect (docker-compose--prefix) :to-equal '("underscore_" 39 50))))

  (it "returns nil when the key is suffixed with a colon"
    (with-temp-buffer
      (insert "  foo:")
      (goto-char 7)
      (expect (docker-compose--prefix) :to-equal nil))))

(describe "Function: `docker-compose--candidates'"
  (let ((candidates '("aliases" "build" "env_file" "environment")))

    (it "returns nil when no applicable candidates are available"
      (let ((docker-compose-keywords '()))
        (expect (docker-compose--candidates "en") :to-equal nil)))

    (it "returns all the applicable candidates"
      (let ((docker-compose-keywords candidates)
            (expected-candidates '("env_file" "environment")))
        (expect (docker-compose--candidates "en") :to-equal expected-candidates)))))

(provide 'test-docker-compose-mode)
;;; test-docker-compose-mode.el ends here
