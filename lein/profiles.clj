{:user {:plugins      [[cider/cider-nrepl "0.14.0"]
                       [refactor-nrepl "1.2.0"]
                       [lein-auto "0.1.2"]
                       [lein-pprint "1.1.2"]
                       #_[nightlight/lein-nightlight "1.0.0"]
                       #_[venantius/ultra "0.4.1"]]
        :dependencies [[alembic "0.3.2"]
                       [io.forward/yaml "1.0.6"]
                       [org.clojure/tools.nrepl "0.2.10"]
                       [org.clojure/data.json "0.2.6"]
                       [pjstadig/humane-test-output "0.7.0"]
                       [spyscope "0.1.5"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}
 :pretty {:plugins    [[io.aviso/pretty "0.1.20"]]
          :dependencies [[io.aviso/pretty "0.1.20"]]}
 :repl {:java-cmd "/usr/bin/java"
        :dependencies [[alembic "0.3.2"]
                       [org.clojure/tools.nrepl "0.2.12"]]
        :plugins [[cider/cider-nrepl "0.14.0"]
                  [refactor-nrepl "2.2.0"]]}}
