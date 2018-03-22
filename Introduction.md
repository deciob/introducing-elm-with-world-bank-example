* **Elm** is a typed pure functional programming language that compiles to JavaScript
* It was created specifically for Web Development (It is not a general purpose language)

#### Why use elm?
(From the point of view of a JavaScript developer with little prior experience about funcional programming)

* **No runtime errors in the browser**
  * No such thing as *null values* or [try...catch](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/try...catch)
  * [Maybe](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Maybe) and [Result](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Result) forces you to account for all possibilities, otherwise the code will not compile.
  * The compiler can also help you with friedly error messages and hints and it is great when refactoring.
  * Unit tests are still important. The compiler will avoid formal errors, but can not guess what you are trying to do!
  
* **Immutable data**
  * In JavaScript it can sometimes be handy to mutate the data, but this can open up to unespected and nasty bugs, and sometimes it is even difficult to tell if you actually mutating the data or not.
  * Forcing immutability in JavaScript in a consistent and efficient way is possible (see for example [immutable.js](https://facebook.github.io/immutable-js/), but it becomes something more to learn and to keep track of in your code, plus it is easy to back out in any moment.
  * Whith elm you have no alternatives and you have immutable data out of the box.
  
* **Pure functions**
  * All side effects are managed by the elm runtime through commands.
  * Inside an elm application you only deal with pure funcions. Calling the same function with the same arguments will always return the same value.
  * This also makes testing very easy.
  
* **You can introduce elm into your app progressively**
  * No need to make a big commitment at the beginning. You can try it out on small parts of your application and see how it works out for you.
  * Elm can also communicate with JavaScript via ports. Handy if you need some functionality from an external JavaScript library.
  
* **Elm will make you a better JavaScript programmer**
  * Makes you more disciplined 
  * Helps you to better realize some JavaScript pitfalls


### The elm architecture

* **MODEL**: the state of your application
* **VIEW**: a whay to view the state as HTML
* **UPDATE**: a whay to update the state

The update and the view functions are never called directly within our application. Instead we sent messages and commands to the elm runtime. [Redux](https://redux.js.org/introduction) is inspired by the elm architecture
