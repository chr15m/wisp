(ns wisp.test.runtime
  (:require [wisp.test.util :refer [is thrown?]]
            [wisp.src.runtime :refer [dictionary? vector? subs str
                                      and or = == > >= < <= + - / *]]
            [wisp.src.sequence :refer [list concat vec]]
            [wisp.src.ast :refer [symbol]]))


(is (not (dictionary? 2)) "2 is not dictionary")
(is (not (dictionary? [])) "[] is not dictionary")
(is (not (dictionary? '())) "() is not dictionary")
(is (dictionary? {}) "{} is dictionary")

(is (not (vector? 2)) "2 is not vector")
(is (not (vector? {})) "{} is not vector")
(is (not (vector? '())) "() is not vector")
(is (vector? []) "[] is vector")

(is (= '(1 2 3 4 5)
       `(1 ~@'(2 3) 4 ~@'(5))))

(is (= "lojure" (subs "Clojure" 1)))
(is (= "lo" (subs "Clojure" 1 3)))

(is (apply = [1]))
(is (apply = [1 1]))
(is (not (apply = [1 2])))
(is (apply = [1 1 1]))
(is (not (apply = [1 2 3])))
(is (apply = [1 1 1 1 1 1]))
(is (not (apply = [1 1 1 1 2 1])))

(is (apply == [1]))
(is (apply == [1 1]))
(is (not (apply == [1 2])))
(is (apply == [1 1 1]))
(is (not (apply == [1 2 3])))
(is (apply == [1 1 1 1 1 1]))
(is (not (apply == [1 1 1 1 2 1])))

(is (apply > [1]))
(is (apply > [2 1]))
(is (not (apply > [1 2])))
(is (not (apply > [1 1])))
(is (apply > [3 2 1]))
(is (not (apply > [3 2 4])))
(is (not (apply > [3 2 2])))
(is (apply > [5 4 3 2 1 0]))
(is (not (apply > [5 4 3 2 2 1])))
(is (not (apply > [5 4 3 2 3 1])))

(is (apply >= [1]))
(is (apply >= [2 1]))
(is (apply >= [2 2]))
(is (not (apply >= [1 2])))
(is (apply >= [3 2 1]))
(is (apply >= [3 2 2]))
(is (not (apply >= [3 2 4])))
(is (apply >= [5 4 3 2 2 1 0]))
(is (not (apply >= [5 4 3 2 0 1])))

(is (apply < [1]))
(is (apply < [1 2]))
(is (not (apply < [2 1])))
(is (not (apply < [2 2])))
(is (apply < [1 2 3]))
(is (not (apply < [3 2 4])))
(is (not (apply < [3 4 4])))
(is (apply < [0 1 2 3 4 5]))
(is (not (apply < [0 1 2 3 4 4])))
(is (not (apply < [0 1 2 1 4 5])))

(is (apply <= [1]))
(is (apply <= [1 2]))
(is (apply <= [2 2]))
(is (not (apply <= [2 1])))
(is (apply <= [1 2 3]))
(is (apply <= [1 2 2]))
(is (not (apply <= [4 5 3])))
(is (apply <= [0 1 2 3 4 5]))
(is (apply <= [0 1 2 3 4 4]))
(is (not (apply <= [0 1 2 1 4 5])))

(is (= 0 (apply + [])))
(is (= 1 (apply + [1])))
(is (= 3 (apply + [1 2])))
(is (= 6 (apply + [1 2 3])))
(is (= 21 (apply + [1 2 3 4 5 6])))

(is (= -1 (apply - [1])))
(is (= 3 (apply - [5 2])))
(is (= 5 (apply - [10 2 3])))
(is (= 9 (apply - [30 1 2 3 4 5 6])))

(is (= 1 (apply * [])))
(is (= 5 (apply * [5])))
(is (= 4 (apply * [2 2])))
(is (= 6 (apply * [1 2 3])))
(is (= 720 (apply * [1 2 3 4 5 6])))

(is (= 1 (apply / [1])))
(is (= 1/2 (apply / [2])))
(is (= 5/2 (apply / [5 2])))
(is (= 3 (apply / [6 2])))
(is (= 5/3 (apply / [10 2 3])))
(is (= 1/24 (apply / [30 1 2 3 4 5 6])))

(is (= true (apply and [])))
(is (= 1 (apply and [1])))
(is (= 2 (apply and [1 2])))
(is (= 2 (apply and [5 2])))
(is (= false (apply and [6 false 2])))
(is (= nil (apply and [6 4 nil 2])))
(is (= 3 (apply and [10 2 3])))
(is (= 6 (apply and [30 1 2 3 4 5 6])))
(is (= false (apply and [30 1 2 false 3 4 5 6])))
(is (= 17 (apply and [30 1 2 3 4 5 6 30 1 2 3 4 5 6 17])))

(is (= nil (apply or [])))
(is (= 1 (apply or [nil 1])))
(is (= 1 (apply or [1 nil 2])))
(is (= 5 (apply or [5 2])))
(is (= 2 (apply or [nil false 2])))
(is (= false (apply or [nil nil nil nil nil nil nil nil nil false])))
(is (= 17 (apply or [nil nil nil nil nil nil nil nil nil nil nil nil nil 17 18])))


(is (apply = []))
(is (apply = [1 1]))
(is (not (apply = [1 2])))
(is (not (apply = [1 "1"])))
(is (not (apply = [1 :1])))
(is (not (apply = ["b" 'b])))
(is (apply = [[] []]))
(is (apply = [[1] [1]]))
(is (apply = [[1 2] [1 2]]))
(is (not (apply = [[1 2] [2 1]])))
(is (not (apply = [[1 2] [1 2 3]])))
(is (apply = [[1 2 [3 [4 5]]] [1 2 [3 [4 5]]]]))
(is (apply = [[1 2 [3 [4 5]]] [1 2 [3 [4 5]]] [1 2 [3 [4 5]]]]))
(is (not (apply = [[1 2 [3 [4 5]]] [1 2 [3 [4 5]]] [1 2 [3 [4 4]]]])))
(is (apply = [#"foo" #"foo"]))
(is (not (apply = [#"(?i)foo" #"foo"])))
(is (not (apply = [#"(?i)foo" #"(?m)foo"])))
(is (apply = [#"(?i)foo" #"(?i)foo"]))
(is (apply = [#"(?mi)foo" #"(?im)foo"]))
(is (not (apply = [#"(?mi)foo" #"(?im)foo" "?(i)foo"])))
(is (not (apply = [#"foo" "foo"])))
(is (not (apply = [#"foo" 1])))
(is (not (apply = ["foo" 1])))
(is (not (apply = ["foo" ["foo"]])))
(is (not (apply = ["foo" ["f" "o" "o"]])))
(is (apply = ['() '()]))
(is (apply = ['(foo bar) '(foo bar)]))
(is (not (apply = ['(foo bar) '(bar foo)])))
(is (not (apply = ['(foo bar) '(foo bar baz)])))
(is (not (apply = ['(foo bar) '(foo :bar)])))
(is (not (apply = ['(foo bar) '(foo "bar")])))
(is (apply = [{} {}]))
(is (apply = [{:x 1} {:x 1}]))
(is (not (apply = [{:x 1} {:x 2}])))
(is (not (apply = [{:x 1} {:x 1 :y 2}])))
(is (not (apply = [{:x 2 :y 1} {:x 1 :y 2}])))
(is (apply = [{:x 1 :y 1} {:y 1 :x 1}]))
(is (not (apply = [{:x 1 :y 2} {:y 1 :x 2}])))
(is (apply = [{:x 1 :y [2 [3 {:z 4}]]} {:x 1 :y [2 [3 {:z 4}]]}]))
(is (not (apply = [{:x 1 :y [2 [3 {:z 4}]]} {:x 1 :y [2 [3 {:z 4}]]} {}])))
(is (apply = [{:x 1 :y [2 [3 {:z 4}]]}
              {:x 1 :y [2 [3 {:z 4}]]}
              {:x 1 :y [2 [3 {:z 4}]]}
              {:x 1 :y [2 [3 {:z 4}]]}]))
