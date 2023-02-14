# Burger-Challenge

## Your Task

For a burger order the total price is to be calculated. For a burger order several burgers can be ordered, per burger the desired size and also special requests (extra ingredients and omit ingredients) can be specified. In addition, there is a possibility to reduce the price of the order by using various discount codes.

* The price of a burger depends on the size. There is a "multiplier" per size, which is multiplied by the base price of the burger.
* Extra ingredients are also given this multiplier.
* Ingredients that are omitted during preparation do not change the price of the burger.
* Promotion codes allow to get burgers for free; e.g. two small bacon burgers for the price of one. Extra ingredients will still be charged though. Multiple promotion codes can be specified per order. A promotion code can also be applied more than once to the same order (a 2-for-1 code automatically reduces 4 burgers to 2 for one order).
* A discount code reduces the total invoice amount by a percentage.

## Whats in this Repoistory

The repository contains the basic structure for the development, the required data in JSON format and a failing test to start the development. Furthermore there is a Dockerfile that can be used to run the tests in case you dont have ruby installed locally.

In `lib/data.json` you can find the list of selectable burgers, the multipliers and ingredients as well as the promotion and discount codes.

You should start with

```shell
bundle
bundle exec rspec
```
or
```shell
docker build . -t burger-order:0.1
docker run -v ~/path/to/project/.:/workspace burger-order:0.1 bundle exec rspec
```

to run tests and then start with the development :)

## What we expect

A complete implementation of the solution allows the test in `spec/burger_order_spec.rb` to run successfully without any customization of the test or additional setup. Of course, the implementation should also provide the correct results for other valid orders. Feel free to write additional test cases.

## How to work

* Explain your decisions and share your solution with us.
* Structure the code the way you think is right and makes sense. We are interested in you building a solution that you are happy with, not speed.
* Work with this repo as if it were a real project repo, i.e. add all source files and make use of Git.
* Create a git branch with your code customizations and put a pull request on the master branch, and let us know via @mention when to review the code.
* If you have questions in the meantime, please also ask them via Github; either via comment in the open pull request or via a separate issue.
